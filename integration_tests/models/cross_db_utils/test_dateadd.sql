
with data as (

    select * from {{ ref('data_dateadd') }}

)

select
    case
        when datepart = 'hour' then {{ dbt_utils.dateadd('hour', 'interval_length', 'from_time') }}
        when datepart = 'day' then {{ dbt_utils.dateadd('day', 'interval_length', 'from_time') }}
        when datepart = 'month' then {{ dbt_utils.dateadd('month', 'interval_length', 'from_time') }}
        when datepart = 'year' then {{ dbt_utils.dateadd('year', 'interval_length', 'from_time') }}
        else null
    end as actual,
    result as expected

from data
