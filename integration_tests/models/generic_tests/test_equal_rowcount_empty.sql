with data as (

    select * from {{ ref('data_test_equal_rowcount_empty') }}

)

select
    field
from data