{#
This macro fetches the unique values for `column` in the table `table`

Arguments:
    table: A model `ref`, or a schema.table string for the table to query (Required)
    column: The column to query for unique values
    max_records: If provided, the maximum number of unique records to return (default: none)

Returns:
    A list of distinct values for the specified columns
#}

{% macro get_column_values(table, column, sort_column=none, sort_direction=none, max_records=none, default=none) -%}
    {{ return(adapter.dispatch('get_column_values', packages = dbt_utils._get_utils_namespaces())(table, column, max_records, default)) }}
{% endmacro %}

{% macro default__get_column_values(table, column, sort_column=none, sort_direction=none, max_records=none, default=none) -%}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}
{#--  #}

    {%- set order_by = order_by if order_by else 'count(*)' -%}
    {%- set order_by = 'max(' ~ order_by ~ ')' if order_by == column else order_by -%}
    {%- set sort_direction -%}
        {%- if order_by == column -%}
        {{ sort_direction or 'asc' }} 
        {%- else -%}
        {{ sort_direction or 'desc' }}
        {%- endif -%}
    {%- endset -%}

    {%- set target_relation = adapter.get_relation(database=table.database,
                                          schema=table.schema,
                                         identifier=table.identifier) -%}

    {# If no sort column is supplied, we use the default descending frequency count. #}
    {%- call statement('get_column_values', fetch_result=true) %}

        {%- if not target_relation and default is none -%}

          {{ exceptions.raise_compiler_error("In get_column_values(): relation " ~ table ~ " does not exist and no default value was provided.") }}

        {%- elif not target_relation and default is not none -%}

          {{ log("Relation " ~ table ~ " does not exist. Returning the default value: " ~ default) }}

          {{ return(default) }}

        {%- else -%}

            with sorted_column_values as (

                select
                    {{ column }} as value,
                    {%- if sort_column is none %}
                    count(*) as sort_column
                    {% else %}
                    {# We take the max sort value for each value to make sure
                        there are no duplicate rows for each value #}
                    max({{ sort_column }}) as sort_column
                    {% endif %}
                from {{ target_relation }}
                group by 1
                order by {{ order_by }} {{ sort_direction }}
                {% if max_records is not none %}

                limit {{ max_records }}
                {% endif %}

            )
            select value from sorted_column_values

        {% endif %}

    {%- endcall -%}

    {%- set value_list = load_result('get_column_values') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values) }}
    {%- else -%}
        {{ return(default) }}
    {%- endif -%}

{%- endmacro %}
