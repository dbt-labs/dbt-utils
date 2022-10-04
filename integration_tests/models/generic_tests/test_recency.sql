
{% if target.type == 'postgres' %}

select
    1 as col1,
    2 as col2,
    {{ date_trunc('day', current_timestamp()) }} as today

{% else %}

select
    1 as col1,
    2 as col2,
    cast({{ date_trunc('day', current_timestamp()) }} as datetime) as today
    
{% endif %}