/*
  One macro to rule them all
  
  Provides a nice interface into api.Column.translate_type
  https://github.com/dbt-labs/dbt-core/blob/main/core/dbt/adapters/base/column.py#L10-L24
  
  Each adapter plugin can inherit/override TYPE_LABELS in its Column subclass
  E.g. BigQuery: https://github.com/dbt-labs/dbt-bigquery/blob/main/dbt/adapters/bigquery/column.py#L12-L19
  
  Maybe this is the one we push into dbt-core, and leave the others in dbt-utils?
  
  Downside: harder to tell what the valid options are, since the type is passed as an argument
  instead of being part of the macro name. We could add validation, but the default behavior
  feels better: just return the string passed in if there's no known translation.
*/

{%- macro get_data_type(dtype) -%}
  {# if there is no translation for 'dtype', it just returns 'dtype' #}
  {{ return(api.Column.translate_type(dtype)) }}
{%- endmacro -%}

{# string  -------------------------------------------------     #}

{%- macro type_string() -%}
  {{ return(adapter.dispatch('type_string', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_string() %}
    {{ return(dbt_utils.get_data_type("string")) }}
{% endmacro %}

-- This will return 'text' by default
-- On Postgres + Snowflake, that's equivalent to varchar (no size)
-- Redshift will treat that as varchar(256)


{# timestamp  -------------------------------------------------     #}

{%- macro type_timestamp() -%}
  {{ return(adapter.dispatch('type_timestamp', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_timestamp() %}
    {{ return(dbt_utils.get_data_type("timestamp")) }}
{% endmacro %}

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
'timestamp' means 'timestamp with time zone'
'datetime' means 'timestamp without time zone'

/* Snowflake:
https://docs.snowflake.com/en/sql-reference/data-types-datetime.html#timestamp
The TIMESTAMP_* variation associated with TIMESTAMP is specified by the TIMESTAMP_TYPE_MAPPING session parameter. The default is TIMESTAMP_NTZ.
*/


{# float  -------------------------------------------------     #}

{%- macro type_float() -%}
  {{ return(adapter.dispatch('type_float', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__type_float() %}
    {{ return(dbt_utils.get_data_type("float")) }}
{% endmacro %}

{# numeric  ------------------------------------------------     #}

{%- macro type_numeric() -%}
  {{ return(adapter.dispatch('type_numeric', 'dbt_utils')()) }}
{%- endmacro -%}

/*
This one can't be just translate_type, since precision/scale make it a bit more complicated.

On most databases, the default (precision, scale) is something like:
  Redshift: (18, 0)
  Snowflake: (38, 0)
  Postgres: (<=131072, 0)
  
https://www.postgresql.org/docs/current/datatype-numeric.html:
Specifying NUMERIC without any precision or scale creates an “unconstrained numeric”
column in which numeric values of any length can be stored, up to the implementation limits.
A column of this kind will not coerce input values to any particular scale,
whereas numeric columns with a declared scale will coerce input values to that scale.
(The SQL standard requires a default scale of 0, i.e., coercion to integer precision.
We find this a bit useless. If you're concerned about portability, always specify
the precision and scale explicitly.)
*/

{% macro default__type_numeric() %}
    {{ return(api.Column.numeric_type("numeric", 28, 6)) }}
{% endmacro %}

-- BigQuery default scale for 'numeric' is numeric(38, 9)
-- and it really doesn't like parametrized types
-- Should we override 'numeric_type' for dbt-bigquery to avoid returning parametrized types?
-- https://github.com/dbt-labs/dbt-bigquery/blob/main/dbt/adapters/bigquery/column.py

{% macro bigquery__type_numeric() %}
    {{ return(api.Column.numeric_type("numeric", None, None)) }}
{% endmacro %}


{# bigint  -------------------------------------------------     #}

{%- macro type_bigint() -%}
  {{ return(adapter.dispatch('type_bigint', 'dbt_utils')()) }}
{%- endmacro -%}

-- We don't have a conversion type for 'bigint' in TYPE_LABELS,
-- so this actually just returns the string 'bigint'

{% macro default__type_bigint() %}
    {{ return(dbt_utils.get_data_type("bigint")) }}
{% endmacro %}

-- Good news: BigQuery now supports 'bigint' (and 'int') as an alias for 'int64'

{# int  -------------------------------------------------     #}

{%- macro type_int() -%}
  {{ return(dbt_utils.get_data_type("integer")) }}
{%- endmacro -%}

-- returns 'int' everywhere, except BigQuery, where it returns 'int64'
-- (but BigQuery also now accepts 'int' as a valid alias for 'int64')
