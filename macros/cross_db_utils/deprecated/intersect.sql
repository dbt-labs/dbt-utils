{% macro intersect() %}
  {{ return(adapter.dispatch('intersect', 'dbt_utils')()) }}
{% endmacro %}

{% macro default__intersect() %}
  {% do dbt_utils.xdb_deprecation_warning('intersect', model.package_name, model.name) %}
  {{ return(adapter.dispatch('intersect', 'dbt')()) }}
{% endmacro %}
