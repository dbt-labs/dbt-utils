with yesterday_time as (
select
    1 as col1,
    2 as col2,
    {{ dbt.dateadd('day', -1, dbt.current_timestamp()) }} as created_at
)

select 
    col1, 
    col2, 
    {{ dbt.date_trunc('day', 'created_at') }} as created_at
from yesterday_time