{% macro except() %}
  {{ return(adapter.dispatch('except', 'dbt_utils')()) }}
{% endmacro %}

{% macro default__except() %}
  {% do dbt_utils.xdb_deprecation_warning('except', model.package_name, model.name) %}
  {{ return(adapter.dispatch('except', 'dbt')()) }}
{% endmacro %}
