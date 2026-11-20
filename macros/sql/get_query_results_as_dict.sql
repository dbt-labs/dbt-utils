{% macro get_query_results_as_dict(query) %}
    {{ return(adapter.dispatch('get_query_results_as_dict', 'dbt_utils')(query)) }}
{% endmacro %}

{% macro default__get_query_results_as_dict(query) %}

{# This macro returns a dictionary of the form {column_name: (tuple_of_results)} #}

    {%- call statement('get_query_results', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {% set sql_results={} %}

    {%- if execute -%}
        {% set sql_results_table = load_result('get_query_results').table.columns %}
        {% for column_name, column in sql_results_table.items() %}
            {% if column.values() %}
                {% do sql_results.update({column_name: column.values()}) %}
            {% else %}
                {# If column is empty, assign a dummy value#}
                {% do sql_results.update({column_name: ' '}) %}
                {{ log('Column ' ~ column_name ~ ' has no values. Assigning empty value', info=True) }}
            {% endif %}

        {% endfor %}
    {%- endif -%}

    {{ return(sql_results) }}

{% endmacro %}
