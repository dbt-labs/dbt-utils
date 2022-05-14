{# Return 0 rows for the test to pass #}
{% if dbt_utils.pretty_log_format() is string %} select 1 as col_name {{ limit_zero() }}
{# Return >0 rows for the test to fail #}
{% else %} select 1
{% endif %}
