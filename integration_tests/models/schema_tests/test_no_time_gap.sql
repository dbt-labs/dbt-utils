WITH RECURSIVE t(n) AS (
    VALUES (0)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)

{% if target.type == 'postgres' %}

select
    {{ dbt_utils.date_trunc('day', dbt_utils.dateadd('day', '-1 * n', dbt_utils.current_timestamp())) }} as day

{% else %}

select
    cast({{ dbt_utils.date_trunc('day', dbt_utils.dateadd('day', '-1 * n', dbt_utils.current_timestamp())) }} as datetime) as day

{% endif %}

from
    t
