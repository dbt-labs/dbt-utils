{{ config(materialized = 'table') }}


{% if target.type == 'snowflake' %}

    {% set relations = dbt_utils.get_relations_by_prefix((target.schema | upper), 'data_events_') %}
    {{ dbt_utils.union_relations(relations) }}

{% else %}

    {% set relations = dbt_utils.get_relations_by_prefix(target.schema, 'data_events_') %}
    {{ dbt_utils.union_relations(relations) }}

{% endif %}
