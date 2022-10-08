{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{%- set parsed =
    split_part(
        split_part(
            replace(
                replace(
                    replace(field, "'android-app://'", "''"
                    ), "'http://'", "''"
                ), "'https://'", "''"
            ), "'/'", 1
        ), "'?'", 1
    )

-%}


    {{ dbt.safe_cast(
        parsed,
        type_string()
        )}}

{%- endmacro %}
