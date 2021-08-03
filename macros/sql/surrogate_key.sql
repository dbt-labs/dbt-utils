{%- macro surrogate_key(columns, normalize_case = none) -%}
    {# needed for safe_add to allow for non-keyword arguments see SO post #}
    {# https://stackoverflow.com/questions/13944751/args-kwargs-in-jinja2-macros #}
    {% set frustrating_jinja_feature = varargs %}
    {{ return(adapter.dispatch('surrogate_key', 'cc_dbt_utils')(columns, normalize_case = none, *varargs)) }}
{% endmacro %}

{%- macro default__surrogate_key(columns, normalize_case = none) -%}

{% set fields = [] %}

{%- for field in columns -%}

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
