{%- macro dedupe(table, group_by, order_by=none) -%}
    {{ return(adapter.dispatch('dedupe', 'dbt_utils')(table, group_by, order_by=order_by)) }}
{% endmacro %}

{%- macro default__dedupe(table, group_by, order_by=none) -%}

    select
        {{ dbt_utils.star(table, relation_alias='deduped') | indent }}
    from (
        select
            _inner.*,
            row_number() over (
                partition by {{ group_by }}
                {% if order_by != none -%}
                order by {{ order_by }}
                {%- endif %}
            ) as rn
        from {{ table }} as _inner
    ) as deduped
    where deduped.rn = 1

{%- endmacro -%}

{%- macro bigquery__dedupe(table, group_by, order_by=none) -%}

    select
        {{ dbt_utils.star(table, relation_alias='deduped') | indent }}
    from (
        select
            array_agg (
                original
                {% if order_by != none -%}
                order by {{ order_by }}
                {%- endif %}
                limit 1
            )[offset(0)] as deduped
        from {{ table }} as original
        group by {{ group_by }}
    )

{%- endmacro -%}
