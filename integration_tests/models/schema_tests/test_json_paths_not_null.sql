{{
    config(
        enabled=(target.type == 'snowflake')
    )
}}

with source as (
    select * from {{ ref('data_test_json_paths_not_null') }}
), sanitized as (
select
    id,
    parse_json(CONCAT('{\'settings\': {\'emailAddress\':\'',
            email_address,
            '\', \'displayName\':\'',
            display_name,
            '\'}}')) as json_field
    from
source
)
select * from sanitized