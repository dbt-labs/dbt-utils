
{% macro test_not_constant(model) %}
  {{ return(adapter.dispatch('test_not_constant', packages = dbt_utils._get_utils_namespaces())(model, **kwargs)) }}
{% endmacro %}

{% macro default__test_not_constant(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}

select count(*)

from (

    select
          {# In TSQL, subquery aggregate columns need aliases #}
          {# thus: a filler col name, 'filler_column' #}
          count(distinct {{ column_name }}) as filler_column

    from {{ model }}

    having count(distinct {{ column_name }}) = 1

    ) validation_errors


{% endmacro %}
