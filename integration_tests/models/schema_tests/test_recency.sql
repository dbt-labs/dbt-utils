select
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today
