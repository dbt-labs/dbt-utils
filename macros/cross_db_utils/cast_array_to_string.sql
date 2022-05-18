{% macro cast_array_to_string(field) %}
  {{ adapter.dispatch('cast_array_to_string', 'dbt_utils') (field) }}
{% endmacro %}

{% macro default__cast_array_to_string(field) %}
    cast({{ field }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{% macro postgres__cast_array_to_string(field) %}
    cast({{ dbt_utils.replace(dbt_utils.replace(field,"'}'","']'"),"'{'","'['") }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__cast_array_to_string(field) %}
    cast({{ field }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{% macro bigquery__cast_array_to_string(field) %}
    '['||(select string_agg(cast(element as string), ',') from unnest({{ field }}) element)||']'
{% endmacro %}
