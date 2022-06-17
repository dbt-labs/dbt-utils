{# This is here for backwards compatibility only #}

{% macro escape_single_quotes(expression) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__escape_single_quotes(expression) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt') (expression)) }}
{% endmacro %}
