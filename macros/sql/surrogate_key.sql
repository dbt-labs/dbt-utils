{%- macro surrogate_key(field_list) -%}
    {{ return(adapter.dispatch('surrogate_key', 'dbt_utils')(field_list)) }}
{% endmacro %}

{%- macro default__surrogate_key(field_list) -%}

{%- if field_list is not iterable or field_list is string or field_list is mapping -%}

{%- set error_message = '
Warning: the `surrogate_key` macro now takes a single list argument instead of \
string arguments. The {}.{} model triggered this warning. \
'.format(model.package_name, model.name) -%}

{%- do exceptions.warn(error_message) -%}

{%- endif -%}

{%- set fields = [] -%}

{%- for field in field_list -%}

    {%- do fields.append(
        "coalesce(cast(" ~ field ~ " as " ~ type_string() ~ "), '')"
    ) -%}

    {%- if not loop.last %}
        {%- do fields.append("'-'") -%}
    {%- endif -%}

{%- endfor -%}

{{ hash(concat(fields)) }}

{%- endmacro -%}
