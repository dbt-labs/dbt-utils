{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{% set replace_schema = regexp_replace(field, '^[-A-Za-z]+:\/\/', "''") | safe %}

{%- set parsed =
    dbt_utils.split_part(
        dbt_utils.split_part(
            replace_schema, "'/'", 1
            ), "'?'", 1
        )
-%}


    {{ dbt_utils.safe_cast(
        parsed,
        dbt_utils.type_string()
        )}}


{%- endmacro %}
