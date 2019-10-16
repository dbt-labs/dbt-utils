{% macro test_cardinality_equality(model, to, field, test_uniqueness=false) %}

{% set column_name = kwargs.get('column_name', kwargs.get('from')) %}


with table_a as (
  select
      {{ column_name }}
  {%- if test_uniqueness == false -%}
     , count(*) as num_rows
  {%- endif %}
  from {{ model }}
  group by 1
),

table_b as (
  select
      {{ field }}
  {%- if test_uniqueness == false -%}
     , count(*) as num_rows
  {%- endif %}
  from {{ to }}
  group by 1
),

except_a as (
  select *
  from table_a
  {{ dbt_utils.except() }}
  select *
  from table_b
),

except_b as (
  select *
  from table_b
  {{ dbt_utils.except() }}
  select *
  from table_a
),

unioned as (
  select *
  from except_a
  union all
  select *
  from except_b
)

select count(*)
from unioned

{% endmacro %}


