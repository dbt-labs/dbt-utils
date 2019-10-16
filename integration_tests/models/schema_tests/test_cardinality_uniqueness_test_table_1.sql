with data as (

    select * from {{ ref('data_test_cardinality_uniqueness_test_table_1') }}

)

select
    state
from data