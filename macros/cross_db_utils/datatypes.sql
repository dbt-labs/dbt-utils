{# This is here for backwards compatibility only #}

{%- macro type_string() -%}
  {{ return(adapter.dispatch('type_string', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_string() -%}
  {{ return(adapter.dispatch('type_string', 'dbt')()) }}
{%- endmacro -%}

{%- macro type_timestamp() -%}
  {{ return(adapter.dispatch('type_timestamp', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_timestamp() -%}
  {{ return(adapter.dispatch('type_timestamp', 'dbt')()) }}
{%- endmacro -%}

{%- macro type_float() -%}
  {{ return(adapter.dispatch('type_float', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_float() -%}
  {{ return(adapter.dispatch('type_float', 'dbt')()) }}
{%- endmacro -%}

{%- macro type_numeric() -%}
  {{ return(adapter.dispatch('type_numeric', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_numeric() -%}
  {{ return(adapter.dispatch('type_numeric', 'dbt')()) }}
{%- endmacro -%}

{%- macro type_bigint() -%}
  {{ return(adapter.dispatch('type_bigint', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_bigint() -%}
  {{ return(adapter.dispatch('type_bigint', 'dbt')()) }}
{%- endmacro -%}

{%- macro type_int() -%}
  {{ return(adapter.dispatch('type_int', 'dbt_utils')()) }}
{%- endmacro -%}

{%- macro default__type_int() -%}
  {{ return(adapter.dispatch('type_int', 'dbt')()) }}
{%- endmacro -%}
