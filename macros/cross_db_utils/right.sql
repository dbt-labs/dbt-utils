{% macro right(string_text, length_expression) -%}
    {{ return(adapter.dispatch('right', 'dbt') (string_text, length_expression)) }}
{% endmacro %}
