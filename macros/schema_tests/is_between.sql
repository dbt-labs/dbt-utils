{% macro test_is_between(model, column_name, allow_nulls=false) %}

{% set min = kwargs.get('min', kwargs.get('arg')) %}
{% set max = kwargs.get('max', kwargs.get('arg')) %}

{# Make sure at at least one boundary is defined #}
{% if min is none and max is none %}
  {{ exceptions.raise_compiler_error(
    "You have to define at least one of `min` or `max` for the test!")
  }}
{% endif %}

with validation as (

  select
    {{ column_name }} as column_to_test

  from {{ model }}

),

validation_errors as (

  select
    column_to_test

  from validation
  where false
  
  {% if min is not none %}
    or column_to_test < {{ min }}
  {% endif %}
  
  {% if max is not none %}
    or column_to_test > {{ max }}
  {% endif %}
  
  {% if allow_nulls is false %}
    or column_to_test is null
  {% endif %}
)

select count(*)
from validation_errors

{% endmacro %}
