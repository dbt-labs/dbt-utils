{% macro get_tables_by_prefix(schema, prefix, exclude='', database=target.database) %}

    {%- call statement('get_tables', fetch_result=True) %}

      {{ dbt_utils.get_tables_by_prefix_sql(schema, prefix, exclude) }}

    {%- endcall -%}

    {%- set table_list = load_result('get_tables') -%}

    {%- if table_list and table_list['table'] -%}
        {%- set tbl_relations = [] -%}
        {%- for row in table_list['table'] -%}
            {%- set tbl_relation = adapter.get_relation(database, row.table_schema, row.table_name) -%}
            {%- if not tbl_relation -%}
                {%- set tbl_relation = api.Relation.create(database, row.table_schema, row.table_name) -%}
            {%- endif -%}
            {%- do tbl_relations.append(tbl_relation) -%}
        {%- endfor -%}
                
        {{ return(tbl_relations) }}
    {%- else -%}
        {{ return([]) }}
    {%- endif -%}
    
{% endmacro %}

