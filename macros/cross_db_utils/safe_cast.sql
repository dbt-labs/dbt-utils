{# This is here for backwards compatibility only #}

{% macro safe_cast(field, type) %}
  {{ return(adapter.dispatch('safe_cast', 'dbt_utils') (field, type)) }}
{% endmacro %}

{% macro default__safe_cast(field, type) %}
  {{ return(adapter.dispatch('safe_cast', 'dbt') (field, type)) }}
{% endmacro %}
