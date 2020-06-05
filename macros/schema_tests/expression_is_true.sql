{% macro test_expression_is_true(model, condition='true') %}

{% set expression = kwargs.get('expression', kwargs.get('arg')) %}
{% set column_name = kwargs.get('column_name') %}

with meet_condition as (

    select * from {{ model }} where {{ condition }}

),
validation_errors as (

    select
        *
    from meet_condition
    where not( {{ expression if column_name is none else [column_name, expression] | join(' ')  }})

)

select count(*)
from validation_errors

{% endmacro %}
