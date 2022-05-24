{% macro datediff(first_date, second_date, datepart) %}
  {{ return(adapter.dispatch('datediff', 'dbt')(first_date, second_date, datepart)) }}
{% endmacro %}
