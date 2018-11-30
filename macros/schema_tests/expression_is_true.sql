{% macro test_expression_is_true(model) %}

{% set expression = kwargs.get('expression', kwargs.get('arg')) %}

with validation_errors as (

    select
        *
    from {{model}}
    where not({{expression}})

)

select count(*)
from validation_errors

{% endmacro %}
