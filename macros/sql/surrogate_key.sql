{% macro surrogate_key(fields) -%}

md5(concat(

    {%- for field in fields %}

        coalesce(cast({{field}} as {{dbt_utils.type_string()}}), '')
        {% if not loop.last %},{% endif %}

    {%- endfor -%}

))

{%- endmacro %}
