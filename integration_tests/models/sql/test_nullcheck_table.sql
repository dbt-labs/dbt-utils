{{ config( materialized = "table" ) }}
 
-- TO DO: remove if-statement
 
{% set tbl = ref('data_nullcheck_table') %}


with nulled as (

    {{ dbt_utils.nullcheck_table(tbl) }}

)

{% if target.type == 'snowflake' %}

select
    field_1::varchar as field_1,
    field_2::varchar as field_2,
    field_3::varchar as field_3

from nulled

{% else %}

select

    {{ safe_cast('field_1',
        type_string()
    )}} as field_1,

    {{ safe_cast('field_2',
        type_string()
    )}} as field_2,

    {{ safe_cast('field_3',
        type_string()
    )}} as field_3

from nulled

{% endif %}
