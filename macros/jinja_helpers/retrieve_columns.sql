{% macro retrieve_columns_test(columns, starts=False, is_dict=False, prefix=none) -%}
{%- if prefix -%}
    {%- set prefix_and_dot = prefix+'.' -%}
{% else -%}
    {%- set prefix_and_dot = '' -%}
{%- endif -%}

{%- if is_dict  -%}
    {%- for key, value  in columns.items() %}
        {% if loop.first and starts-%}
            {{prefix_and_dot}}{{key}} as {{value}}
        {% else -%}
            , {{prefix_and_dot}}{{key}} as {{value}}
        {%- endif -%}
    {%- endfor -%}

{% else -%}
    {%- for col  in columns %}
        {% if loop.first and starts-%}
            {{prefix_and_dot}}{{col}}
        {% else -%}
            , {{prefix_and_dot}}{{col}}
        {%- endif -%}
    {%- endfor %}
{% endif %}

{% endmacro -%}
