
with data as (

    select * from {{ ref('data_ceil') }}

)

select
    {{ dbt_utils.ceil('input') }} as actual,
    output as expected

from data
