-- Test model with data that's intentionally old
-- This simulates a scenario where we have data but it's all outside the recency window
-- this should fail with a where clause but currently it would pass
select
    1 as id,
    {{ dbt.dateadd('day', -10, dbt.current_timestamp()) }} as created_at

union all

select
    2 as id,
    {{ dbt.dateadd('day', -15, dbt.current_timestamp()) }} as created_at
