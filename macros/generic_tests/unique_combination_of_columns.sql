{% macro default__test_unique_combination_of_columns(model, combination_of_columns, quote_columns=false) %}

-- Support dbt Core 1.10+ 'arguments:' syntax (kwargs)
{% set combination_of_columns = kwargs.get('combination_of_columns', combination_of_columns) %}
{% set quote_columns = kwargs.get('quote_columns', quote_columns) %}

-- Also handle possible nested 'args' or 'arguments' keys for future compatibility
{% if kwargs.get('args') is mapping %}
    {% set combination_of_columns = kwargs.args.get('combination_of_columns', combination_of_columns) %}
    {% set quote_columns = kwargs.args.get('quote_columns', quote_columns) %}
{% elif kwargs.get('arguments') is mapping %}
    {% set combination_of_columns = kwargs.arguments.get('combination_of_columns', combination_of_columns) %}
    {% set quote_columns = kwargs.arguments.get('quote_columns', quote_columns) %}
{% endif %}

{% if not quote_columns %}
    {%- set column_list = combination_of_columns %}
{% elif quote_columns %}
    {%- set column_list = quote_columns(combination_of_columns) %}
{% else %}
    {{ exceptions.raise_compiler_error("Invalid 'quote_columns' argument provided. Got '" ~ quote_columns ~ "' but expected boolean True/False") }}
{% endif %}

{%- set columns_csv = column_list | join(', ') %}

with validation_errors as (
    select
        {{ columns_csv }}
    from {{ model }}
    group by {{ columns_csv }}
    having count(*) > 1
)

select *
from validation_errors

{% endmacro %}
