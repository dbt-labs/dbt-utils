{% macro array_append(array, new_element) -%}
  {{ return(adapter.dispatch('array_append', 'dbt_utils')(array, new_element)) }}
{%- endmacro %}

{% macro default__array_append(array, new_element) -%}
    array_append({{ array }}, {{ new_element }})
{%- endmacro %}

{% macro bigquery__array_append(array, new_element) -%}
    array_concat({{ array }}, {{ create_array(new_element) }})
{%- endmacro %}

{% macro redshift__array_append(array, new_element) -%}
    array_concat({{ array }}, {{ create_array(new_element) }})
{%- endmacro %}