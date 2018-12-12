{% macro get_tables_by_prefix(schema, prefix, exclude='') %}
  {{ return(adapter_macro('dbt_utils.get_tables_by_prefix', schema, prefix, exclude)) }}
{% endmacro %}

{% macro default__get_tables_by_prefix(schema, prefix, exclude='') %}

    {%- call statement('tables', fetch_result=True) %}

      {{ dbt_utils.get_tables_by_prefix_sql(schema, prefix, exclude) }}

    {%- endcall -%}

    {%- set table_list = load_result('tables') -%}

    {%- if table_list and table_list['data'] -%}
        {%- set tables = table_list['data'] | map(attribute=0) | list %}
        {{ return(tables) }}
    {%- else -%}
        {{ return([]) }}
    {%- endif -%}
    
{% endmacro %}

