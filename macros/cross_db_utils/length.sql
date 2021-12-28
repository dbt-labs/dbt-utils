{% macro length(expression) -%}
    {{ return(adapter.dispatch('length', 'cc_dbt_utils') (expression)) }}
{% endmacro %}


{% macro default__length(expression) %}
    
    length(
        {{ expression }}
    )
    
{%- endmacro -%}


{% macro redshift__length(expression) %}

    len(
        {{ expression }}
    )
    
{%- endmacro -%}