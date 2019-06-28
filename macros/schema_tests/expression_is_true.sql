{% macro test_expression_is_true(model) %}

{% set expression = kwargs.get('expression', kwargs.get('arg')) %}
{% set condition = kwargs.get('condition', 'true') %}

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
