{% macro datediff(first_date, second_date, datepart) %}
  {{ return(adapter.dispatch('datediff', 'dbt_utils')(first_date, second_date, datepart)) }}
{% endmacro %}

{% macro default__datediff(first_date, second_date, datepart) %}
  {% do dbt_utils.xdb_deprecation_warning('datediff', model.package_name, model.name) %}
  {{ return(adapter.dispatch('datediff', 'dbt')(first_date, second_date, datepart)) }}
{% endmacro %}
