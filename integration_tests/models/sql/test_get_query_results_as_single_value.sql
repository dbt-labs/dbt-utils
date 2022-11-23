{% set date_statement %}
    select date_value from {{ ref('data_get_query_results_as_single_value') }}
{% endset %}

{% set float_statement %}
    select float_value from {{ ref('data_get_query_results_as_single_value') }}
{% endset %}

{% set int_statement %}
    select int_value from {{ ref('data_get_query_results_as_single_value') }}
{% endset %}

{% set string_statement %}
    select string_value from {{ ref('data_get_query_results_as_single_value') }}
{% endset %}

with default_data as (

    select
        date_value as date_expected, 
        {{ dbt.safe_cast(dbt.string_literal(dbt_utils.get_query_results_as_single_value(date_statement)), dbt.type_timestamp()) }} as date_actual,

        float_value as float_expected,
        {{ dbt_utils.get_query_results_as_single_value(float_statement) }} as float_actual,

        int_value as int_expected,
        {{ dbt_utils.get_query_results_as_single_value(int_statement) }} as int_actual,

        string_value as string_expected,    
        {{ dbt.string_literal(dbt_utils.get_query_results_as_single_value(string_statement)) }} as string_actual

    from {{ ref('data_get_query_results_as_single_value') }}
)

select * 
from default_data