{% test not_empty_string(model, column_name, trim_whitespace=true) %}
  {{ return(adapter.dispatch('test_not_empty_string', 'dbt_utils')(model, column_name, trim_whitespace)) }}
{% endtest %}

{% macro default__test_not_empty_string(model, column_name, trim_whitespace=true) %}

    with errors as (
        select *
        from {{ model }}
        where
            {% if trim_whitespace | as_bool %}
                
                -- OPTIMIZED: Replaces Tabs, Line Feeds, and Carriage Returns 
                -- with standard spaces in ONE single CPU scan, then trims.
                trim(
                    translate({{ column_name }}, chr(9) || chr(10) || chr(13), '   ')
                ) = ''
                
            {% else %}
                {{ column_name }} = ''
            {% endif %}
    )

    select * from errors

{% endmacro %}