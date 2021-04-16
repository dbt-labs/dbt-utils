{% macro test_cardinality_equality(model, to, field) %}

    {{ return(adapter.dispatch('test_cardinality_equality', packages = dbt_utils._get_utils_namespaces())(model, to, field, **kwargs)) }}

{% endmacro %}

{% macro default__test_cardinality_equality(model, to, field) %}

{# T-SQL doesn't let you use numbers as aliases for columns #}
{# Thus, no "GROUP BY 1" #}

{% set column_name = kwargs.get('column_name', kwargs.get('from')) %}


with table_a as (
select
  {{ column_name }},
  count(*) as num_rows
from {{ model }}
group by {{ column_name }}
),

table_b as (
select
  {{ field }},
  count(*) as num_rows
from {{ to }}
group by {{ field }}
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
