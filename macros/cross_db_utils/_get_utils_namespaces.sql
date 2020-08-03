{% macro _get_utils_namespaces() %}
  {% set override_namespaces = var('utils_namespaces', []) %}
  {% do return(override_namespaces + ['dbt_utils']) %}
{% endmacro %}
