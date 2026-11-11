with data as (

    select
        '{"name": "Ann", "plan type": "pro"}' as json_string,
        'Ann' as expected_name,
        'pro' as expected_plan

)

select
    {{ dbt_utils.pivot_json_extract(string='json_string', list_of_properties=['name', {'name': 'plan type', 'alias': 'plan'}]) }},
    expected_name,
    expected_plan

from data
