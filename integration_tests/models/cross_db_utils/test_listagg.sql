with data as (

    select * from {{ ref('data_listagg') }}

),

data_output as (

    select * from {{ ref('data_listagg_output') }}

),

calculate as (

    select
        group_col,
        {{ dbt_utils.listagg('string_text', "','", "order by order_col") }} as actual,
        1 as version
    from data
    group by group_col

    union all

    select
        group_col,
        {{ dbt_utils.listagg('string_text', "','", "order by order_col", 2) }} as actual,
        2 as version
    from data
    group by group_col

    union all

    select
        group_col,
        {{ dbt_utils.listagg('string_text', "','") }} as actual,
        3 as version
    from data
    where group_col = 3
    group by group_col

    union all

    select
        group_col,
        {{ dbt_utils.listagg('DISTINCT string_text', "','") }} as actual,
        4 as version
    from data
    where group_col = 3
    group by group_col

    union all

    select
        group_col,
        {{ dbt_utils.listagg('string_text') }} as actual,
        5 as version
    from data
    where group_col = 3
    group by group_col

)

select 
    calculate.actual,
    data_output.expected
from calculate
left join data_output
on calculate.group_col = data_output.group_col
and calculate.version = data_output.version