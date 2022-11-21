select
    {{ dbt.string_literal(adapter.quote("column_one")) | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=True)) | trim | lower }} as actual

union all

select
    {{ dbt.string_literal("column_one") | lower }} as expected,
    {{ dbt.string_literal(dbt_utils.star(from=ref('data_star_quote_identifiers'), quote_identifiers=False)) | trim | lower }} as actual