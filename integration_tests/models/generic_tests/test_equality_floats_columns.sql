with data as (

    select * from {{ ref('data_test_equality_floats') }}

)

select
    id, float_number + 0.0000001 as float_number, cast('b' as varchar(1)) as to_ignore
from data
