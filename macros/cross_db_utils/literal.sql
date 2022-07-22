{%- macro string_literal(value) -%}
  {{ return(adapter.dispatch('string_literal', 'dbt_utils') (value)) }}
{%- endmacro -%}

{%- macro default__string_literal(value) -%}
  {% do dbt_utils.xdb_deprecation_warning('string_literal', model.package_name, model.name) %}
  {{ return(adapter.dispatch('string_literal', 'dbt') (value)) }}
{%- endmacro -%}
