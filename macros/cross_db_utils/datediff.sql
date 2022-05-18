------ IF WE DON'T CARE ABOUT BACKWARDS COMPATIBILITY --------

{% macro datediff(first_date, second_date, datepart) %}
  {{ return(dbt.datediff(first_date, second_date, datepart)) }}
{% endmacro %}
