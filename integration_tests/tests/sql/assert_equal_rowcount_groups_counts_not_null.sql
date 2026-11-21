with test_output as (

    {{ dbt_utils.test_equal_rowcount(
        ref('data_test_equal_rowcount_groups_a'),
        ref('data_test_equal_rowcount_groups_b'),
        ['group_col']
    ) }}

)

select *
from test_output
where count_a is null
    or count_b is null

{#- Keep this config call last. The test macro called above also sets fail_calc via config(), and when the same config key is set more than once, the last call wins. -#}
{{ config(fail_calc = 'count(*)') }}
