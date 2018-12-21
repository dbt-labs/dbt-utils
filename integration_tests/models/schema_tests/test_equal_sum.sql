with data as (

    select * from {{ ref('data_test_equal_sum') }}

)

select
    field
from data