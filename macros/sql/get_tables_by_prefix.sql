{% macro get_tables_by_prefix(schema, prefix, exclude='') %}

    {%- call statement('tables', fetch_result=True) %}

        select
            distinct table_schema || '.' || table_name as ref
        from information_schema.tables
        where table_schema = '{{ schema }}'
        and table_name ilike '{{ prefix }}%'
        and table_name not ilike '{{ exclude }}'

    {%- endcall -%}

    {%- set table_list = load_result('tables') -%}

    {%- if table_list and table_list['data'] -%}
        {%- set tables = table_list['data'] | map(attribute=0) | list %}
        {{ return(tables) }}
    {%- else -%}
        {{ return([]) }}
    {%- endif -%}

{% endmacro %}
