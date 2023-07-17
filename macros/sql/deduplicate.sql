{%- macro deduplicate(relation, partition_by, order_by) -%}
    {{ return(adapter.dispatch('deduplicate', 'dbt_utils')(relation, partition_by, order_by, **kwargs)) }}
{% endmacro %}

{#
-- ⚠️ This macro drops rows that contain NULL values ⚠️

-- The implementation below uses a natural join which avoids returning an
-- extra column at the cost of not being null safe.

-- dbt_utils._safe_deduplicate is an alternative that avoids dropping rows
-- that contain NULL values at the cost of adding an extra column.
#}
{%- macro _unsafe_deduplicate(relation, partition_by, order_by) -%}

{%- set error_message = "
Warning: the implementation of the `deduplicate` macro for the `{}` adapter is not null safe. \

Set `row_alias` within calls to `deduplicate` to achieve null safety (which will also add it \
as an extra column to the output).

e.g.,
    {{
        dbt_utils.deduplicate(
            'my_cte',
            partition_by='user_id',
            order_by='version desc',
            row_alias='rn'
        ) | indent
    }}

Warning triggered by model: {}.{}
dbt project / package: {}
path: {}
".format(target.type, model.package_name, model.name, model.package_name, model.original_file_path) -%}

{%- do exceptions.warn(error_message) -%}

    with row_numbered as (
        select
            _inner.*,
            row_number() over (
                partition by {{ partition_by }}
                order by {{ order_by }}
            ) as rn
        from {{ relation }} as _inner
    )

    select
        distinct data.*
    from {{ relation }} as data
    {#
    -- Not all DBs will support natural joins but the ones that do include:
    -- Oracle, MySQL, SQLite, Redshift, Teradata, Materialize, Databricks
    -- Apache Spark, SingleStore, Vertica
    -- Those that do not appear to support natural joins include:
    -- SQLServer, Trino, Presto, Rockset, Athena
    #}
    natural join row_numbered
    where row_numbered.rn = 1

{%- endmacro -%}

{#
-- For data platforms that don't support QUALIFY or an equivalent, the
-- best we can do to ensure null safety is to use a window function +
-- filter (which returns an extra column):
-- https://modern-sql.com/caniuse/qualify
#}
{%- macro _safe_deduplicate(relation, partition_by, order_by, row_alias="rn", columns=none) -%}

    {% if not row_alias %}
        {% set row_alias = "rn" %}
    {% endif %}

    with row_numbered as (
        select

        {% if columns != None %}
            {% for column in columns %}
            {{ column }},
            {% endfor %}
        {% else %}
            _inner.*,
        {% endif %}

            row_number() over (
                partition by {{ partition_by }}
                order by {{ order_by }}
            ) as {{ row_alias }}
        from {{ relation }} as _inner
    )

    select *
    from row_numbered
    where {{ row_alias }} = 1

{%- endmacro -%}

{#
-- ⚠️ This macro drops rows that contain NULL values unless the `row_alias` parameter is included ⚠️
#}
{%- macro default__deduplicate(relation, partition_by, order_by) -%}
    {% set row_alias = kwargs.get('row_alias') %}
    {% set columns = kwargs.get('columns') %}

    {% if relation.is_cte is defined and not relation.is_cte %}
        {% set columns = dbt_utils.get_filtered_columns_in_relation(relation) %}
        {{ dbt_utils._safe_deduplicate(relation, partition_by, order_by, columns=columns) }}
    {% elif row_alias != None or columns != None %}
        {{ dbt_utils._safe_deduplicate(relation, partition_by, order_by, row_alias=row_alias, columns=columns) }}
    {% else %}
        {{ dbt_utils._unsafe_deduplicate(relation, partition_by, order_by) }}
    {% endif %}

{%- endmacro -%}

-- Redshift has the `QUALIFY` syntax:
-- https://docs.aws.amazon.com/redshift/latest/dg/r_QUALIFY_clause.html
{% macro redshift__deduplicate(relation, partition_by, order_by) -%}

    select *
    from {{ relation }} as tt
    qualify
        row_number() over (
            partition by {{ partition_by }}
            order by {{ order_by }}
        ) = 1

{% endmacro %}

{#
-- Postgres has the `DISTINCT ON` syntax:
-- https://www.postgresql.org/docs/current/sql-select.html#SQL-DISTINCT
#}
{%- macro postgres__deduplicate(relation, partition_by, order_by) -%}

    select
        distinct on ({{ partition_by }}) *
    from {{ relation }}
    order by {{ partition_by }}{{ ',' ~ order_by }}

{%- endmacro -%}

{#
-- Snowflake has the `QUALIFY` syntax:
-- https://docs.snowflake.com/en/sql-reference/constructs/qualify.html
#}
{%- macro snowflake__deduplicate(relation, partition_by, order_by) -%}

    select *
    from {{ relation }}
    qualify
        row_number() over (
            partition by {{ partition_by }}
            order by {{ order_by }}
        ) = 1

{%- endmacro -%}

{#
-- Databricks also has the `QUALIFY` syntax:
-- https://docs.databricks.com/sql/language-manual/sql-ref-syntax-qry-select-qualify.html
#}
{%- macro databricks__deduplicate(relation, partition_by, order_by) -%}

    select *
    from {{ relation }}
    qualify
        row_number() over (
            partition by {{ partition_by }}
            order by {{ order_by }}
        ) = 1

{%- endmacro -%}

{#
--  It is more performant to deduplicate using `array_agg` with a limit
--  clause in BigQuery:
--  https://github.com/dbt-labs/dbt-utils/issues/335#issuecomment-788157572
#}
{%- macro bigquery__deduplicate(relation, partition_by, order_by) -%}

    select unique.*
    from (
        select
            array_agg (
                original
                order by {{ order_by }}
                limit 1
            )[offset(0)] unique
        from {{ relation }} original
        group by {{ partition_by }}
    )

{%- endmacro -%}
