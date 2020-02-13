{% macro get_relations_by_suffix(schema, suffix, exclude='', database=target.database) %}

    {%- call statement('get_tables', fetch_result=True) %}

      {{ dbt_utils.get_tables_by_suffix_sql(schema, suffix, exclude, database) }}

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

{% macro get_tables_by_suffix(schema, suffix, exclude='', database=target.database) %}
    {% if execute %}
        {{ log("Warning: the `get_tables_by_suffix` macro is no longer supported and will be deprecated in a future release of dbt-utils. Use the `get_relations_by_suffix` macro instead", info=True) }}
    {% endif %}


    {{ return(dbt_utils.get_relations_by_suffix(schema, suffix, exclude, database)) }}

{% endmacro %}