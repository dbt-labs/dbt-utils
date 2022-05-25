{% macro cast_bool_to_text(field) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt') (field) }}
{% endmacro %}
