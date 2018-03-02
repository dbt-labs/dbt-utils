
with data as (

    select * from {{ ref('data_date_trunc') }}

)

select
    {{ dbt_utils.date_trunc('day', 'updated_at') }} as actual,
    day as expected

from data

union all

select
    {{ dbt_utils.date_trunc('month', 'updated_at') }} as actual,
    month as expected

from data
