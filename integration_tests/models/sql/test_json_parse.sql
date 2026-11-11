with data as (

    select
        '{"name": "Ann", "address": {"city": "Oakland"}}' as json_string,
        'Ann' as expected_name,
        'Oakland' as expected_city

)

select
    cast({{ dbt_utils.json_parse('json_string', ['name']) }} as {{ dbt.type_string() }}) as actual_name,
    expected_name,
    cast({{ dbt_utils.json_parse('json_string', ['address', 'city']) }} as {{ dbt.type_string() }}) as actual_city,
    expected_city

from data
