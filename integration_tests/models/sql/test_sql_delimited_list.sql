select
*
from {{ref('data_sql_delimited_list')}}
where string_field in {{ dbt_utils.sql_delimited_list(['a', 'b', 'c']) }}
or number_field in {{ dbt_utils.sql_delimited_list([1, 2, 3]) }}
or number_cast_to_string_field in {{ dbt_utils.sql_delimited_list([1, 2, 3], True) }}
