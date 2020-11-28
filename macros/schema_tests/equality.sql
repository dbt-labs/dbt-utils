-- noinspection SqlNoDataSourceInspectionForFile

{% macro filter_columns(
        input_columns,
        col_names_to_keep,
        case_sensitive=false
) %}
{# Filter `input_columns` to just the columns named in `col_names_to_keep`.
   Raise compilation error if all columns named in `col_names_to_keep` can't be found.
#}

{% set filtered_col_list = [] %}
{% set found_col_names = [] %}
{% set missing_col_names = [] %}

{% if not case_sensitive %}
    {% set col_names_to_keep = col_names_to_keep | map('lower') | list %}
{% endif %}

{% for column in input_columns %}
  {% if case_sensitive %}
      {% set column_name = column.name %}
  {% else %}
      {% set column_name = column.name | lower %}
  {% endif %}}

  {% if column_name in col_names_to_keep %}
    {% do filtered_col_list.append(column) %}
    {% do found_col_names.append(column_name) %}
  {% endif %}
{% endfor %}

{% if col_names_to_keep | length == found_col_names | length %}
    {{ return(filtered_col_list) }}
{% else %}
    {% for column_name in col_names_to_keep %}
        {% if column_name | lower not in found_col_names | map('lower') | list %}
            {% do missing_col_names.append(column_name) %}
        {% endif %}
    {% endfor %}
    {{ exceptions.raise_compiler_error(
        "Not all needed columns found in table columns. "
        "Missing: " ~ missing_col_names | join(', ') ~ ". "
        "Search was case sensitive: " ~ case_sensitive ~ "."
    ) }}
{% endif %}

{% endmacro %}


{% macro data_type_for_column_name(column_list, column_name) %}
{% for column in column_list %}
    {% if column.name | lower == column_name | lower %}
        {{ return(column.data_type) }}
    {% endif %}
{% endfor %}
{% endmacro %}


{% macro test_matching_data_types(cols_a, cols_b) %}
{# Presuming test to make sure the columns being checked are in both lists has
   already been run so that isn't being checked here
#}

{% set non_matching_columns = [] %}

{% for column in cols_a %}
    {% set a_data_type = column.data_type %}
    {% set b_data_type = data_type_for_column_name(cols_b, column.name) %}
    {% if a_data_type != b_data_type %}
        {% do non_matching_columns.append({
            'column_name': column.name,
            'a_data_type': a_data_type,
            'b_data_type': b_data_type
            })
        %}
    {% endif %}
{% endfor %}

{% if non_matching_columns %}
    {{ exceptions.raise_compiler_error(
        "Data types of columns in A and B tables don't all match: "
        ~ non_matching_columns
    ) }}
{% endif %}

{% endmacro %}


{% macro test_matching_order(a_csv, b_csv, case_sensitive=false) %}
{% if not case_sensitive %}
  {% set a_csv = a_csv | lower %}
  {% set b_csv = b_csv | lower %}
{% endif %}

{% if a_csv != b_csv %}
    {{ exceptions.raise_compiler_error(
        "Order of columns in A and B tables does not match. "
        "A columns: " ~ a_csv ~ ". "
        "B columns: " ~ b_csv ~ ". "
        "Comparison was case sensitive: " ~ case_sensitive ~ "."
    ) }}
{% endif %}

{% endmacro %}


{% macro validate_metadata_test_inputs(column_metadata_tests) %}
{% set allowed_tests = [
    'all_columns_present_in_both_tables',
    'case_sensitive_names',
    'matching_order',
    'matching_data_types'
] %}

{% for test in column_metadata_tests %}
  {% if test not in allowed_tests %}
      {{ exceptions.raise_compiler_error(
          test ~ " not an allowed column metadata test. Accepted values are: "
          ~ allowed_tests | join(', ')
    ) }}
  {% endif %}
{% endfor %}
{% endmacro %}


{% macro test_equality(
        model,
        compare_model,
        compare_columns=[],
        column_metadata_tests=[]
) %}

{% if compare_columns and 'all_columns_present_in_both_tables' in column_metadata_tests %}
    {{ exceptions.raise_compiler_error(
        "`compare_columns` argument can't be used with the "
        "`all_columns_present_in_both_tables` column metadata test"
    ) }}
{% endif %}

{% if column_metadata_tests %}
    {{ validate_metadata_test_inputs(column_metadata_tests) }}
{% endif %}

{#- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

-- setup
{%- do dbt_utils._is_relation(model, 'test_equality') -%}

{#-
If only the compare_columns arg is provided, we can run this test without querying the
information schema — this allows the model to be an ephemeral model.
-#}
{%- if not compare_columns or column_metadata_tests -%}
    {#- raise an error is this being used as an ephemeral mode -#}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
{%- endif -%}

{% set compare_model = compare_model or kwargs.get('arg') %}
{% set all_columns_present_in_both_tables = 'all_columns_present_in_both_tables' in column_metadata_tests %}
{% set case_sensitive_names = 'case_sensitive_names' in column_metadata_tests %}
{% set matching_order = 'matching_order' in column_metadata_tests %}
{% set matching_data_types = 'matching_data_types' in column_metadata_tests %}


{% if not (compare_columns or all_columns_present_in_both_tables or column_metadata_tests) %}
    {% set cols_a = adapter.get_columns_in_relation(model) %}
    {% set final_columns_csv = cols_a | map(attribute='quoted') | join(', ') %}

{% elif compare_columns and not column_metadata_tests %}
    {% set final_columns_csv = compare_columns | join(', ') %}

{% else %}
    {# get all columns for A and B #}
    {% set cols_a = adapter.get_columns_in_relation(model) %}
    {% set cols_b = adapter.get_columns_in_relation(compare_model) %}

    {# reduce to just needed columns for A and B while also checking case if needed #}
    {% if compare_columns %}
        {% set cols_a = filter_columns(cols_a, compare_columns, case_sensitive_names) %}
        {% set cols_b = filter_columns(cols_b, compare_columns, case_sensitive_names) %}

    {# Confirm all columns are shared while also checking case if needed #}
    {% elif all_columns_present_in_both_tables %}
        {% set cols_a_names = cols_a | map(attribute='name') | list %}
        {% set cols_b_names = cols_b | map(attribute='name') | list %}

        {# are A cols in B #}
        {% do filter_columns(cols_b, cols_a_names, case_sensitive_names) %}

        {# are B cols in A #}
        {% do filter_columns(cols_a, cols_b_names, case_sensitive_names) %}

    {# As a minimum check columns of A are in B and check case if needed #}
    {% else %}
        {% set cols_a_names = cols_a | map(attribute='name') | list %}
        {% do filter_columns(cols_b, cols_a_names, case_sensitive_names) %}
    {% endif %}

    {% if matching_data_types %}
        {% do test_matching_data_types(cols_a, cols_b) %}
    {% endif %}

    {% set cols_a_csv = cols_a | map(attribute='quoted') | join(', ') %}
    {% set cols_b_csv = cols_b | map(attribute='quoted') | join(', ') %}

    {% if matching_order %}
        {% do test_matching_order(cols_a_csv, cols_b_csv) %}
    {% endif %}

    {# Use just one of the csvs to be sure columns are selected in same order in both tables #}
    {% set final_columns_csv = cols_a_csv %}

{% endif %}


with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{ final_columns_csv }} from a
    {{ dbt_utils.except() }}
    select {{ final_columns_csv }} from b

),

b_minus_a as (

    select {{ final_columns_csv }} from b
    {{ dbt_utils.except() }}
    select {{ final_columns_csv }} from a

),

unioned as (

    select * from a_minus_b
    union all
    select * from b_minus_a

),

final as (

    select (select count(*) from unioned) +
        (select abs(
            (select count(*) from a_minus_b) -
            (select count(*) from b_minus_a)
            ))
        as count

)

select count from final

{% endmacro %}
