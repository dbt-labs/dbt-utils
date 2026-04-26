{% set query %}
with input as (
    select 1 as id, 4 as di 
    union all 
    select 2 as id, 5 as di
    union all 
    select 3 as id, 6 as di
)
{% endset %}

with comparisons as (
    select {{ dbt_utils.get_single_value(query ~ " select min(id) from input") }} as output, 1 as expected
    union all
    select {{ dbt_utils.get_single_value(query ~ " select max(di) from input") }} as output, 6 as expected
)
select * 
from comparisons
where output != expected