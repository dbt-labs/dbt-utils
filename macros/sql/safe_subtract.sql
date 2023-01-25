{%- macro safe_subtract(field_list) -%}
    {{ return(adapter.dispatch('safe_subtract', 'dbt_utils')(field_list)) }}
{% endmacro %}

{%- macro default__safe_subtract(field_list) -%}

{%- if field_list is not iterable or field_list is string or field_list is mapping -%}

{%- set error_message = '
Warning: the `safe_subtract` macro takes a single list argument instead of \
string arguments. The {}.{} model triggered this warning. \
'.format(model.package_name, model.name) -%}

{%- do exceptions.raise_compiler_error(error_message) -%}

{%- endif -%}

{% set fields = [] %}

{%- for field in field_list -%}

    {% do fields.append("coalesce(" ~ field ~ ", 0)") %}

{%- endfor -%}

{{ fields|join(' -\n  ') }}

{%- endmacro -%}
