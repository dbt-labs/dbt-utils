{% macro get_query_results_as_single_value(query, row_position=0, column_position=0) %}
    {{ return(adapter.dispatch('get_query_results_as_single_value', 'dbt_utils')(query, row_position=0, column_position=0)) }}
{% endmacro %}

{% macro default__get_query_results_as_single_value(query, row_position=0, column_position=0) %}

{# This macro returns the (row_position, column_position) record in a query #}
    {%- set nth_row = row_position -%}
    {%- set nth_column = column_position -%}

    {%- call statement('get_query_result', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {%- if execute -%}

        {% set sql_result = load_result('get_query_result').table.columns[nth_column].values()[nth_row] %}
    
    {%- else -%}
    
        {% set sql_result = "" %}
    
    {%- endif -%}

    {{ return("'"+sql_result+"'") }}

{% endmacro %}