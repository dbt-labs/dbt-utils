{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ adapter_macro('dbt_utils.dateadd', datepart, interval, from_date_or_timestamp) }}
{% endmacro %}


{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}

{% set expression -%}
    dateadd(
        {{ datepart }},
        {{ interval }},
        {{ from_date_or_timestamp }}
    )
{%- endset %}

{{ return(expression) }}

{% endmacro %}


{% macro bigquery__dateadd(datepart, interval, from_date_or_timestamp) %}
{% set expression -%}
    datetime_add(
        cast( {{ from_date_or_timestamp }} as datetime),
        interval {{ interval }} {{ datepart }}
    )
{%- endset %}

{{ return(expression) }}

{% endmacro %}


{% macro postgres__dateadd(datepart, interval, from_date_or_timestamp) %}

{% set expression -%}

    {{ from_date_or_timestamp }} + ((interval '1 {{ datepart }}') * ({{ interval }}))

{%- endset %}

{{ return(expression) }}

{% endmacro %}
