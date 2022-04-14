{%- macro deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}
    {{ return(adapter.dispatch('deduplicate', 'dbt_utils')(relation, group_by, order_by=order_by, relation_alias=relation_alias)) }}
{% endmacro %}

{%- macro default__deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}

    select
        {{ dbt_utils.star(relation, relation_alias='deduped') | indent }}
    from (
        select
            _inner.*,
            row_number() over (
                partition by {{ group_by }}
                {% if order_by is not none -%}
                order by {{ order_by }}
                {%- endif %}
            ) as rn
        from {{ relation if relation_alias is none else relation_alias }} as _inner
    ) as deduped
    where deduped.rn = 1

{%- endmacro -%}

{#
-- Postgres has the `DISTINCT ON` syntax:
-- https://www.postgresql.org/docs/current/sql-select.html#SQL-DISTINCT
#}
{%- macro postgres__deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}

    select
        distinct on ({{ group_by }}) *
    from {{ relation if relation_alias is none else relation_alias }}
    order by {{ group_by }}{{ ',' ~ order_by if order_by is not none else '' }}

{%- endmacro -%}

{#
-- Snowflake has the `QUALIFY` syntax:
-- https://docs.snowflake.com/en/sql-reference/constructs/qualify.html
#}
{%- macro snowflake__deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}

    select *
    from {{ relation if relation_alias is none else relation_alias }}
    qualify
        row_number() over (
            partition by {{ group_by }}
            {% if order_by is not none -%}
            order by {{ order_by }}
            {%- endif %}
        ) = 1

{%- endmacro -%}

{#
--  It is more performant to deduplicate using `array_agg` with a limit
--  clause in BigQuery:
--  https://github.com/dbt-labs/dbt-utils/issues/335#issuecomment-788157572
#}
{%- macro bigquery__deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}

    select
        array_agg (
            original
            {% if order_by is not none -%}
            order by {{ order_by }}
            {%- endif %}
            limit 1
        )[offset(0)].*
    from {{ relation if relation_alias is none else relation_alias }} as original
    group by {{ group_by }}

{%- endmacro -%}
