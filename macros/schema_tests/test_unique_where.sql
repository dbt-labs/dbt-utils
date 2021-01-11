{% macro test_unique_where(model) %}
  {{ return(adapter.dispatch('test_unique_where', packages = dbt_utils._get_utils_namespaces())(model, **kwargs)) }}
{% endmacro %}

{% macro default__test_unique_where(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set where = kwargs.get('where', kwargs.get('arg')) %}

select count(*)
from (

    select
        {{ column_name }}

    from {{ model }}
    where {{ column_name }} is not null
      {% if where %} and {{ where }} {% endif %}
    group by {{ column_name }}
    having count(*) > 1

) validation_errors

{% endmacro %}
