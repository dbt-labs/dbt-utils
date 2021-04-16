{% if dbt_utils.slugify('!Hell0 world-hi') == 'hell0_world_hi' %}
    {# Return 0 rows for the test to pass #}
    select 1 limit 0
{% else %}
    {# Return >0 rows for the test to fail #}
    select 1
{% endif %}
