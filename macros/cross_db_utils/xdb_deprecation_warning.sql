{% macro xdb_deprecation_warning(macro, package, model) %}
    {%- set error_message = "Warning: the `" ~ macro ~"` macro is no longer available in dbt_utils and backwards compatibility will be removed in a future version. Use `dbt." ~ macro ~ "` instead. The " ~ package ~ "." ~ model ~ " model triggered this warning." -%}
    {%- do exceptions.warn(error_message) -%}
{% endmacro %}