{# string  -------------------------------------------------     #}

{%- macro type_string() -%}
  {{ adapter_macro('dbt_utils.type_string') }}
{%- endmacro -%}

{% macro default__type_string() %}
    string
{% endmacro %}

{%- macro redshift__type_string() -%}
    varchar
{%- endmacro -%}

{% macro postgres__type_string() %}
    varchar
{% endmacro %}

{% macro snowflake__type_string() %}
    varchar
{% endmacro %}



{# timestamp  -------------------------------------------------     #}

{%- macro type_timestamp() -%}
  {{ adapter_macro('dbt_utils.type_timestamp') }}
{%- endmacro -%}

{% macro default__type_timestamp() %}
    timestamp
{% endmacro %}

{% macro snowflake__type_timestamp() %}
    timestamp_ntz
{% endmacro %}


{# float  -------------------------------------------------     #}

{%- macro type_float() -%}
  {{ adapter_macro('dbt_utils.type_float') }}
{%- endmacro -%}

{% macro default__type_float() %}
    float
{% endmacro %}

{% macro bigquery__type_float() %}
    float64
{% endmacro %}

{# numeric  ------------------------------------------------     #}

{%- macro type_numeric() -%}
  {{ adapter_macro('dbt_utils.type_numeric') }}
{%- endmacro -%}

{% macro default__type_numeric() %}
    numeric(28, 6)
{% endmacro %}

{% macro bigquery__type_numeric() %}
    numeric
{% endmacro %}


{# bigint  -------------------------------------------------     #}

{%- macro type_bigint() -%}
  {{ adapter_macro('dbt_utils.type_bigint') }}
{%- endmacro -%}

{% macro default__type_bigint() %}
    bigint
{% endmacro %}

{% macro bigquery__type_bigint() %}
    int64
{% endmacro %}

{# int  -------------------------------------------------     #}

{%- macro type_int() -%}
  {{ adapter_macro('dbt_utils.type_int') }}
{%- endmacro -%}

{% macro default__type_int() %}
    int
{% endmacro %}

{% macro bigquery__type_int() %}
    int64
{% endmacro %}
