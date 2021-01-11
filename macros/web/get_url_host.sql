{% macro get_url_host(field) -%}
    {{ return(adapter.dispatch('get_url_host', packages = dbt_utils._get_utils_namespaces())(field)) }}
{% endmacro %}

{% macro default__get_url_host(field) -%}

{%- set parsed = 
    dbt_utils.split_part(
        dbt_utils.split_part(
            dbt_utils.replace(
                dbt_utils.replace(field, "'http://'", "''"
                ), "'https://'", "''"
            ), "'/'", 1
        ), "'?'", 1
    )
    
-%}

     
    {{ dbt_utils.safe_cast(
        parsed,
        dbt_utils.type_string()
        )}}
        

{%- endmacro %}