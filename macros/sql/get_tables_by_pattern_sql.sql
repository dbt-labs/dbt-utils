{% macro get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}
    {{ adapter.dispatch('get_tables_by_pattern_sql', packages = dbt_utils._get_utils_namespaces())
        (schema_pattern, table_pattern, exclude='', database=target.database) }}
{% endmacro %}

{% macro default__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

        select distinct 
            table_schema as "table_schema", table_name as "table_name"
        from {{database}}.information_schema.tables
        where table_schema ilike '{{ schema_pattern }}'
        and table_name ilike '{{ table_pattern }}'
        and table_name not ilike '{{ exclude }}'

{% endmacro %}


{% macro bigquery__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}
    
        select distinct
            table_schema, table_name

        from {{adapter.quote(database)}}.{{schema}}.INFORMATION_SCHEMA.TABLES
        where table_schema = '{{schema_pattern}}'
            and lower(table_name) like lower ('{{table_pattern}}')
            and lower(table_name) not like lower ('{{exclude}}')

{% endmacro %}
