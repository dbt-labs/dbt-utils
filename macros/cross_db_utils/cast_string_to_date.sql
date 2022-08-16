{% macro cast_string_to_date(field, format) %}
  {{ adapter.dispatch('cast_string_to_date', 'dbt_utils') (field, format) }}
{% endmacro %}

{% macro default__cast_string_to_date(field, format) %}
    cast({{ field }} as date)
{% endmacro %}


{#-/* TODO: Reference Only - Delete from Project (provided as 'why' to add this macro) */#}
{% macro oracle__cast_string_to_date(field, format) %}
  {%- if format -%}
    to_date({{field}}, '{{format}}')
  {%- else -%}
    to_date({{field}}, 'YYYY-MM-DD')
  {%- endif -%}
{% endmacro %}
