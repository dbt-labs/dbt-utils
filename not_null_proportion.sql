{% macro default__test_not_null_proportion(model, group_by_columns) %}

{% set column_name = kwargs.get('column_name') %}
{% if column_name is none %}
  {{ exceptions.raise_compiler_error("column_name is required") }}
{% endif %}

{% set at_least = kwargs.get('at_least', 0.0) %}
{% set at_most  = kwargs.get('at_most', 1.0) %}

{% if at_least > at_most %}
  {{ exceptions.raise_compiler_error("at_least cannot be greater than at_most") }}
{% endif %}

{% set select_gb_cols  = '' %}
{% set groupby_gb_cols = '' %}
{% if group_by_columns | length > 0 %}
  {% set select_gb_cols  = group_by_columns | join(', ') ~ ', ' %}
  {% set groupby_gb_cols = 'GROUP BY ' ~ group_by_columns | join(', ') %}
{% endif %}

with validation as (
    select
        {{ select_gb_cols }}

        -- Safe, portable division. Empty sets => NULL (dbt tests pass when no rows returned)
        (count({{ column_name }}) * 1.0)
        / nullif(count(*), 0) as not_null_proportion

    from {{ model }}
    {{ groupby_gb_cols }}
),

validation_errors as (
    select
        {{ select_gb_cols }}
        not_null_proportion
    from validation
    where not_null_proportion < {{ at_least }}
       or not_null_proportion > {{ at_most }}
)

select * from validation_errors

{% endmacro %}