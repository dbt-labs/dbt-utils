
with data as (

    select * from {{ ref('data_safe_divide') }}

)

select
    {{ dbt_utils.safe_divide('numerator', 'denominator') }} as actual,
    output as expected

from data