{% test functional_dependency(model, column_name, depends_on, quote_columns=False) %}
  {{ return(adapter.dispatch('test_functional_dependency', 'dbt_utils')(model, column_name, depends_on, quote_columns)) }}
{% endtest %}


{% macro default__test_functional_dependency(model, column_name, depends_on, quote_columns=False) %}


{% if not quote_columns %}
    {%- set column_list=depends_on %}
{% elif quote_columns %}
    {%- set column_list=[] %}
        {%- for column in depends_on %}
            {%- set column_list = column_list.append( adapter.quote(column) ) %}
        {%- endfor %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`quote_columns` argument for functional_dependency test must be one of [True, False]"
    ) }}
{% endif %}


{%- set columns_csv=column_list | join(', ') %}


with validation_errors as (

    select {{ columns_csv }}
    from {{ model }}
    group by {{ columns_csv }}
    having count(distinct {{ column_name }}) > 1

)

select *
from validation_errors


{% endmacro %}
