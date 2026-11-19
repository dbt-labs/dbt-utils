{#-- Intentionally returns zero rows --#}
select
    field
from {{ ref('data_test_equal_rowcount') }}
where 1 = 0
