
with data as (

    select * from {{ ref('data_generate_surrogate_key_single_field') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['input_value']) }} as actual_key,
    expected_key

from data
