
with data as (

    select * from {{ ref('data_safe_subtract') }}

)

select
    {{ dbt_utils.safe_subtract(['field_1', 'field_2', 'field_3']) }} as actual,
    expected

from data
