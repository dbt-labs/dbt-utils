{% macro safe_cast(field, type) %}
  {{ return(adapter.dispatch('safe_cast', 'dbt') (field, type)) }}
{% endmacro %}
