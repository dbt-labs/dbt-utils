{% macro test_cardinality_equality(model, from, to, field) %}

with table_a as (
select
  count(1) as num_rows,
  {{ from }}
from {{ model }}
group by 2
),

table_b as (
select
  count(1) as num_rows,
  {{ field }}
from {{ to }}
group by 2
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
