
{% test assert_equal(model, actual, expected) %}
select * from {{ model }} where {{ actual }} != {{ expected }}

{% endtest %}


{% test not_empty_string(model, arg) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}

select * from {{ model }} where {{ column_name }} = ''

{% endtest %}
