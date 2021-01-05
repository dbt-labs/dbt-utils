{% macro get_relations_by_prefix(schema, prefix, exclude='', database=target.database) %}
    {{ adapter.dispatch('get_relations_by_prefix', packages = dbt_utils._get_utils_namespaces())(schema, prefix, exclude='', database=target.database) }}
{% endmacro %}

{% macro default__get_relations_by_prefix(schema, prefix, exclude='', database=target.database) %}

    {%- call statement('get_tables', fetch_result=True) %}

      {{ dbt_utils.get_tables_by_prefix_sql(schema, prefix, exclude, database) }}

    {%- endcall -%}

    {%- set table_list = load_result('get_tables') -%}

    {%- if table_list and table_list['table'] -%}
        {%- set tbl_relations = [] -%}
        {%- for row in table_list['table'] -%}
            {%- set tbl_relation = api.Relation.create(database, row.table_schema, row.table_name) -%}
            {%- do tbl_relations.append(tbl_relation) -%}
        {%- endfor -%}

        {{ return(tbl_relations) }}
    {%- else -%}
        {{ return([]) }}
    {%- endif -%}

{% endmacro %}
