with 

test_data as (

    select * from {{ ref('data_url_encode_decode') }}

)

select
    {{ url_encode('decoded') }} as actual,
    encoded as expected

from test_data

union all

select
    {{ url_decode('encoded') }} as actual,
    decoded as expected

from test_data