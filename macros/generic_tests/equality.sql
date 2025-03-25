{% test equality(model, compare_model, compare_columns=None, exclude_columns=None, precision = None) %}
  {{ return(adapter.dispatch('test_equality', 'dbt_utils')(model, compare_model, compare_columns, exclude_columns, precision)) }}
{% endtest %}

{% macro default__test_equality(model, compare_model, compare_columns=None, exclude_columns=None, precision = None) %}

{%- if compare_columns and exclude_columns -%}
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
{%- if not compare_columns -%}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- do dbt_utils._is_ephemeral(compare_model, 'test_equality') -%}

    {%- set model_columns = adapter.get_columns_in_relation(model) -%}
    {%- set compare_model_columns = adapter.get_columns_in_relation(compare_model) -%}


    {%- if exclude_columns -%}
        {#-- Lower case ignore columns for easier comparison --#}
        {%- set exclude_columns = exclude_columns | map("lower") | list %}

        {# Filter out the excluded columns #}
        {%- set include_columns = [] %}
        {%- set include_model_columns = [] %}
        {%- for column in model_columns -%}
            {%- if column.name | lower not in exclude_columns -%}
                {% do include_columns.append(column) %}
            {%- endif %}
        {%- endfor %}
        {%- for column in compare_model_columns -%}
            {%- if column.name | lower not in exclude_columns -%}
                {% do include_model_columns.append(column) %}
            {%- endif %}
        {%- endfor %}

        {%- set compare_columns_set = set(include_columns | map(attribute='quoted') | map("lower")) %}
        {%- set compare_model_columns_set = set(include_model_columns | map(attribute='quoted') | map("lower")) %}
    {%- else -%}
        {%- set compare_columns_set = set(model_columns | map(attribute='quoted') | map("lower")) %}
        {%- set compare_model_columns_set = set(compare_model_columns | map(attribute='quoted') | map("lower")) %}
    {%- endif -%}

    {% if compare_columns_set != compare_model_columns_set %}
        {{ exceptions.raise_compiler_error(compare_model ~" has different columns than " ~ model ~ ", please ensure they have the same columns or use the `compare_columns` or `exclude_columns` arguments to subset them.") }}
    {% endif %}


{% endif %}

{# If testing with precision, then find out which columns in the main input model are numeric #}
{%- set numeric_columns = {} -%}
{%- if precision -%}
    {#-
        If rounding is required, we need to get the types, so it cannot be ephemeral even if they provide column names
    -#}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set columns = adapter.get_columns_in_relation(model) -%}

    {% set columns_list = [] %}
    {%- for col in columns -%}
        {# Databricks double type is not picked up by any number type checks in dbt #}
        {%- if col.is_float() or col.is_numeric() or col.data_type == 'double' -%}
            {#- Lower case the column name for easier case-insensitive comparison -#}
            {%- do numeric_columns.update({col.name|lower: true}) -%}
            {#- Also include the quoted version, since we may see it as well. -#}
            {%- do numeric_columns.update({col.quoted|lower: true}) -%}
        {%- endif -%}
    {%- endfor -%}
{%- endif -%}

{# If compare_columns is provided, sort any given arrays into lists of columns for each model #}
{%- if compare_columns -%}
    {%- set compare_columns__model = [] %}
    {%- set compare_columns__compare_model = [] %}

    {%- for column in compare_columns -%}
        {%- if column is string -%}
            {# A simple string was given.  Assume the same column name in both models. #}
            {%- do compare_columns__model.append(column) -%}
            {%- do compare_columns__compare_model.append(column) -%}
        {%- elif column is iterable and column | length == 2 -%}
            {%- do compare_columns__model.append(column[0]) -%}
            {%- do compare_columns__compare_model.append(column[1]) -%}
        {%- else -%}
            {{ exceptions.raise_compiler_error("compare_columns must be a string or a list of 2 strings") }}
        {%- endif -%}
    {%- endfor -%}
{%- else -%}
    {#
        You cannot get the columns in an ephemeral model (due to not existing in the information schema),
        so if the user does not provide an explicit list of columns we must error in the case it is ephemeral
    #}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set model_columns = adapter.get_columns_in_relation(model)-%}

    {%- if exclude_columns -%}
        {#-- Lower case ignore columns for easier comparison --#}
        {%- set exclude_columns = exclude_columns | map("lower") | list %}
    {%- endif -%}

    {# Filter out the excluded columns #}
    {%- set include_columns = [] %}
    {%- for column in model_columns -%}
        {%- if (not exclude_columns) or (column.name | lower not in exclude_columns) -%}
            {% do include_columns.append(column) %}
        {%- endif %}
    {%- endfor %}

    {# Assume same column names in the comparison model, since no alternates were given using compare_columns. #}
    {%- set compare_columns__model = include_columns | map(attribute='quoted') | list %}
    {%- set compare_columns__compare_model = compare_columns__model %}
{%- endif -%}

{# Build comma-delimited lists of column names for each input model.  Round numeric types as needed. #}
{%- set compare_columns_csv = [] -%}
{%- set numeric_column_indexes_in_first_model = [] -%}
{%- for this_model_compare_columns in [compare_columns__model, compare_columns__compare_model] -%}
    {%- set columns_list = [] %}
    {%- set is_first_model = loop.first -%}

    {%- for this_compare_column in this_model_compare_columns -%}
        {# NOTE: We assume any numeric columns in the first model are also numeric in the second model #}
        {%- if (is_first_model and this_compare_column|lower in numeric_columns) or (loop.index0 in numeric_column_indexes_in_first_model) -%}
            {# Cast is required due to postgres not having round for a double precision number #}
            {%- do columns_list.append('round(cast(' ~ this_compare_column ~ ' as ' ~ dbt.type_numeric() ~ '),' ~ precision ~ ') as ' ~ this_compare_column) -%}

            {%- if is_first_model -%}
                {%- do numeric_column_indexes_in_first_model.append(loop.index0) -%}
            {%- endif -%}
        {%- else -%} {# Non-numeric type #}
            {%- do columns_list.append(this_compare_column) -%}
        {%- endif -%}
    {%- endfor -%}

    {%- do compare_columns_csv.append(columns_list | join(', ')) -%}
{%- endfor -%}

with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{compare_columns_csv[0]}} from a
    {{ dbt.except() }}
    select {{compare_columns_csv[1]}} from b

),

b_minus_a as (

    select {{compare_columns_csv[1]}} from b
    {{ dbt.except() }}
    select {{compare_columns_csv[0]}} from a

),

unioned as (

    select 'a_minus_b' as which_diff, a_minus_b.* from a_minus_b
    union all
    select 'b_minus_a' as which_diff, b_minus_a.* from b_minus_a

)

select * from unioned

{% endmacro %}
