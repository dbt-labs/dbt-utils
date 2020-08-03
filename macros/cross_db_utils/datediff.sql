{% macro datediff(first_date, second_date, datepart) %}
  {{ adapter.dispatch('datediff', packages = dbt_utils._get_utils_namespaces())(first_date, second_date, datepart) }}
{% endmacro %}


{% macro default__datediff(first_date, second_date, datepart) %}

    datediff(
        {{ datepart }},
        {{ first_date }},
        {{ second_date }}
        )

{% endmacro %}


{% macro bigquery__datediff(first_date, second_date, datepart) %}

    datetime_diff(
        cast({{second_date}} as datetime),
        cast({{first_date}} as datetime),
        {{datepart}}
    )

{% endmacro %}

