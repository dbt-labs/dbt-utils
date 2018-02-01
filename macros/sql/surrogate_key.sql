{% macro surrogate_key(fields) -%}

md5(concat(

    {%- for field in fields %}

        coalesce(
            {{dbt_utils.safe_cast(field, dbt_utils.type_string())}}
            , '')
        {% if not loop.last %},{% endif %}

    {%- endfor -%}

))

{%- endmacro %}
