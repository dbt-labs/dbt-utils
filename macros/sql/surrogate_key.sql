{%- macro surrogate_key(columns, normalize_case = none) -%}

{% set fields = [] %}

{%- set error_message = '
Warning: the `surrogate_key` macro now takes a single list argument instead of \
multiple string arguments. Support for multiple string arguments will be \
deprecated in a future release of dbt-utils. The {}.{} model triggered this warning. \
'.format(model.package_name, model.name) -%}

{%- do exceptions.warn(error_message) -%}

    {% if normalize_case is none %}
          
        {%- set _ = fields.append(
            "coalesce(cast(" ~ field ~ " as " ~ cc_dbt_utils.type_string() ~ "), '')"
        ) -%}

    {% elif normalize_case is not none %}

        {%- set _ = fields.append(
            "upper(coalesce(cast(" ~ field ~ " as " ~ cc_dbt_utils.type_string() ~ "), ''))"
        ) -%}

    {% endif %}

    {% if not loop.last %}
        {% set _ = fields.append("'-'") %}
    {% endif %}

{%- endfor -%}

{{cc_dbt_utils.hash(cc_dbt_utils.concat(fields))}}

{%- endmacro -%}
