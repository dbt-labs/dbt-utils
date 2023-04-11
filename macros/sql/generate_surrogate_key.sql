{%- macro generate_surrogate_key(field_list, treat_nulls_as_empty_strings=None) -%}
    {{ return(adapter.dispatch('generate_surrogate_key', 'dbt_utils')(field_list, treat_nulls_as_empty_strings=None)) }}
{% endmacro %}

{%- macro default__generate_surrogate_key(field_list, treat_nulls_as_empty_strings=None) -%}


{# check for the override variable #}
{%- if treat_nulls_as_empty_strings -%}
    {%- set default_null_value = "" -%}
{%- elif not treat_nulls_as_empty_strings -%}
    {%- set default_null_value = '_dbt_utils_surrogate_key_null_' -%}
{# Check project config variable #}
{%- elif var('surrogate_key_treat_nulls_as_empty_strings', False) -%}
    {%- set default_null_value = "" -%}
{# fallback to default behavior #}
{%- else -%}
    {%- set default_null_value = '_dbt_utils_surrogate_key_null_' -%}
{%- endif -%}

{%- set fields = [] -%}

{%- for field in field_list -%}

    {%- do fields.append(
        "coalesce(cast(" ~ field ~ " as " ~ dbt.type_string() ~ "), '" ~ default_null_value  ~"')"
    ) -%}

    {%- if not loop.last %}
        {%- do fields.append("'-'") -%}
    {%- endif -%}

{%- endfor -%}

{{ dbt.hash(dbt.concat(fields)) }}

{%- endmacro -%}
