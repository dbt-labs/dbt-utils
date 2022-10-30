{% test not_empty_string(model, column_name, trim_whitespace=true) %}

  {{ return(adapter.dispatch('test_not_empty_string', 'dbt_utils')(model, column_name, trim_whitespace)) }}

{% endtest %}

{% macro default__test_not_empty_string(model, column_name, trim_whitespace=true) %}

    with
    
    all_values as (

        select 


            {% if trim_whitespace == true -%}

                trim({{ column_name }}) as {{ column_name }}

            {%- else -%}

                {{ column_name }}

            {%- endif %}
            
        from {{ model }}

    ),

    errors as (

        select * from all_values
        where {{ column_name }} = ''

    )

    select * from errors

{% endmacro %}