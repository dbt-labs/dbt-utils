with data as (

    select * from {{ ref('data_test_fewer_rows_than_table_1') }}

)

select
   col_a, field
from data