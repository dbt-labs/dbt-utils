
-- TODO : Should the star macro use a case-insensitive comparison for the `except` field on Snowflake?

{% set aliases = {'FIELD_3':'ALIASED'} if target.type == 'snowflake' else {'field_3':'aliased'} %}


with data as (

    select
        {{ dbt_utils.star(from=ref('data_star'), aliases=aliases) }}

    from {{ ref('data_star') }}

)

select * from data
