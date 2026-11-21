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

{#- Keep this config call last. The test macro called above also sets fail_calc via config(), and when the same config key is set more than once, the last call wins. -#}
{{ config(fail_calc = 'count(*)') }}
