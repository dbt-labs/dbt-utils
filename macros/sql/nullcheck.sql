{% macro nullcheck(cols) %}
    {{ return(adapter.dispatch('nullcheck', packages = dbt_utils._get_utils_namespaces())(cols)) }}
{% endmacro %}

{% macro default__nullcheck(cols) %}
{%- for col in cols %}

    {% if col.is_string() -%}

    nullif({{col.name}},'') as {{col.name}}

    {%- else -%}

    {{col.name}}

    {%- endif -%}

{%- if not loop.last -%} , {%- endif -%}

{%- endfor -%}
{% endmacro %}
