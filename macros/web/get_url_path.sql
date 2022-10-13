{% macro get_url_path(field) -%}
    {{ return(adapter.dispatch('get_url_path', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_path(field) -%}

    {%- set stripped_url =
        dbt.replace(
            dbt.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{ dbt.position("'/'", stripped_url) }}, 0),
            {{ dbt.position("'?'", stripped_url) }} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        dbt.split_part(
            dbt.right(
                stripped_url,
                dbt.length(stripped_url) ~ "-" ~ first_slash_pos
                ),
            "'?'", 1
            )
    -%}

    {{ dbt.safe_cast(
        parsed_path,
        dbt.type_string()
    )}}

{%- endmacro %}
