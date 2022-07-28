{% macro length(expression) -%}
    {{ return(adapter.dispatch('length', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__length(expression) -%}
    {% do dbt_utils.xdb_deprecation_warning('length', model.package_name, model.name) %}
    {{ return(adapter.dispatch('length', 'dbt') (expression)) }}
{% endmacro %}
