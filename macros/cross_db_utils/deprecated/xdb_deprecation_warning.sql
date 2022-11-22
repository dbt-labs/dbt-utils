{% macro xdb_deprecation_warning(macro, package, model) %}
    {% if execute %}
        {%- set error_message = "Warning: the `" ~ macro ~"` macro is now provided in dbt Core. It is no longer available in dbt_utils and backwards compatibility will be removed in a future version of the package. Use `" ~ macro ~ "` (no prefix) instead. The " ~ package ~ "." ~ model ~ " model triggered this warning." -%}
        {%- do exceptions.warn(error_message) -%}
    {% endif %}
{% endmacro %}

{% macro xdb_deprecation_warning_without_replacement(macro, package, model) %}
    {% if execute %}
        {%- set error_message = "Warning: the `" ~ macro ~"` macro is deprecated and will be removed in a future version of the package, once equivalent functionality is implemented in dbt Core. The " ~ package ~ "." ~ model ~ " model triggered this warning." -%}
        {%- do exceptions.warn(error_message) -%}
    {% endif %}
{% endmacro %}