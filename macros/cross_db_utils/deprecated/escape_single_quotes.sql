{% macro escape_single_quotes(expression) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__escape_single_quotes(expression) %}
      {% do dbt_utils.xdb_deprecation_warning('escape_single_quotes', model.package_name, model.name) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt') (expression)) }}
{% endmacro %}
