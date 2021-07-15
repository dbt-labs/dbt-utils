{{
	config(
		materialized = 'insert_by_period',
		period = 'week',
        lookback_interval = '2 days',
		timestamp_field = 'created_at',
		start_date = '2020-01-01',
		stop_date = '2020-02-01',
		enabled=(target.type == 'redshift')
	)
}}

with pageviews as (

    select *

    from {{ref('data_pageviews')}}
    where anonymous_id in (

        select distinct anonymous_id

        from {{ref('data_pageviews')}}
        where __PERIOD_FILTER_WITH_LOOKBACK__

    )

),

numbered as (
    --This CTE is responsible for assigning an all-time page view number for a
    --given anonymous_id. We don't need to do this across devices because the
    --whole point of this field is for sessionization, and sessions can't span
    --multiple devices.

    select
        *,

        row_number() over (
            partition by anonymous_id
            order by tstamp
            ) as page_view_number

    from pageviews

),

lagged as (

    --This CTE is responsible for simply grabbing the last value of `tstamp`.
    --We'll use this downstream to do timestamp math--it's how we determine the
    --period of inactivity.

    select
        *,

        lag(tstamp) over (
            partition by anonymous_id
            order by page_view_number
            ) as previous_tstamp

    from numbered

),

diffed as (

    --This CTE simply calculates `period_of_inactivity`.

    select
        *,
        {{ dbt_utils.datediff('previous_tstamp', 'tstamp', 'second') }} as period_of_inactivity

    from lagged

),

new_sessions as (

    --This CTE calculates a single 1/0 field--if the period of inactivity prior
    --to this page view was greater than 30 minutes, the value is 1, otherwise
    --it's 0. We'll use this to calculate the user's session #.

    select
        *,

        case
            when period_of_inactivity <= {{var('segment_inactivity_cutoff')}} then 0  -- Cutoff is set to 1 day (86,400s) in dbt_project.yml
            else 1
        end as new_session

    from diffed

),

session_numbers as (

    --This CTE calculates a user's session (1, 2, 3) number from `new_session`.
    --This single field is the entire point of the entire prior series of
    --calculations.

    select
        *,

        sum(new_session) over (
            partition by anonymous_id
            order by page_view_number
            rows between unbounded preceding and current row
            ) as session_number

    from new_sessions

),

session_ids as (

    --This CTE assigns a globally unique session id based on the combination of
    --`anonymous_id` and `session_number`.

    select
        *,
        anonymous_id || '--' || session_number as session_id

        {# Replaced below with above to simplify test #}

        {# {{dbt_utils.star(ref('data_insert_by_period_with_lookback'))}},
        page_view_number,
        {{dbt_utils.surrogate_key(['anonymous_id', 'session_number'])}} as session_id #}

    from session_numbers

),

select *
from session_ids
where __PERIOD_FILTER__
