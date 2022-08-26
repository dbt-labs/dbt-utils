{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ return(adapter.dispatch('dateadd', 'dbt_utils')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}

{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}
  {% do dbt_utils.xdb_deprecation_warning('dateadd', model.package_name, model.name) %}
  {{ return(adapter.dispatch('dateadd', 'dbt')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}
