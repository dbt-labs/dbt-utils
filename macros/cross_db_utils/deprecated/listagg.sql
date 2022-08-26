{% macro listagg(measure, delimiter_text="','", order_by_clause=none, limit_num=none) -%}
    {{ return(adapter.dispatch('listagg', 'dbt_utils') (measure, delimiter_text, order_by_clause, limit_num)) }}
{%- endmacro %}

{% macro default__listagg(measure, delimiter_text="','", order_by_clause=none, limit_num=none) -%}
    {% do dbt_utils.xdb_deprecation_warning('listagg', model.package_name, model.name) %}
    {{ return(adapter.dispatch('listagg', 'dbt') (measure, delimiter_text, order_by_clause, limit_num)) }}
{%- endmacro %}
