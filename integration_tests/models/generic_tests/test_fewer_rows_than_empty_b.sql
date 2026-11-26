select
    col_a, field
from {{ ref('data_test_fewer_rows_than_table_1') }}
where 1 = 0
