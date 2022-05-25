{%- macro string_literal(value) -%}
  {{ return(adapter.dispatch('string_literal', 'dbt') (value)) }}
{%- endmacro -%}
