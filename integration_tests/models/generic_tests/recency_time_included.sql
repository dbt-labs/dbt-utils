select
    1 as col1,
    2 as col2,
    cast({{ dbt.dateadd('hour', -23, dbt.current_timestamp()) }} as {{ dbt.type_timestamp() }}) as created_at
