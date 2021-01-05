{% macro test_expression_is_true(model, condition='true') %}
  {{ return(adapter.dispatch('test_expression_is_true', packages = dbt_utils._get_utils_namespaces())(model, condition='true', **kwargs)) }}
{% endmacro %}

{% macro default__test_expression_is_true(model, condition='true') %}

{% set expression = kwargs.get('expression', kwargs.get('arg')) %}

with meet_condition as (

    select * from {{ model }} where {{ condition }}

),
validation_errors as (

    select
        *
    from meet_condition
    where not({{expression}})

)

select count(*)
from validation_errors

{% endmacro %}
