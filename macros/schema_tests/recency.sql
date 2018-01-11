{% macro test_recency(model, field, datepart, interval) %}

select
    case when count(*) > 0 then 0
    else 1
    end as error_result
from {{model}}
where {{field}} >=
    {{dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp())}}

{% endmacro %}
