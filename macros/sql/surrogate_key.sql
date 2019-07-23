{%- macro surrogate_key() -%}

{% set fields = [] %}

{%- for field in varargs -%}

    {% set _ = fields.append(
        "coalesce(cast(" ~ field ~ " as " ~ dbt_utils.type_string() ~ "), '')"
    ) %}

    {% if not loop.last %}
        {% set _ = fields.append("'-'") %}
    {% endif %}

{%- endfor -%}

{{dbt_utils.hash(dbt_utils.concat(fields))}}

{%- endmacro -%}
