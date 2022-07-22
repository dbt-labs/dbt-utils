{% macro safe_cast(field, type) %}
  {{ return(adapter.dispatch('safe_cast', 'dbt_utils') (field, type)) }}
{% endmacro %}

{% macro default__safe_cast(field, type) %}
  {% do dbt_utils.xdb_deprecation_warning('safe_cast', model.package_name, model.name) %}
  {{ return(adapter.dispatch('safe_cast', 'dbt') (field, type)) }}
{% endmacro %}
