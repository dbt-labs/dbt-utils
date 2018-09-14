{% macro grant_select_on_schemas(database_name, role_name) %}

    {%- call statement('get_schemata', fetch_result=True) %}

        USE {{ database_name }};
        SELECT CATALOG_NAME || '.' || SCHEMA_NAME as schema_name
        FROM   INFORMATION_SCHEMA.SCHEMATA
        WHERE SCHEMA_NAME <> 'INFORMATION_SCHEMA';

    {%- endcall -%}

    {%- set schema_list = load_result('get_schemata') -%}

    {%- if schema_list and schema_list['data'] -%}
        {%- set schemas = schema_list['data'] | map(attribute=0) | list %}

        {%- for schema in schemata -%}

            GRANT SELECT ON ALL TABLES IN SCHEMA {{ schema }} TO ROLE {{ role_name }};

        {%- endfor %}
    {%- endif -%}

{% endmacro %}
