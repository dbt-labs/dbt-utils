{# ------ IF WE DON'T CARE ABOUT BACKWARDS COMPATIBILITY AT ALL -------- #}

{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ return(adapter.dispatch('dateadd', 'dbt')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}

{# ------ IF WE CARE ABOUT BACKWARDS COMPATIBILITY A LITTLE -----------

{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {% if dbt_version[0]|int == 1 and dbt_version[2]|int >= 2 %}
    {{ return(adapter.dispatch('dateadd', 'dbt')(datepart, interval, from_date_or_timestamp)) }}
  {% else %}
    {{ return(adapter.dispatch('dateadd', 'dbt_utils')(datepart, interval, from_date_or_timestamp)) }}
  {% endif %}
{% endmacro %}

{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}

    dateadd(
        {{ datepart }},
        {{ interval }},
        {{ from_date_or_timestamp }}
        )

{% endmacro %}


{% macro bigquery__dateadd(datepart, interval, from_date_or_timestamp) %}

        datetime_add(
            cast( {{ from_date_or_timestamp }} as datetime),
        interval {{ interval }} {{ datepart }}
        )

{% endmacro %}

{% macro postgres__dateadd(datepart, interval, from_date_or_timestamp) %}

    {{ from_date_or_timestamp }} + ((interval '1 {{ datepart }}') * ({{ interval }}))

{% endmacro %}

-- redshift should use default instead of postgres
{% macro redshift__dateadd(datepart, interval, from_date_or_timestamp) %}

    {{ return(dbt_utils.default__dateadd(datepart, interval, from_date_or_timestamp)) }}

{% endmacro %}
#}

{# ------ IF WE CARE ABOUT BACKWARDS COMPATIBILITY A LOT ---------

{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ return(adapter.dispatch('dateadd', 'dbt_utils')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}


{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}

  {% if dbt_version[0]|int == 1 and dbt_version[2]|int >= 2 %}
    {{ return(dbt.dateadd(datepart, interval, from_date_or_timestamp)) }}
  {% else %}

    dateadd(
        {{ datepart }},
        {{ interval }},
        {{ from_date_or_timestamp }}
        )

  {% endif %}

{% endmacro %}


{% macro bigquery__dateadd(datepart, interval, from_date_or_timestamp) %}

  {% if dbt_version[0]|int == 1 and dbt_version[2]|int >= 2 %}
    {{ return(dbt.dateadd(datepart, interval, from_date_or_timestamp)) }}
  {% else %}

        datetime_add(
            cast( {{ from_date_or_timestamp }} as datetime),
        interval {{ interval }} {{ datepart }}
        )
  
  {% endif %}
{% endmacro %}

{% macro postgres__dateadd(datepart, interval, from_date_or_timestamp) %}

  {% if dbt_version[0]|int == 1 and dbt_version[2]|int >= 2 %}
    {{ return(dbt.dateadd(datepart, interval, from_date_or_timestamp)) }}
  {% else %}

    {{ from_date_or_timestamp }} + ((interval '1 {{ datepart }}') * ({{ interval }}))

  {% endif %}
{% endmacro %}

-- redshift should use default instead of postgres
{% macro redshift__dateadd(datepart, interval, from_date_or_timestamp) %}

  {% if dbt_version[0]|int == 1 and dbt_version[2]|int >= 2 %}
    {{ return(dbt.dateadd(datepart, interval, from_date_or_timestamp)) }}
  {% else %}

    {{ return(dbt_utils.default__dateadd(datepart, interval, from_date_or_timestamp)) }}

  {% endif %}
{% endmacro %}
#}
