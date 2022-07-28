{% macro cast_bool_to_text(field) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt_utils') (field) }}
{% endmacro %}

{% macro default__cast_bool_to_text(field) %}
  {% do dbt_utils.xdb_deprecation_warning('cast_bool_to_text', model.package_name, model.name) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt') (field) }}
{% endmacro %}
