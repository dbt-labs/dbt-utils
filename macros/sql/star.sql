{% macro star(from, relation_alias=False, except=[], contains_item = none, include_or_exclude_contains_item = none, separator = ',', column_prefix = none) -%}
    {{ return(adapter.dispatch('star', 'cc_dbt_utils')(from, relation_alias, except, contains_item, include_or_exclude_contains_item, separator, column_prefix)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], contains_item = none, include_or_exclude_contains_item = none, separator = ',', column_prefix = none) -%}
    
    {%- do cc_dbt_utils._is_relation(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}

    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set include_cols = [] %}
    {%- set cols = adapter.get_columns_in_relation(from) -%}
    
    {% if contains_item is not none and include_or_exclude_contains_item is none %}
        {%- do exceptions.raise_compiler_error("Macro " ~ macro ~ " expected a value for argument include_or_exclude_contains_item but received none: " ~ obj) -%}
    {% endif %}

    {%- set in_or_out = include_or_exclude_contains_item if include_or_exclude_contains_item is not none else [] %}


    {%- for col in cols -%}

        {% if contains_item is not none and col.column not in except and contains_item|upper in col.column and in_or_out == 'include' %}
                {% do include_cols.append(col.column) %}
        {%- elif contains_item is not none and col.column not in except and contains_item|upper not in col.column and in_or_out == 'exclude' -%}
                {% do include_cols.append(col.column) %}
        {%- elif contains_item is none and col.column not in except -%} 
                {% do include_cols.append(col.column) %}
        {%- endif %}

    {%- endfor %}

    {%- for col in include_cols %}

        {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}{{ adapter.quote(col)|trim }} {%- if column_prefix %} as {{ column_prefix }}{{ col|trim }}{% else %}{%- endif -%}
        {%- if not loop.last %}{{ separator }} {{ '\n  ' }}{% endif %}

    {%- endfor -%}
{%- endmacro %}
