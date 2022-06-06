{# This is here for backwards compatibility only #}

{% macro bool_or(expression) -%}
    {{ return(adapter.dispatch('bool_or', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__bool_or(expression) -%}
    {{ return(adapter.dispatch('bool_or', 'dbt') (expression)) }}
{% endmacro %}
