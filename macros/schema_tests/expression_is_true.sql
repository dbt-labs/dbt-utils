{% test expression_is_true(model, expression, column_name=None, condition='1=1') %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
  {{ return(adapter.dispatch('test_expression_is_true', 'dbt_utils')(model, expression, column_name, condition)) }}
{% endtest %}

{% macro default__test_expression_is_true(model, expression, column_name, condition) %}

with meet_condition as (
    select
      *,
      {% if column_name is none %}
      {{ expression }}
      {%- else %}
      {{ column_name }} {{ expression }}
      {%- endif %}
      as _test_expression_passed
    from {{ model }}
    where {{ condition }}
)

select * from meet_condition where not(_test_expression_passed)

{% endmacro %}
