{% macro star(from, relation_alias=False, except=[], aliases={}) -%}
    {{ return(adapter.dispatch('star', packages = dbt_utils._get_utils_namespaces())(from, relation_alias, except, aliases)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], aliases={}) -%}
    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set include_cols = [] %}
    {%- set cols = adapter.get_columns_in_relation(from) -%}

    {%- for col in cols -%}

        {%- if col.column|lower not in except|map('lower') -%}
            {% do include_cols.append(col.column) %}

        {%- endif %}
    {%- endfor %}

    {%- for col in include_cols %}

        {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}{{ adapter.quote(col)|trim }}{%- if col in aliases %} as {{ adapter.quote(aliases[col]) | trim }}{%- endif -%}
        {%- if not loop.last %},{{ '\n  ' }}{% endif %}

    {%- endfor -%}
{%- endmacro %}
