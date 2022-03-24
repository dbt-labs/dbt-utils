{% macro star(from, relation_alias=False, except=[], prefix='', suffix='', output_lower=False) -%}
    {{ return(adapter.dispatch('star', 'dbt_utils')(from, relation_alias, except, prefix, suffix, output_lower)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], prefix='', suffix='', output_lower=False) -%}
    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- for col in dbt_utils.get_filtered_columns_in_relation(from, except, output_lower) %}

        {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}{{ adapter.quote(col)|trim }} {%- if prefix!='' or suffix!='' -%} as {{ adapter.quote(prefix ~ col ~ suffix)|trim }} {%- endif -%}
        {%- if not loop.last %},{{ '\n  ' }}{% endif %}

    {%- endfor -%}
{%- endmacro %}
