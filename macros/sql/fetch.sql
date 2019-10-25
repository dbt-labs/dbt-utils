{% macro fetch(sql) %}
{# This macro returns a dictionary of the form {column_name: (tuple_of_results)} #}

    {%- call statement('get_sql_results', fetch_result=True,auto_begin=false) -%}

        {{sql}}

    {%- endcall -%}
    
    {% set sql_results={} %}
    
    {%- if execute -%}
        {% set sql_results_table = load_result('get_sql_results').table.columns %}
        {% for column_name, column in sql_results_table.items() %}
            {% do sql_results.update({column_name: column.values()}) %}
        {% endfor %}
    {%- endif -%}
    
    {{ return(sql_results) }}
    
{% endmacro %}