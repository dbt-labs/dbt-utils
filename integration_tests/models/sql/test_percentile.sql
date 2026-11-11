with data as (

    select 'a' as group_id, 1 as value_field
    union all select 'a', 2
    union all select 'a', 3
    union all select 'a', 4
    union all select 'b', 10

)

select
    group_id,
    {{ dbt_utils.percentile(percentile_field='value_field', partition_field='group_id', percent='0.5') }} as actual,
    case when group_id = 'a' then 2.5 else 10 end as expected

from data
{# Postgres only supports percentile_cont as an aggregate, so it needs a group by #}
{% if target.type == 'postgres' %} group by group_id {% endif %}
