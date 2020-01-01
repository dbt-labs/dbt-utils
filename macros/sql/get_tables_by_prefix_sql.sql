{% macro get_tables_by_prefix_sql(schema, prefix, exclude='', database=target.database) %}
    {{ adapter_macro('dbt_utils.get_tables_by_prefix_sql', schema, prefix, exclude, database) }}
{% endmacro %}

{% macro default__get_tables_by_prefix_sql(schema, prefix, exclude='', database=target.database) %}

        select distinct 
            table_schema as "table_schema", table_name as "table_name"
        from {{database}}.information_schema.tables
        where table_schema ilike '{{ schema }}'
        and table_name ilike '{{ prefix }}%'
        and table_name not ilike '{{ exclude }}'

{% endmacro %}


{% macro bigquery__get_tables_by_prefix_sql(schema, prefix, exclude='', database=target.database) %}
    
        select distinct
            dataset_id as table_schema, table_id as table_name

        from {{adapter.quote(database)}}.{{schema}}.__TABLES_SUMMARY__
        where dataset_id = '{{schema}}'
            and lower(table_id) like lower ('{{prefix}}%')
            and lower(table_id) not like lower ('{{exclude}}')

{% endmacro %}
