
{% set tbl = ref('data_nullcheck_table') %}

with nulled as (

    {{ dbt_utils.nullcheck_table(tbl.schema, tbl.name) }}

)

select
    field_1::varchar as field_1,
    field_2::varchar as field_2,
    field_3::varchar as field_3

from nulled
