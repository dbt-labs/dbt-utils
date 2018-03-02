
{% macro test_assert_equal(model, actual, expected) %}

select count(*) from {{ model }} where {{ actual }} != {{ expected }}

{% endmacro %}


{% macro test_not_empty_string(model, arg) %}

select count(*) from {{ model }} where {{ arg }} = ''

{% endmacro %}
