{% macro length(expression) -%}
    {{ return(adapter.dispatch('length', 'dbt') (expression)) }}
{% endmacro %}
