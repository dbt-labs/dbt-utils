{% macro test_fewer_rows_than(model) %}
  {{ return(adapter.dispatch('test_fewer_rows_than', packages = dbt_utils._get_utils_namespaces())(model, combination_of_columns, quote_columns, where)) }}
{% endmacro %}

{% macro default__test_fewer_rows_than(model) %}

{% set compare_model = kwargs.get('compare_model', kwargs.get('arg')) %}

with a as (

    select count(*) as count_ourmodel from {{ model }}

),
b as (

    select count(*) as count_comparisonmodel from {{ compare_model }}

),
counts as (

    select
        (select count_ourmodel from a) as count_model_with_fewer_rows,
        (select count_comparisonmodel from b) as count_model_with_more_rows

),
final as (

    select
        case
            -- fail the test if we have more rows than the reference model and return the row count delta
            when count_model_with_fewer_rows > count_model_with_more_rows then (count_model_with_fewer_rows - count_model_with_more_rows)
            -- fail the test if they are the same number
            when count_model = count_comparison then 1
            -- pass the test if the delta is positive (i.e. return the number 0)
            else 0
    end as row_count_delta
    from counts

)

select row_count_delta from final

{% endmacro %}
