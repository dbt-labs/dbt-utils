

select
    'a' as column_1,
    'b' as column_2,
    count(*) as total

{{ dbt_utils.group_by(2) }}
