{% macro bool_or(expression) -%}
    {{ return(adapter.dispatch('bool_or', 'dbt') (expression)) }}
{% endmacro %}
