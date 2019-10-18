{% macro test_numeric_constraints(model, condition='true') %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set eq = kwargs.get('eq', kwargs.get('arg')) %}
{% set ne = kwargs.get('ne', kwargs.get('arg')) %}
{% set gt = kwargs.get('gt', kwargs.get('arg')) %}
{% set gte = kwargs.get('gte', kwargs.get('arg')) %}
{% set lt = kwargs.get('lt', kwargs.get('arg')) %}
{% set lte = kwargs.get('lte', kwargs.get('arg')) %}


with meet_condition as (

    select * from {{ model }} where {{ condition }}

),
validation_errors as (

    select
        *
    from meet_condition
    where not (true
      {% if eq is not none %} and {{column_name}} = {{ eq or 0 }} {% endif %}
      {% if ne is not none %} and {{column_name}} <> {{ ne or 0 }} {% endif %}
      {% if gt is not none %} and {{column_name}} > {{ gt or 0 }} {% endif %}
      {% if gte is not none %} and {{column_name}} >= {{ gte or 0 }} {% endif %}
      {% if lt is not none %} and {{column_name}} < {{ lt or 0 }} {% endif %}
      {% if lte is not none %} and {{column_name}} <= {{ lte or 0 }} {% endif %}
    )

)

select count(*)
from validation_errors

{% endmacro %}
