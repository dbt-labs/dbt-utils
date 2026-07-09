with data as (

    select * from {{ ref('data_test_equal_rowcount_groups_a') }}

)

select
    group_col, field
from data
