{% macro any_value(expression) -%}
    {{ return(adapter.dispatch('any_value', 'dbt') (expression)) }}
{% endmacro %}
