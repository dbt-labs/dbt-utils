{% macro test_unique_combination_of_columns(model) %}

{%- set columns = kwargs.get('combination_of_columns', kwargs.get('arg')) %}

{%- set columns_csv=columns | join(', ') %}

with validation_errors as (

    select
        {{ columns_csv }}
    from {{ model }}

    group by {{ columns_csv }}
    having count(*) > 1

)

select count(*)
from validation_errors


{% endmacro %}
