{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{% set replace_schema = regexp_replace(field, '^[-A-Za-z]+:\/\/', "''") %}

{% set payment_methods_query %}
{{ dbt_utils.safe_cast(
    replace_schema,
    dbt_utils.type_string()
    )}}
{% endset %}

{% set results = run_query(payment_methods_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values()[0] %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{%- set parsed =
    dbt_utils.split_part(
        dbt_utils.split_part(
            results_list, "'/'", 1
            ), "'?'", 1
        )
-%}


    {{ dbt_utils.safe_cast(
        parsed,
        dbt_utils.type_string()
        )}}


{%- endmacro %}
