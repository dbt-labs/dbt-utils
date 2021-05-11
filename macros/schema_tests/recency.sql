{% test recency(model, datepart, interval) %}
  {{ return(adapter.dispatch('test_recency', packages = dbt_utils._get_utils_namespaces())(model, datepart, interval, **kwargs)) }}
{% endtest %}

{% macro default__test_recency(model, datepart, interval) %}

{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}

with recency as (

    select max({{column_name}}) as most_recent
    from {{model}}

)

select

    most_recent,
    {{ threshold }} as threshold

from recency
where most_recent < {{ threshold }}

{% endmacro %}
