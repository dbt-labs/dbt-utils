with data as (

    select * from {{ ref('data_test_equal_expression') }}

)

select
    date_col,
    col_a,
    col_b
from data