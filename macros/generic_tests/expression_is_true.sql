{% test expression_is_true(model, expression, column_name=None) %}
  {{ return(adapter.dispatch('test_expression_is_true', 'dbt_utils')(model, expression, column_name)) }}
{% endtest %}

{% macro default__test_expression_is_true(model, expression, column_name) %}

{% set column_list = '*' if should_store_failures() else "1" %}

select
    {{ column_list }}
from {{ model }}
{% if column_name is none %}
where not({{ expression }})
{%- else %}
where not({{ column_name }} {{ expression }})
{%- endif %}

{% endmacro %}
