{{ dbt_utils.unpivot(table=ref('data_unpivot'), cast_to='varchar', exclude=['customer_id','created_at']) }}
