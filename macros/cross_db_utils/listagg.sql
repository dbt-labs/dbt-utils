{% macro listagg(measure, delimiter_text="','", order_by_clause=none, limit_num=none) -%}
    {{ return(adapter.dispatch('listagg', 'dbt') (measure, delimiter_text, order_by_clause, limit_num)) }}
{%- endmacro %}
