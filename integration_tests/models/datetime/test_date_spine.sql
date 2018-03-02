
with date_spine as (

    {% if target.type == 'postgres' %}
        {{ log("WARNING: Not testing - datediff macro is unsupported on Postgres", info=True) }}
        select * from {{ ref('data_date_spine') }}
    {% else %}
        {{ dbt_utils.date_spine("day", "'2018-01-01'", "'2018-01-10'") }}
    {% endif %}

)

select date_day
from date_spine

