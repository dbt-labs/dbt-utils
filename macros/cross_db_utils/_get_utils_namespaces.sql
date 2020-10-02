{% macro _get_utils_namespaces() %}
  {% set override_namespaces = var('dbt_utils_dispatch_list', []) %}
  {% do return(override_namespaces + ['cc_dbt_utils']) %}
{% endmacro %}
