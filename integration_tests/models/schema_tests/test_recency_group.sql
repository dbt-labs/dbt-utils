
{% if target.type == 'postgres' %}

select
    'a' as var1,
    'c' as var2,
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today

union 

select
    'b' as var1,
    'c' as var2,
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today

{% else %}

select
    'a' as var1,
    'c' as var2,
    cast({{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as datetime) as today

union

select
    'b' as var1,
    'c' as var2,
    cast({{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as datetime) as today
    
{% endif %}
