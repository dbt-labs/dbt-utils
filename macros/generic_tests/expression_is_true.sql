{% test expression_is_true(model, expression, column_name=None, condition='1=1') %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
  {{ return(adapter.dispatch('test_expression_is_true', 'dbt_utils')(model, expression, column_name, condition)) }}
{% endtest %}

{% macro default__test_expression_is_true(model, expression, column_name, condition) %}

{% set column_list = '*' if should_store_failures() else "1" %}

with meet_condition as (
    select * from {{ model }} where {{ condition }}
)

select
    {{ column_list }}
from meet_condition
{% if column_name is none %}
where not({{ expression }})
{%- else %}
where not({{ column_name }} {{ expression }})
{%- endif %}

{% endmacro %}
