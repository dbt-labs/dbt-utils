{% macro test_not_null_when(model, condition='true') %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
with source as (
    select {{ column_name }} as test
    from {{ model }}
    where {{ condition }}
)
select count(*) as validation_errors
    from source
    where test is null
{% endmacro %}
