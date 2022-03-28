with data as (

    select * from {{ ref('data_listagg') }}

),

output as (

    select * from {{ ref('data_listagg_output') }}

)

aggregate as (

    select
        group,
        {{ dbt_utils.listagg('string_text', "','", 'order by order_col') }} as actual
    from data
    group by 1

)

select 
    aggregate.actual
    output.output
from aggregate
left join output
on aggregate.group = output.group