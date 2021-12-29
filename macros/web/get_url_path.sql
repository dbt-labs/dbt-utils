{% macro get_url_path(field) -%}
    {{ return(adapter.dispatch('get_url_path', 'cc_dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_path(field) -%}

    {%- set stripped_url = 
        cc_dbt_utils.replace(
            cc_dbt_utils.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{cc_dbt_utils.position("'/'", stripped_url)}}, 0),
            {{cc_dbt_utils.position("'?'", stripped_url)}} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        cc_dbt_utils.split_part(
            cc_dbt_utils.right(
                stripped_url, 
                cc_dbt_utils.length(stripped_url) ~ "-" ~ first_slash_pos
                ), 
            "'?'", 1
            )
    -%}

    {{ cc_dbt_utils.safe_cast(
        parsed_path,
        cc_dbt_utils.type_string()
    )}}
    
{%- endmacro %}
