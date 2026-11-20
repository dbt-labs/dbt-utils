{# Each CTE keeps only id = 1. If the union reads from the CTEs instead of the full
   tables, every output row has id = 1. #}
with table_1_filtered as (

    select * from {{ ref('data_union_table_1') }}
    where id = 1

),

table_2_filtered as (

    select * from {{ ref('data_union_table_2') }}
    where id = 1

),

unioned as (

    {{ dbt_utils.union_relations(
        relations=[ref('data_union_table_1'), ref('data_union_table_2')],
        aliases=['table_1_filtered', 'table_2_filtered']
    ) }}

)

select
    id,
    favorite_number
from unioned
