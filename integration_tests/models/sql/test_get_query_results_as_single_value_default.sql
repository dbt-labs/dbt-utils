{% set false_statement = 'select 1 as id where 1=0' %}

with default_data as (

    select
        {{ dbt.safe_cast(dbt.string_literal('2022-01-01'), dbt.type_timestamp()) }} as date_expected,
        {{ dbt.safe_cast(dbt.string_literal(dbt_utils.get_query_results_as_single_value(false_statement, '2022-01-01')), dbt.type_timestamp()) }} as date_actual,

        1.23456 as float_expected,
        {{ dbt_utils.get_query_results_as_single_value(false_statement, 1.23456) }} as float_actual,

        123456 as int_expected,
        {{ dbt_utils.get_query_results_as_single_value(false_statement, 123456) }} as int_actual,

        {{ dbt.string_literal('fallback') }} as string_expected,    
        {{ dbt.string_literal(dbt_utils.get_query_results_as_single_value(false_statement, 'fallback')) }} as string_actual

    from {{ ref('data_get_query_results_as_single_value') }}
)

select * 
from default_data