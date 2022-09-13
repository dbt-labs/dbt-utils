-- dbt seed casts '' as NULL, so we need to select empty strings to enable testing

with blank_data as (

    select
        1 as id,
        'not an empty string' as string_trim_whitespace_true

    union all

    select
        2 as id,
        'also not an empty string' as string_trim_whitespace_true

    union all

    select
        3 as id,
        'string with trailing whitespace  ' as string_trim_whitespace_true

    union all

    select
        4 as id,
        '   ' as string_trim_whitespace_true

    union all

    select
        5 as id,
        '' as string_trim_whitespace_true

    union all

    select
        6 as id,
        null as string_trim_whitespace_true

)

select * from blank_data