{% macro identifier(value) %}	
  {% do exceptions.warn("Warning: the `identifier` macro is no longer supported and will be deprecated in a future release of dbt-utils. Use `adapter.quote` instead") %}
  {{ adapter_macro('dbt_utils.identifier', value) }}	
{% endmacro %}	

{% macro default__identifier(value) -%}	
    "{{ value }}"	
{%- endmacro %}	

{% macro bigquery__identifier(value) -%}	
    `{{ value }}`	
{%- endmacro %}