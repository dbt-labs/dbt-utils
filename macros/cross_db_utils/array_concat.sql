{% macro array_concat(array_1, array_2) -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('array_concat', model.package_name, model.name) %}
  {{ return(adapter.dispatch('array_concat', 'dbt_utils')(array_1, array_2)) }}
{%- endmacro %}

{% macro default__array_concat(array_1, array_2) -%}
    array_cat({{ array_1 }}, {{ array_2 }})
{%- endmacro %}

{% macro bigquery__array_concat(array_1, array_2) -%}
    array_concat({{ array_1 }}, {{ array_2 }})
{%- endmacro %}

{% macro redshift__array_concat(array_1, array_2) -%}
    array_concat({{ array_1 }}, {{ array_2 }})
{%- endmacro %}