WITH deduped as (

    {{ dbt_utils.dedupe(ref('data_dedupe'), group_by='user_id', order_by='version desc') | indent }}

)

select * from deduped
