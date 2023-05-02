{% test equality(model, compare_model, compare_columns=None, ignore_columns=None, precision = None) %}
  {{ return(adapter.dispatch('test_equality', 'dbt_utils')(model, compare_model, compare_columns, ignore_columns, precision)) }}
{% endtest %}

{% macro default__test_equality(model, compare_model, compare_columns=None, ignore_columns=None, precision = None) %}

{%- if compare_columns and ignore_columns -%}
    {{ exceptions.raise_compiler_error("Both a compare and an ignore list were provided to the `equality` macro. Only one is allowed") }}
{%- endif -%}

{% set set_diff %}
    count(*) + coalesce(abs(
        sum(case when which_diff = 'a_minus_b' then 1 else 0 end) -
        sum(case when which_diff = 'b_minus_a' then 1 else 0 end)
    ), 0)
{% endset %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = set_diff) }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}



-- setup
{%- do dbt_utils._is_relation(model, 'test_equality') -%}

{# Ensure there are no extra columns in the compare_model vs model #}
{%- if not compare_columns and not ignore_columns -%}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set compare_columns_set = set(adapter.get_columns_in_relation(model) | map(attribute='quoted'))  -%}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set compare_model_columns_set = set(adapter.get_columns_in_relation(compare_model) | map(attribute='quoted')) -%}
    {% if compare_columns_set != compare_model_columns_set %}
        {{ return("select 1, 'b_minus_a' as which_diff from " ~ compare_model) }}
    {% endif %}
{% endif %}

{%- if not precision -%}
    {#-
        If the compare_cols arg is provided, we can run this test without querying the
        information schema — this allows the model to be an ephemeral model
    -#}
    {%- if not compare_columns -%}
        {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
        {%- set compare_columns = adapter.get_columns_in_relation(model)-%}


        {%- if ignore_columns -%}
            {#-- Lower case ignore columns for easier comparison --#}
            {%- set ignore_columns = ignore_columns | map("lower") | list %}

            {# Filter out the excluded columns #}
            {%- set include_columns = [] %}
            {%- for column in compare_columns -%}
                {%- if column.name | lower not in ignore_columns -%}
                    {% do include_columns.append(column) %}
                {%- endif %}
            {%- endfor %}

            {%- set compare_columns = include_columns | map(attribute='quoted') %}
        {%- else -%}
            {%- set compare_columns = compare_columns | map(attribute='quoted') %}
        {%- endif -%}
    {%- endif -%}

    {% set compare_cols_csv = compare_columns | join(', ') %}

{% else %}
    {#-
        If rounding is required, we need to get the types, so it can't be ephermeral
    -#}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set columns = adapter.get_columns_in_relation(model) -%}

    {% set columns_list = [] %}
    {%- for col in columns -%}
        {%- if (
                (col.name|lower in compare_columns|map('lower') or not compare_columns) and
                (col.name|lower not in ignore_columns|map('lower') or not ignore_columns)
                ) -%}
            {# Databricks double type is not picked up by any number type checks in dbt #}
            {%- if col.is_float() or col.is_numeric() or col.data_type == 'double' -%}
                {# Cast is required due to postgres not having round for a double precision number #}
                {%- do columns_list.append('round(cast(' ~ col.quoted ~ ' as ' ~ dbt.type_numeric() ~ '),' ~ precision ~ ') as ' ~ col.quoted) -%}
            {%- else -%}
                {%- do columns_list.append(col.quoted) -%}
            {%- endif -%}
        {% endif %}
    {%- endfor -%}

    {% set compare_cols_csv = columns_list | join(', ') %}

{% endif %}

with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{compare_cols_csv}} from a
    {{ dbt.except() }}
    select {{compare_cols_csv}} from b

),

b_minus_a as (

    select {{compare_cols_csv}} from b
    {{ dbt.except() }}
    select {{compare_cols_csv}} from a

),

unioned as (

    select 'a_minus_b' as which_diff, a_minus_b.* from a_minus_b
    union all
    select 'b_minus_a' as which_diff, b_minus_a.* from b_minus_a

)

select * from unioned

{% endmacro %}
