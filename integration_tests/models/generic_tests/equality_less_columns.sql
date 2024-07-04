with data as (

    select * from {{ ref('data_test_equality_b') }}

)

select
    col_a, col_b
from data
