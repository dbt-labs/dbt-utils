with test_data as (
    
    select
        'a' as column_1,
        'b' as column_2
    
),

grouped as (

    select 
        *,
        count(*) as total

    from test_data
    {{ dbt_utils.group_by(2) }}
    
)

select * from grouped



