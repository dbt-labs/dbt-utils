{% if dbt_utils.slugify("!Hell0 world-hi") == "hell0_world_hi" %}
{# Return 0 rows for the test to pass #}
select 1 as col_name {{ limit_zero() }}
{# Return >0 rows for the test to fail #}
{% else %} select 1 as col_name
{% endif %}
