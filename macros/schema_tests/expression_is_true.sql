{% test expression_is_true(model, expression, column_name=None, condition='1=1') %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
  {{ return(adapter.dispatch('test_expression_is_true', 'dbt_utils')(model, expression, column_name, condition)) }}
{% endtest %}

{% macro default__test_expression_is_true(model, expression, column_name, condition) %}

{% if execute %}
  {%- set columns = adapter.get_columns_in_relation(model) -%}
  {% for col in columns %}
  {{ exceptions.raise_compiler_error(
    '_test_expression_passed is a protected column name for the dbt_utils.expression_is_true test.\nPlease rename the `_test_expression_passed` field in ' ~ model.name ~'.'
  ) if '_test_expression_passed' == col.name|lower }}
  {% endfor %}
{% endif %}

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
