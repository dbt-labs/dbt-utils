{% macro test_relationships_where(model, to, field) %}
  {{ return(adapter.dispatch('test_relationships_where', packages = dbt_utils._get_utils_namespaces())(model, to, field, **kwargs)) }}
{% endmacro %}

{% macro default__test_relationships_where(model, to, field) %}

{% set column_name = kwargs.get('column_name', kwargs.get('from')) %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
{% set from_condition = kwargs.get('from_condition', "1=1") %}
{% set to_condition = kwargs.get('to_condition', "1=1") %}

with left_table as (

  select
    {{column_name}} as id

  from {{model}}

  where {{column_name}} is not null
    and {{from_condition}}

),

right_table as (

  select
    {{field}} as id

  from {{to}}

  where {{field}} is not null
    and {{to_condition}}

),

exceptions as (

  select
    left_table.id,
    right_table.id as right_id

  from left_table

  left join right_table
         on left_table.id = right_table.id

  where right_table.id is null

)

select count(*) from exceptions

{% endmacro %}
