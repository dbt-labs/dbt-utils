{{ dbt_utils.unpivot(
    table=ref('data_unpivot'), 
    cast_to=dbt_utils.type_string(), 
    exclude=['customer_id','created_at']

) }}
