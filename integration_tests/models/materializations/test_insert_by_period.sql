{{
    config(
        materialized="insert_by_period",
        period="month",
        timestamp_field="created_at",
        start_date="2018-01-01",
        stop_date="2018-06-01",
        enabled=(target.type == "redshift"),
    )
}}

with
    events as (select * from {{ ref("data_insert_by_period") }} where __period_filter__)

select *
from events
