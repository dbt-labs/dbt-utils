with data as (
    select * from {{ ref('data_haversine_km') }}
),
final as (
    select
        output as expected,
        cast(
            {{
                dbt_utils.haversine_distance(
                    lat1='lat_1',
                    lon1='lon_1',
                    lat2='lat_2',
                    lon2='lon_2',
                    unit='km'
                    )
            }} as {{ type_numeric() }}
        ) as actual
    from data
)
select
    expected,
    round(actual,0) as actual
from final
