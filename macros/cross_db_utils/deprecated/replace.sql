{% macro replace(field, old_chars, new_chars) -%}
    {{ return(adapter.dispatch('replace', 'dbt_utils') (field, old_chars, new_chars)) }}
{% endmacro %}

{% macro default__replace(field, old_chars, new_chars) -%}
  {% do dbt_utils.xdb_deprecation_warning('replace', model.package_name, model.name) %}
    {{ return(adapter.dispatch('replace', 'dbt') (field, old_chars, new_chars)) }}
{% endmacro %}
