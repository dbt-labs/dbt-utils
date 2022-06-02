{# string  -------------------------------------------------     #}

{%- macro type_string() -%}
    {{ return(adapter.dispatch('type_string', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_string() %}
    {{ return(adapter.dispatch('type_string', 'dbt')()) }}
{% endmacro %}

-- This will return 'text' by default
-- On Postgres + Snowflake, that's equivalent to varchar (no size)
-- Redshift will treat that as varchar(256)


{# timestamp  -------------------------------------------------     #}

{%- macro type_timestamp() -%}
    {{ return(adapter.dispatch('type_timestamp', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_timestamp() %}
    {{ return(adapter.dispatch('type_timestamp', 'dbt')()) }}
{% endmacro %}

<<<<<<< HEAD
=======
/*
POSTGRES
https://www.postgresql.org/docs/current/datatype-datetime.html:
The SQL standard requires that writing just `timestamp` 
be equivalent to `timestamp without time zone`, and 
PostgreSQL honors that behavior. 
`timestamptz` is accepted as an abbreviation for `timestamp with time zone`;
this is a PostgreSQL extension.

SNOWFLAKE
https://docs.snowflake.com/en/sql-reference/data-types-datetime.html#timestamp
The TIMESTAMP_* variation associated with TIMESTAMP is specified by the 
TIMESTAMP_TYPE_MAPPING session parameter. The default is TIMESTAMP_NTZ.

BIGQUERY
TIMESTAMP means 'timestamp with time zone'
DATETIME means 'timestamp without time zone'
TODO: shouldn't this return DATETIME instead of TIMESTAMP, for consistency with other databases?
e.g. dateadd returns a DATETIME

/* Snowflake:
https://docs.snowflake.com/en/sql-reference/data-types-datetime.html#timestamp
The TIMESTAMP_* variation associated with TIMESTAMP is specified by the TIMESTAMP_TYPE_MAPPING session parameter. The default is TIMESTAMP_NTZ.
*/

>>>>>>> caf0388 (Refactor tests, passing on BQ)

{# float  -------------------------------------------------     #}

{%- macro type_float() -%}
    {{ return(adapter.dispatch('type_float', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_float() %}
    {{ return(adapter.dispatch('type_float', 'dbt')()) }}
{% endmacro %}


{# numeric  ------------------------------------------------     #}

{%- macro type_numeric() -%}
    {{ return(adapter.dispatch('type_numeric', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_numeric() %}
    {{ return(adapter.dispatch('type_numeric', 'dbt')()) }}
{% endmacro %}


{# bigint  -------------------------------------------------     #}

{%- macro type_bigint() -%}
    {{ return(adapter.dispatch('type_bigint', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_bigint() %}
    {{ return(adapter.dispatch('type_bigint', 'dbt')()) }}
{% endmacro %}


{# int  -------------------------------------------------     #}

{%- macro type_int() -%}
    {{ return(adapter.dispatch('type_int', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_int() %}
    {{ return(adapter.dispatch('type_int', 'dbt')()) }}
{% endmacro %}

-- returns 'int' everywhere, except BigQuery, where it returns 'int64'
-- (but BigQuery also now accepts 'int' as a valid alias for 'int64')
