{% macro any_value(expression) -%}
    {{ return(adapter.dispatch('any_value', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__any_value(expression) -%}
    {% do dbt_utils.xdb_deprecation_warning('any_value', model.package_name, model.name) %}
    {{ return(adapter.dispatch('any_value', 'dbt') (expression)) }}
{% endmacro %}
