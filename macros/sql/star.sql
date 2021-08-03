{#- 
     {{ star(
      from=ref('transform_policy_endorsement_coverages'),
      except=['Total_Premium']
      relation_alias= 'prem',
      contains_item = 'Premium', --OPTIONAL
      include_or_exclude_contains_item = 'include'  --OPTIONAL
      ) }}
    
    This example would retrive all premium values like (bi_premium, pd_premium) while excluding 'total_premium'.
    
    *column_contains makes it so we only retrieve columns that contain the value being passed*
    
    -#}

{% macro star(from, relation_alias=False, except=[], contains_item = none, include_or_exclude_contains_item = none, separator = ',', column_prefix = none) -%}
    {{ return(adapter.dispatch('star', 'cc_dbt_utils')(from, relation_alias, except)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[]) -%}
    {%- do cc_dbt_utils._is_relation(from, 'star') -%}
    {%- do cc_dbt_utils._is_ephemeral(from, 'star') -%}

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
