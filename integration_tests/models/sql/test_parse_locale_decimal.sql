with data as (

    select * from {{ ref('data_parse_locale_decimal') }}

)

-- round() neutralizes float representation noise (e.g. 1234.56005859375)
select
    round({{ dbt_utils.parse_locale_decimal('input_string') }}, 3) as actual,
    cast(expected as {{ dbt.type_float() }}) as expected

from data
