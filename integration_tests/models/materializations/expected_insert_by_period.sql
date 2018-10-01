{{
	config(
		materialized = 'view')
}}

select *
from {{ ref('data_insert_by_period') }}
where id in (2, 3, 4, 5, 6)
