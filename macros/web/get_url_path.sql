{% macro get_url_path(field) -%}
    {{ return(adapter.dispatch('get_url_path', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_path(field) -%}

    {%- set stripped_url =
        replace(
            replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{ position("'/'", stripped_url) }}, 0),
            {{ position("'?'", stripped_url) }} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        split_part(
            right(
                stripped_url,
                length(stripped_url) ~ "-" ~ first_slash_pos
                ),
            "'?'", 1
            )
    -%}

    {{ safe_cast(
        parsed_path,
        type_string()
    )}}

{%- endmacro %}
