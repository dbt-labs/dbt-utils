
{% if target.type == 'postgres' %}

select
    'a' as col1,
    'b' as col2,
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today

{% else %}

select
    'a' as col1,
    'b' as col2,
    cast({{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as datetime) as today
    
{% endif %}
