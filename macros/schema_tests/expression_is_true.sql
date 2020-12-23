{% macro test_expression_is_true(model, condition='1=1') %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
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
