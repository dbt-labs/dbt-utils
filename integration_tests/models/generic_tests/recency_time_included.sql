select
    1 as col1,
    2 as col2,
    {{ dbt.dateadd('hour', -23, dbt.current_timestamp()) }} as created_at
