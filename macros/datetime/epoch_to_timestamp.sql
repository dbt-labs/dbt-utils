{% macro epoch_to_timestamp(column_name, time_unit='seconds') %}
    {{ dbt_utils.dateadd(
        time_unit,
        column_name,
        "'1970-01-01'::timestamp"
    ) }}
{% endmacro %}
