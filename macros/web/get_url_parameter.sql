{% macro get_url_parameter(field, url_parameter) -%}
    {{ return(adapter.dispatch('get_url_parameter', 'dbt_utils')(field, url_parameter)) }}
{% endmacro %}

{% macro default__get_url_parameter(field, url_parameter) -%}

{#-
    Normalize the query string so every parameter is preceded by `&`, then split on
    `&<url_parameter>=`. Requiring the leading `&` in the search token prevents false
    matches against parameters whose names merely *end* with `url_parameter`
    (e.g. searching for `g` inside `...&msg=...`).
    See: https://github.com/dbt-labs/dbt-utils/issues/980
-#}

{%- set formatted_url_parameter = "'&" + url_parameter + "='" -%}

{%- set normalized_field = dbt.concat(["'&'", dbt.replace(field, "'?'", "'&'")]) -%}

{%- set split = dbt.split_part(dbt.split_part(normalized_field, formatted_url_parameter, 2), "'&'", 1) -%}

nullif({{ split }},'')

{%- endmacro %}
