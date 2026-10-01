with data as (

    select * from {{ ref('data_parse_locale_decimal') }}

)

-- round() over a numeric cast neutralizes float representation noise
-- (e.g. 1234.56005859375); the cast is required because postgres has no
-- round(double precision, integer) overload.
select
    round(cast({{ dbt_utils.parse_locale_decimal('input_string') }} as {{ dbt.type_numeric() }}), 3) as actual,
    cast(expected as {{ dbt.type_float() }}) as expected

from data
