{% macro split_part(string_text, delimiter_text, part_number) %}
  {{ return(adapter.dispatch('split_part', 'dbt') (string_text, delimiter_text, part_number)) }}
{% endmacro %}
