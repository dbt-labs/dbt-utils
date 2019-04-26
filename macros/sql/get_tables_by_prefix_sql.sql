{% macro get_tables_by_prefix_sql(schema, prefix, exclude='') %}
    {{ adapter_macro('dbt_utils.get_tables_by_prefix_sql', schema, prefix, exclude) }}
{% endmacro %}

{% macro default__get_tables_by_prefix_sql(schema, prefix, exclude='') %}

        select distinct 
            table_schema, table_name
        from information_schema.tables
        where table_schema = '{{ schema }}'
        and table_name ilike '{{ prefix }}%'
        and table_name not ilike '{{ exclude }}'

{% endmacro %}


{% macro bigquery__get_tables_by_prefix_sql(schema, prefix, exclude='') %}
    
        select distinct
            dataset_id as table_schema, table_id as table_name

        from {{schema}}.__TABLES_SUMMARY__
        where dataset_id = '{{schema}}'
            and lower(table_id) like lower ('{{prefix}}%')
            and lower(table_id) not like lower ('{{exclude}}')

{% endmacro %}
