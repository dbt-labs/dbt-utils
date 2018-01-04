{% macro test_cardinality(model, arg) %}

select {{ arg.field }}
from {{ model }}

{% endmacro %}
