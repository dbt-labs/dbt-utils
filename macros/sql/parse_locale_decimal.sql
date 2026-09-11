{%- macro parse_locale_decimal(column) -%}
    {{ return(adapter.dispatch('parse_locale_decimal', 'dbt_utils')(column)) }}
{% endmacro %}

{#-
    Parses locale-formatted decimal strings that use a comma as the decimal
    separator and a period as the thousands separator, e.g. "1.234,56" -> 1234.56.

    Unparseable values (empty strings, garbage, nulls) return null instead of
    failing the run. A leading negative sign is preserved.
-#}
{%- macro default__parse_locale_decimal(column) -%}
    try_cast(
        replace(replace(trim({{ column }}), '.', ''), ',', '.')
        as {{ dbt.type_float() }}
    )
{% endmacro %}

{#- Postgres and Redshift have no try_cast, so only cast strings matching a
    comma-decimal pattern; anything else returns null. -#}
{%- macro postgres__parse_locale_decimal(column) -%}
    case
        when nullif(trim({{ column }}), '') ~ '^-?(\d{1,3}(\.\d{3})*|\d+)(,\d+)?$'
        then cast(
            replace(replace(trim({{ column }}), '.', ''), ',', '.')
            as {{ dbt.type_float() }}
        )
    end
{% endmacro %}

{%- macro redshift__parse_locale_decimal(column) -%}
    case
        when nullif(trim({{ column }}), '') ~ '^-?(\d{1,3}(\.\d{3})*|\d+)(,\d+)?$'
        then cast(
            replace(replace(trim({{ column }}), '.', ''), ',', '.')
            as {{ dbt.type_float() }}
        )
    end
{% endmacro %}

{#- BigQuery has no try_cast; safe_cast is its null-on-failure equivalent. -#}
{%- macro bigquery__parse_locale_decimal(column) -%}
    safe_cast(
        replace(replace(trim({{ column }}), '.', ''), ',', '.')
        as {{ dbt.type_float() }}
    )
{% endmacro %}
