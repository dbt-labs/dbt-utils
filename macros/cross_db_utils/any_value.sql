{# This is here for backwards compatibility only #}

{% macro any_value(expression) -%}
    {{ return(adapter.dispatch('any_value', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__any_value(expression) -%}
    {{ return(adapter.dispatch('any_value', 'dbt') (expression)) }}
{% endmacro %}
