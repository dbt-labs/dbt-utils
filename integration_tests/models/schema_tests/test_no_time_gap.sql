WITH sequence(n) AS (
  select 0 union all select 1 union all select 2 union all
  select 3 union all select 4 union all select 5 union all
  select 6 union all select 7 union all select 8 union all
  select 9 union all select 10 union all select 11 union all
  select 12 union all select 13 union all select 14 union all
  select 15 union all select 16 union all select 17
)

{% if target.type == 'postgres' %}

select
    {{ dbt_utils.date_trunc('day', dbt_utils.dateadd('day', '-1 * n', dbt_utils.current_timestamp())) }} as day

{% else %}

select
    cast({{ dbt_utils.date_trunc('day', dbt_utils.dateadd('day', '-1 * n', dbt_utils.current_timestamp())) }} as datetime) as day

{% endif %}

from
    sequence
