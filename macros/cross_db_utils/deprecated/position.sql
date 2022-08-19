{% macro position(substring_text, string_text) -%}
    {{ return(adapter.dispatch('position', 'dbt_utils') (substring_text, string_text)) }}
{% endmacro %}

{% macro default__position(substring_text, string_text) -%}
    {% do dbt_utils.xdb_deprecation_warning('position', model.package_name, model.name) %}
    {{ return(adapter.dispatch('position', 'dbt') (substring_text, string_text)) }}
{% endmacro %}
