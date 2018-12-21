{% macro test_equal_sum(model, column_name, compare_model, compare_column) %}
with a as (

    select sum({{ column_name }}) as sum_a from {{ model }}

),
b as (

    select sum({{ compare_column }}) as sum_b from {{ compare_model }}

),
final as (

    select abs(
            (select sum_a from a) -
            (select sum_b from b)
            )
        as diff_sum

)

select diff_sum from final

{% endmacro %}