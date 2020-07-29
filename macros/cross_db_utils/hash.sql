{% macro hash(field) -%}
  {{ adapter_macro('cc_dbt_utils.hash', field) }}
{%- endmacro %}


{% macro default__hash(field) -%}
    md5(cast({{field}} as {{cc_dbt_utils.type_string()}}))
{%- endmacro %}


{% macro bigquery__hash(field) -%}
    to_hex({{cc_dbt_utils.default__hash(field)}})
{%- endmacro %}
