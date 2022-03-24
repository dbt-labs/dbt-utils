{%- set singles = 'some string, plus, other stuff' -%}
{%- set doubles = "some string, plus, other stuff" -%}
{%- set double_doubles = "'some string, plus, other stuff'" -%}

{% set actual_output %}

    select
    {{ dbt_utils.split_part(string_text=singles, delimiter_text=',', part_number=1, quote_string_text=False, quote_delimiter_text=False) }} as bad_col1,
    {{ dbt_utils.split_part(string_text=doubles, delimiter_text=",", part_number=1, quote_string_text=False, quote_delimiter_text=False) }} as bad_col2,
    {{ dbt_utils.split_part(string_text=double_doubles, delimiter_text="','", part_number=1, quote_string_text=False, quote_delimiter_text=False) }} as good_col3
    {{ dbt_utils.split_part(string_text=singles, delimiter_text=',', part_number=1, quote_string_text=True, quote_delimiter_text=True) }} as good_col1,
    {{ dbt_utils.split_part(string_text=doubles, delimiter_text=",", part_number=1, quote_string_text=True, quote_delimiter_text=True) }} as good_col2,
    {{ dbt_utils.split_part(string_text=double_doubles, delimiter_text="','", part_number=1, quote_string_text=True, quote_delimiter_text=True) }} as bad_col3

{% endset %}

{% set expected_output %}

    select
    split_part(
        some string, plus, other stuff,
        ,,
        1
        ) as bad_col1,
    split_part(
        some string, plus, other stuff,
        ,,
        1
        ) as bad_col2,
    split_part(
        'some string, plus, other stuff',
        ',',
        1
        ) as good_col3
    split_part(
        'some string, plus, other stuff',
        ',',
        1
        ) as good_col1,
    split_part(
        'some string, plus, other stuff',
        ',',
        1
        ) as good_col2,
    split_part(
        ''some string, plus, other stuff'',
        '','',
        1
        ) as bad_col3

{% endset %}

{{ assert_equal_values (actual_output | trim, expected_output | trim) }}
