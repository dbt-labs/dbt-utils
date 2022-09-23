{%- macro surrogate_key(field_list) -%}
    {% set frustrating_jinja_feature = varargs %}
    {{ return(adapter.dispatch('surrogate_key', 'dbt_utils')(field_list, *varargs)) }}
{% endmacro %}

{%- macro default__surrogate_key(field_list) -%}

{%- set error_message = '
Warning: the `dbt_utils.surrogate_key` macro has been fully deprecated in favor of \
the new `generate_surrogate_key` macro. This new macro adjusts the default string value \
passed to the coalesce function. To achieve parity with the original macro, \
add a variable called `surrogate_key_treat_nulls_as_empty_strings` to your project with a \
value of True. \
The {}.{} model triggered this warning. \
'.format(model.package_name, model.name) -%}

{%- do exceptions.raise_compiler_error(error_message) -%}

{%- endmacro -%}
