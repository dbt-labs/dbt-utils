with data as (

    select
        {{ dbt_utils.star(
            from=ref('data_star'),
            except=['field_3'],
            case_sensitive_except=False
        ) }}

    from {{ ref('data_star') }}

)

select * from data
