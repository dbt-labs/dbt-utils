{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{%- set parsed =
    dbt.split_part(
        dbt.split_part(
            dbt.replace(
                dbt.replace(
                    dbt.replace(field, "'android-app://'", "''"
                    ), "'http://'", "''"
                ), "'https://'", "''"
            ), "'/'", 1
        ), "'?'", 1
    )

-%}


    {{ dbt.safe_cast(
        parsed,
        dbt.type_string()
        )}}

{%- endmacro %}
