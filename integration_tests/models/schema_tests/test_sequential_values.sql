{% if target.type == 'postgres' %}
select
    i AS id,
    -- interval = 1
    date '2021-01-01' + make_interval(hours => i) AS one_hour_interval,
    date '2021-01-01' + make_interval(days => i) AS one_day_interval,
    date '2021-01-01' + make_interval(months => i) AS one_month_interval,
    date '2021-01-01' + make_interval(years => i) AS one_year_interval,
    -- interval = 2
    date '2021-01-01' + make_interval(hours => i * 2) AS two_hours_interval,
    date '2021-01-01' + make_interval(days => i * 2) AS two_days_interval,
    date '2021-01-01' + make_interval(months => i * 2) AS two_months_interval,
    date '2021-01-01' + make_interval(years => i * 2) AS two_years_interval,
    case
        when i >= 5 then i
        else 0
    end AS conditional_id
from
    generate_series(1, 10) i
{% endif %}
