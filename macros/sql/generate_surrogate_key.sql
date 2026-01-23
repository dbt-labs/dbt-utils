{%- macro generate_surrogate_key(field_list, trim=false) -%}
    {{ return(adapter.dispatch('generate_surrogate_key', 'dbt_utils')(field_list, trim)) }}
{% endmacro %}

{%- macro default__generate_surrogate_key(field_list, trim=false) -%}

{%- if var('surrogate_key_treat_nulls_as_empty_strings', False) -%}
    {%- set default_null_value = "" -%}
{%- else -%}
    {%- set default_null_value = '_dbt_utils_surrogate_key_null_' -%}
{%- endif -%}

{%- set fields = [] -%}

{%- for field in field_list -%}

    {%- if trim -%}
        {%- do fields.append(
            "coalesce(trim(cast(" ~ field ~ " as " ~ dbt.type_string() ~ ")), '" ~ default_null_value  ~"')"
        ) -%}
    {%- else -%}
        {%- do fields.append(
            "coalesce(cast(" ~ field ~ " as " ~ dbt.type_string() ~ "), '" ~ default_null_value  ~"')"
        ) -%}
    {%- endif -%}

    {%- if not loop.last %}
        {%- do fields.append("'-'") -%}
    {%- endif -%}

{%- endfor -%}

{{ dbt.hash(dbt.concat(fields)) }}

{%- endmacro -%}