{%- macro safe_add() -%}
    {# needed for safe_add to allow for non-keyword arguments #}
    {% set dummy_var = args %}
    {{ return(adapter.dispatch('safe_add', packages = dbt_utils._get_utils_namespaces())(*args)) }}
{% endmacro %}

{%- macro default__safe_add() -%}

{% set fields = [] %}

{%- for field in varargs -%}

    {% do fields.append("coalesce(" ~ field ~ ", 0)") %}

{%- endfor -%}

{{ fields|join(' +\n  ') }}

{%- endmacro -%}
