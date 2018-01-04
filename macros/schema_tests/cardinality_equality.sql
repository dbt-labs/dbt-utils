{% macro test_cardinality_equality(model, from, to, field) %}

with table_a as (
select
  {{ from }},
  count(1) as num_rows
from {{ model }}
group by 1
),

table_b as (
select
  { field }},
  count(1) as num_rows
from {{ to }}
group by 1
)

select count(1)
from (
select *
from table_a
except
select *
from table_b
)

{% endmacro %}
