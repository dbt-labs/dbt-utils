{#
This macro fetches the unique values for `column` in the table `table`

Arguments:
    table: A model `ref`, or a schema.table string for the table to query (Required)
    column: The column to query for unique values
    max_records: If provided, the maximum number of unique records to return (default: none)

Returns:
    A list of distinct values for the specified columns
#}

{% macro get_columns(table, column, max_records=none, fail=True, default='blank') -%}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}
{#--  #}

    {%- set table_name = table -%}

    {%- set table_value = adapter.get_relation(database=table_name.database,
                                          schema=table_name.schema,
                                         identifier=table_name.identifier) -%}

    {%- call statement('get_column_values', fetch_result=true) %}

        {%- if not table_value and fail -%}

          {{ log("Table doesn't exist..", info=True) }}
          {{ exceptions.raise_compiler_error("Table to pull columns from doesn't exist. Try running " ~ table ~ " and its dependencies first.") }}

        {%- elif not table_value and not fail -%}

          {{ log("Table doesn't exist..", info=True) }}
          {{ log("Trying to not fail", info=True) }}

          select '{{default}}' as value

        {%- else -%}

            select
                {{ column }} as value

            from {{ table }}
            group by 1
            order by count(*) desc

            {% if max_records is not none %}
            limit {{ max_records }}
            {% endif %}

        {% endif %}

    {%- endcall -%}

    {%- set value_list = load_result('get_column_values') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values) }}
    {%- else -%}
        {{ return(['']) }}
    {%- endif -%}

{%- endmacro %}
