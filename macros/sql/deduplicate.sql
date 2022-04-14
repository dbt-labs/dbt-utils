{%- macro deduplicate(relation, group_by, order_by) -%}
    {{ return(adapter.dispatch('deduplicate', 'dbt_utils')(relation, group_by, order_by=order_by)) }}
{% endmacro %}

{%- macro default__deduplicate(relation, group_by, order_by) -%}

    with row_numbered as (
        select
            _inner.*,
            row_number() over (
                partition by {{ group_by }}
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

{# Redshift should use default instead of Postgres #}
{% macro redshift__deduplicate(relation, group_by, order_by) -%}

    {{ return(dbt_utils.default__deduplicate(relation, group_by, order_by=order_by)) }}

{% endmacro %}

{#
-- Postgres has the `DISTINCT ON` syntax:
-- https://www.postgresql.org/docs/current/sql-select.html#SQL-DISTINCT
#}
{%- macro postgres__deduplicate(relation, group_by, order_by) -%}

    select
        distinct on ({{ group_by }}) *
    from {{ relation }}
    order by {{ group_by }}{{ ',' ~ order_by }}

{%- endmacro -%}

{#
-- Snowflake has the `QUALIFY` syntax:
-- https://docs.snowflake.com/en/sql-reference/constructs/qualify.html
#}
{%- macro snowflake__deduplicate(relation, group_by, order_by) -%}

    select *
    from {{ relation }}
    qualify
        row_number() over (
            partition by {{ group_by }}
            order by {{ order_by }}
        ) = 1

{%- endmacro -%}

{#
--  It is more performant to deduplicate using `array_agg` with a limit
--  clause in BigQuery:
--  https://github.com/dbt-labs/dbt-utils/issues/335#issuecomment-788157572
#}
{%- macro bigquery__deduplicate(relation, group_by, order_by) -%}

    select
        array_agg (
            original
            order by {{ order_by }}
            limit 1
        )[offset(0)].*
    from {{ relation }} as original
    group by {{ group_by }}

{%- endmacro -%}
