
{% if target.type == 'postgres' %}

select
    1 as col1,
    2 as col2,
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today

{% else %}

select
    1 as col1,
    2 as col2,
    cast({{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as datetime) as today
    
{% endif %}
