

select
    size,
    {{ dbt_utils.pivot('color', ['red', 'blue']) }}

from {{ ref('data_pivot') }}
group by size
