{% macro current_timestamp() %}
  {{ adapter_macro('current_timestamp') }}
{% endmacro %}

{% macro default__current_timestamp() %}
    current_timestamp()
{% endmacro %}

{% macro redshift__current_timestamp() %}
    current_timestamp::timestamp
{% endmacro %}
