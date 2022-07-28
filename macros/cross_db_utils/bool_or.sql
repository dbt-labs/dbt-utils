{% macro bool_or(expression) -%}
    {{ return(adapter.dispatch('bool_or', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__bool_or(expression) -%}
    {% do dbt_utils.xdb_deprecation_warning('bool_or', model.package_name, model.name) %}
    {{ return(adapter.dispatch('bool_or', 'dbt') (expression)) }}
{% endmacro %}
