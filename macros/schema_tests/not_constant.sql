
{% macro test_not_constant(model) %}
  {{ adapter.dispatch('test_not_constant', packages = dbt_utils._get_utils_namespaces())(model) }}
{% endmacro %}

{% macro default__test_not_constant(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}

select count(*)

from (

    select
          count(distinct {{ column_name }})

    from {{ model }}

    having count(distinct {{ column_name }}) = 1

    ) validation_errors


{% endmacro %}
