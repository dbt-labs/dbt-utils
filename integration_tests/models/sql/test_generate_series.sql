
with data as (

    {{ dbt_utils.generate_series(10) }}

)

select generated_number from data
