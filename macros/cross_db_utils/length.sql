{% macro length(expression) -%}
    {{ adapter_macro('dbt_utils.length', expression) }}
{% endmacro %}


{% macro default__length(expression) %}

    len(
        {{ expression }}
    )
    
{%- endmacro -%}


{% macro snowflake__length(expression) %}

    length(
        {{ expression }}
    )
    
{%- endmacro -%}


{% macro postgres__length(expression) %}

    length(
        {{ expression }}
    )
    
{%- endmacro -%}


{% macro bigquery__length(expression) %}

    length(
        {{ expression }}
    )
    
{%- endmacro -%}