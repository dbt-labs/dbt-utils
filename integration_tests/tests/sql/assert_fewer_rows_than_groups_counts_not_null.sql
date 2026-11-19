with test_output as (

    {{ dbt_utils.test_fewer_rows_than(
        ref('data_test_fewer_rows_than_groups_a'),
        ref('data_test_fewer_rows_than_groups_b'),
        ['group_col']
    ) }}

)

select *
from test_output
where count_our_model is null
    or count_comparison_model is null

{{ config(fail_calc = 'count(*)') }}
