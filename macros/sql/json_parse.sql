{% macro json_parse(string, string_path) -%}

{{ adapter.dispatch('json_parse', 'dbt_utils') (string, string_path) }}

{%- endmacro %}

{% macro default__json_parse(string, string_path) %}

  json_extract_path_text({{string}}, {%- for s in string_path -%}'{{ s }}'{%- if not loop.last -%},{%- endif -%}{%- endfor -%} )

{% endmacro %}

{% macro redshift__json_parse(string, string_path) %}

  case when is_valid_json( {{string}} ) then json_extract_path_text({{string}}, {%- for s in string_path -%}'{{ s }}'{%- if not loop.last -%},{%- endif -%}{%- endfor -%} ) else null end

{% endmacro %}

{% macro bigquery__json_parse(string, string_path) %}

 
  json_extract_scalar({{string}}, '$.{%- for s in string_path -%}{{ s }}{%- if not loop.last -%}.{%- endif -%}{%- endfor -%} ')

{% endmacro %}

{% macro postgres__json_parse(string, string_path) %}

  {{string}}::json #>> '{ {%- for s in string_path -%}{{ s }}{%- if not loop.last -%},{%- endif -%}{%- endfor -%} }'

{% endmacro %}

{% macro snowflake__json_parse(string, string_path) %}

  try_parse_json( {{string}} ) {%- for s in string_path -%}{% if s is number %}[{{ s }}]{% else %}['{{ s }}']{% endif %}{%- endfor -%}

{% endmacro %}

{% macro spark__json_parse(string, string_path) %}

  {{string}} : {%- for s in string_path -%}{% if s is number %}[{{ s }}]{% else %}['{{ s }}']{% endif %}{%- endfor -%}

{% endmacro %}

{% macro sqlserver__json_parse(string, string_path) %}

  json_value({{string}}, '$.{%- for s in string_path -%}{{ s }}{%- if not loop.last -%}.{%- endif -%}{%- endfor -%} ')

{% endmacro %}

{% macro duckdb__json_parse(string, string_path) %}

  json_extract_string({{string}}, '${%- for s in string_path -%}{% if s is number %}[{{ s }}]{% else %}.{{ s }}{% endif %}{%- endfor -%}')
  
{% endmacro %}