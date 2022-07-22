{% macro right(string_text, length_expression) -%}
    {{ return(adapter.dispatch('right', 'dbt_utils') (string_text, length_expression)) }}
{% endmacro %}

{% macro default__right(string_text, length_expression) -%}
    {% do dbt_utils.xdb_deprecation_warning('right', model.package_name, model.name) %}
    {{ return(adapter.dispatch('right', 'dbt') (string_text, length_expression)) }}
{% endmacro %}
