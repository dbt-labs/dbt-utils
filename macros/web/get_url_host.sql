{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', 'cc_dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{%- set parsed =
    cc_dbt_utils.split_part(
        cc_dbt_utils.split_part(
            cc_dbt_utils.replace(
                cc_dbt_utils.replace(
                    cc_dbt_utils.replace(field, "'android-app://'", "''"
                    ), "'http://'", "''"
                ), "'https://'", "''"
            ), "'/'", 1
        ), "'?'", 1
    )

-%}


    {{ cc_dbt_utils.safe_cast(
        parsed,
        cc_dbt_utils.type_string()
        )}}

{%- endmacro %}
