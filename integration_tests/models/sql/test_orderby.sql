  WITH test_data AS (
SELECT {{ dbt_utils.safe_cast("'a'", dbt_utils.type_string() )}} AS column
 UNION ALL    
SELECT {{ dbt_utils.safe_cast("'b'", dbt_utils.type_string() )}} AS column
       )

SELECT *
  FROM test_data
       {{ dbt_utils.order_by(1) }}
 LIMIT 1