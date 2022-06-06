{# This is here for backwards compatibility only #}

{% macro cast_bool_to_text(field) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt_utils') (field) }}
{% endmacro %}

{% macro default__cast_bool_to_text(field) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt') (field) }}
{% endmacro %}
