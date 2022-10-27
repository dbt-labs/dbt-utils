{% macro get_query_results_as_single_value(query) %}
    {{ return(adapter.dispatch('get_query_results_as_single_value', 'dbt_utils')(query, row_position, column_position)) }}
{% endmacro %}

{% macro default__get_query_results_as_single_value(query) %}

{# This macro returns the (0, 0) record in a query #}

    {%- call statement('get_query_result', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {%- if execute -%}

        {% set sql_result = load_result('get_query_result').table.columns[0].values()[0] %}
    
    {%- else -%}
    
        {% set sql_result = "" %}
    
    {%- endif -%}

    {% do return(sql_result) %}

{% endmacro %}