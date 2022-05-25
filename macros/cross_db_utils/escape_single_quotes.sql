{% macro escape_single_quotes(expression) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt') (expression)) }}
{% endmacro %}
