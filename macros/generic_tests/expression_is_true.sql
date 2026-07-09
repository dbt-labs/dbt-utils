{% test expression_is_true(model, expression, column_name=None, fail_on_null=False) %}
  {{ return(adapter.dispatch('test_expression_is_true', 'dbt_utils')(model, expression, column_name, fail_on_null)) }}
{% endtest %}

{% macro default__test_expression_is_true(model, expression, column_name, fail_on_null) %}

{% set column_list = '*' if should_store_failures() else "1" %}

{% if column_name is none %}
  {% set test_expression = expression %}
{% else %}
  {% set test_expression = column_name ~ ' ' ~ expression %}
{% endif %}

select
    {{ column_list }}
from {{ model }}
where not({{ test_expression }})
{%- if fail_on_null %}
 or ({{ test_expression }}) is null
{%- endif %}

{% endmacro %}
