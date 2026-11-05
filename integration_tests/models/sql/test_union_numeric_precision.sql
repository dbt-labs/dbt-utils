with unioned as (

    {{ dbt_utils.union_relations([
        ref('test_union_numeric_precision_narrow'),
        ref('test_union_numeric_precision_wide'),
        ref('test_union_numeric_precision_scale')
    ]) }}

)

select id from unioned
