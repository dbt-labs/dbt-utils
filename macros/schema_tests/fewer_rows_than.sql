{% macro test_fewer_rows_than(model) %}

{% set compare_model = kwargs.get('compare_model', kwargs.get('arg')) %}

with a as (

    select count(*) as count_model from {{ model }}

),
b as (

    select count(*) as count_comparison from {{ compare_model }}

),
counts as (

    select
        (select count_model from a) as count_model,
        (select count_comparison from b) as count_comparison

),
final as (

    select 
        case
            when count_model > count_comparison then count_model - count_comparison + 1
            when count_model = count_comparison then count_model - count_comparison
        else 0 end as excess_rows
    from counts

)

select excess_rows from final

{% endmacro %}
