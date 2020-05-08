{% macro get_tables_by_schema_prefix(schema_prefix, table_name, exclude='', database=target.database) %}

        select distinct 
            table_schema as "table_schema", table_name as "table_name"
        from {{database}}.information_schema.tables
        where table_schema ilike '{{ schema_prefix }}%'
        and table_name ilike '{{ table_name }}'
        and table_name not ilike '{{ exclude }}'

{% endmacro %} 


