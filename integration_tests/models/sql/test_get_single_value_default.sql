{# 
    Dear future reader, 
    Before you go restructuring the delicate web of casts and quotes below, a warning:
    I once thought as you are thinking. Proceed with caution.
#}

{% set false_statement = 'select 1 as id ' ~ limit_zero() %}

with default_data as (

    select
        cast({{ dbt.string_literal('2022-01-01') }} as {{ dbt.type_timestamp() }}) as date_expected,
        cast({{ dbt.string_literal(dbt_utils.get_single_value(false_statement, '2022-01-01')) }} as {{ dbt.type_timestamp() }}) as date_actual,

        1.23456 as float_expected,
        {{ dbt_utils.get_single_value(false_statement, 1.23456) }} as float_actual,

        123456 as int_expected,
        {{ dbt_utils.get_single_value(false_statement, 123456) }} as int_actual,

        cast({{ dbt.string_literal('fallback') }} as {{ dbt.type_string() }}) as string_expected,    
        cast({{ dbt.string_literal(dbt_utils.get_single_value(false_statement, 'fallback')) }} as {{ dbt.type_string() }}) as string_actual

    from {{ ref('data_get_single_value') }}
)

select * 
from default_data