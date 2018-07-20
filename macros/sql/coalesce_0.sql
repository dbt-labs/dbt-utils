{% macro coalesce_0(field, alias=None) -%}
{%- if not alias -%}
  {% if field.find('.') == -1 -%}
      {%- set alias = field -%}
  {%- else -%}
      {%- set alias = (field | string).split(".")[1] -%}
  {%- endif -%}
{%- endif -%}
coalesce({{field}}, 0) as {{alias}}
{%- endmacro %}
