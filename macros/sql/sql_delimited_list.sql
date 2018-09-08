{% macro sql_delimited_list(list, override_to_string=False) -%}
(
{%- for item in list -%}
{%- if item is string or override_to_string -%}
'{{item}}'
{%- else -%}
{{item}}
{%- endif -%}
{%- if not loop.last -%}
, {% endif -%}
{%- endfor -%}
)
{%- endmacro %}
