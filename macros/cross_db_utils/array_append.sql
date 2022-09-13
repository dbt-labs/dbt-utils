{% macro array_append(array, new_element) -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('array_append', model.package_name, model.name) %}
  {{ return(adapter.dispatch('array_append', 'dbt_utils')(array, new_element)) }}
{%- endmacro %}

{# new_element must be the same data type as elements in array to match postgres functionality #}
{% macro default__array_append(array, new_element) -%}
    array_append({{ array }}, {{ new_element }})
{%- endmacro %}

{% macro bigquery__array_append(array, new_element) -%}
    {{ dbt_utils.array_concat(array, dbt_utils.array_construct([new_element])) }}
{%- endmacro %}

{% macro redshift__array_append(array, new_element) -%}
    {{ dbt_utils.array_concat(array, dbt_utils.array_construct([new_element])) }}
{%- endmacro %}