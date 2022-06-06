{# This is here for backwards compatibility only #}

{% macro split_part(string_text, delimiter_text, part_number) %}
  {{ return(adapter.dispatch('split_part', 'dbt_utils') (string_text, delimiter_text, part_number)) }}
{% endmacro %}

{% macro default__split_part(string_text, delimiter_text, part_number) %}
  {{ return(adapter.dispatch('split_part', 'dbt') (string_text, delimiter_text, part_number)) }}
{% endmacro %}
