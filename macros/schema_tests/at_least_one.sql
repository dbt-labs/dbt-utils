{% macro test_at_least_one(model) %}
  {{ return(adapter.dispatch('test_at_least_one', packages = dbt_utils._get_utils_namespaces())(model, **kwargs)) }}
{% endmacro %}

{% macro default__test_at_least_one(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}

select count(*)
from (
    select

      count({{ column_name }})

    from {{ model }}

    having count({{ column_name }}) = 0

) validation_errors

{% endmacro %}