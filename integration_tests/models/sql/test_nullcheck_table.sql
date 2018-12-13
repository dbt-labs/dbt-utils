{{ config( materialized = "table" ) }}
 
{% set tbl = ref('data_nullcheck_table') %}

{% if target.type == 'bigquery' %}

with nulled as (

    {{ dbt_utils.nullcheck_table(tbl.schema, tbl.name) }}

)

select

    {{ dbt_utils.safe_cast('field_1',
        dbt_utils.type_string()
    )}} as field_1,

    {{ dbt_utils.safe_cast('field_2',
        dbt_utils.type_string()
    )}} as field_2,

    {{ dbt_utils.safe_cast('field_3',
        dbt_utils.type_string()
    )}} as field_3

from nulled

{% else %}

with nulled as (
    
    {{ dbt_utils.nullcheck_table(tbl.schema, tbl.name) }}
    
)

select 

    field_1::varchar as field_1,
    field_2::varchar as field_2,
    field_3::varchar as field_3
    
from nulled

{% endif %}
