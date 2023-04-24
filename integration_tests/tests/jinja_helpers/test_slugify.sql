with comparisons as (
  select '{{ dbt_utils.slugify("") }}' as output, '' as expected
  union all
  select '{{ dbt_utils.slugify(None) }}' as output, '' as expected
  union all
  select '{{ dbt_utils.slugify("!Hell0 world-hi") }}' as output, 'hell0_world_hi' as expected
  union all
  select '{{ dbt_utils.slugify("0Hell0 world-hi") }}' as output, '_0hell0_world_hi' as expected
)

select * 
from comparisons
where output != expected
