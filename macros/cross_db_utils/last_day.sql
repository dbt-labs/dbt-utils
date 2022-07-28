/*
This function has been tested with dateparts of month and quarters. Further
testing is required to validate that it will work on other dateparts.
*/

{% macro last_day(date, datepart) %}
  {{ return(adapter.dispatch('last_day', 'dbt_utils') (date, datepart)) }}
{% endmacro %}

{% macro default__last_day(date, datepart) %}
  {% do dbt_utils.xdb_deprecation_warning('last_day', model.package_name, model.name) %}
  {{ return(adapter.dispatch('last_day', 'dbt') (date, datepart)) }}
{% endmacro %}
