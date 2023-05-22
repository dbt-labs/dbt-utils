{% macro test_not_null_proportion(model, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_not_null_proportion', 'dbt_utils')(model, group_by_columns, **kwargs)) }}
{% endmacro %}

{% macro default__test_not_null_proportion(model, group_by_columns) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set at_least = kwargs.get('at_least', kwargs.get('arg')) %}
{% set at_most = kwargs.get('at_most', kwargs.get('arg', 1)) %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% endif %}

with validation as (
  select
    {{select_gb_cols}}
    sum(case when {{ column_name }} is null then 0 else 1 end) / cast(count(*) as {{ dbt.type_numeric() }}) as not_null_proportion
  from {{ model }}
  {{groupby_gb_cols}}
),
validation_errors as (
  select
    {{select_gb_cols}}
    not_null_proportion
  from validation
  where not_null_proportion < {{ at_least }} or not_null_proportion > {{ at_most }}
)
select
  *
from validation_errors

{% endmacro %}
