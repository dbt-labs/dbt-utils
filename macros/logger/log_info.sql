{% macro log_info(message) %}

    {{ log(cc_dbt_utils.pretty_log_format(message), info=True) }}

{% endmacro %}
