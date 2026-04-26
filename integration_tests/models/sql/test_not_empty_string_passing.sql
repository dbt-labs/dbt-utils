-- dbt seed casts '' as NULL, so we need to select empty strings to enable testing

with blank_data as (

    select
        1 as id,
        'not an empty string' as string_trim_whitespace_true,
        'not an empty string' as string_trim_whitespace_false

    union all

    select
        2 as id,
        'also not an empty string' as string_trim_whitespace_true,
        'also not an empty string' as string_trim_whitespace_false

    union all

    select
        3 as id,
        'string with trailing whitespace  ' as string_trim_whitespace_true,
        '   ' as string_trim_whitespace_false  -- This will cause a failure when trim_whitespace = true

    union all

    select
        6 as id,
        null as string_trim_whitespace_true,
        null as string_trim_whitespace_false

)

select * from blank_data