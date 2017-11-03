{% macro lower_alpha(arg) -%}

  regexp_replace(lower({{arg}}),'[^[:alpha:]]', '')
  
 {%- endmacro%}
