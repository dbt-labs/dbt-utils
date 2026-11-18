{% set quoted_col = adapter.quote("column_one") %}


select
    {{ dbt.string_literal(quoted_col ~ " as column_one") | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=True, unquote_aliases=True)) | trim | lower }} as actual

union all

select
    {{ dbt.string_literal(quoted_col ~ " as renamed_col") | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=True, unquote_aliases=True, rename={"column_one": "renamed_col"})) | trim | lower }} as actual

union all

select
    {{ dbt.string_literal(quoted_col ~ " as renamed_col") | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=True, rename={"column_one": "renamed_col"})) | trim | lower }} as actual

union all

-- `rename` keys should match column names case-insensitively, the same way `except` does.
-- Warehouses that fold unquoted identifiers (e.g. Snowflake -> COLUMN_ONE) must still
-- match a rename key supplied in a different case.
select
    {{ dbt.string_literal(quoted_col ~ " as renamed_col") | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=True, rename={"COLUMN_ONE": "renamed_col"})) | trim | lower }} as actual
