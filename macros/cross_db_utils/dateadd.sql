{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ return(adapter.dispatch('dateadd', 'dbt')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}
