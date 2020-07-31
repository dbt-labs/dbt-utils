{% macro test_no_time_gap(model, datepart, interval) %}

{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}
{% set since = kwargs.get('since', kwargs.get('since')) %}

select
    count(*) as error_result
from {{model}} t1
inner join {{model}} t2 on
    t2.{{column_name}} = (
        select
            MAX(t3.{{column_name}})
        from {{model}} t3
        where
            t3.{{column_name}} < t1.{{column_name}}
        {% if since %}
        and t3.{{column_name}} >=
            {{dbt_utils.dateadd('year', -1, dbt_utils.current_timestamp())}}
        {% endif %}
    )
where
    {{dbt_utils.datediff('t2.' + column_name, 't1.' + column_name, datepart)}}
    >= {{interval}}
{% if since %}
and t1.{{column_name}} >=
    {{dbt_utils.dateadd('year', -1, dbt_utils.current_timestamp())}}
{% endif %}

{% endmacro %}
