{% test not_empty_array(model, column_name) %}

  {{ return(adapter.dispatch('test_not_empty_array', 'dbt_utils')(model, column_name)) }}

{% endtest %}

{% macro default__test_not_empty_array(model, column_name) %}

    with
    
    all_values as (

        select 

            {{ column_name }}

        from {{ model }}

    ),

    errors as (

        select * from all_values
        where {{ column_name }} = ''

    )

    select * from errors

{% endmacro %}