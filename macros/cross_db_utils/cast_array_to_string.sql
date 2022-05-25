{% macro cast_array_to_string(field) %}
  {{ adapter.dispatch('cast_array_to_string', 'dbt_utils') (field) }}
{% endmacro %}

{% macro default__cast_array_to_string(field) %}
    cast({{ field }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{# when casting as array to string, postgres uses {} (ex: {1,2,3}) while other dbs use [] (ex: [1,2,3]) #}
{% macro postgres__cast_array_to_string(field) %}
    {%- set field_as_string -%}cast({{ field }} as {{ dbt_utils.type_string() }}){%- endset -%}
    {{ dbt_utils.replace(dbt_utils.replace(field_as_string,"'}'","']'"),"'{'","'['") }}
{% endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__cast_array_to_string(field) %}
    cast({{ field }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{% macro bigquery__cast_array_to_string(field) %}
    '['||(select string_agg(cast(element as string), ',') from unnest({{ field }}) element)||']'
{% endmacro %}
