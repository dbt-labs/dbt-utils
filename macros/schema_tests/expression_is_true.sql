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
    {% if column_name is none %}
    where not({{ expression }})
    {%- else %}
    where not({{ column_name }} {{ expression }})
    {%- endif %}

)

select count(*)
from validation_errors

{% endmacro %}
