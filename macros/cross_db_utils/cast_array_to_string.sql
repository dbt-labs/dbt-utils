{% macro cast_array_to_string(array) %}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('cast_array_to_string', model.package_name, model.name) %}
  {{ adapter.dispatch('cast_array_to_string', 'dbt_utils') (array) }}
{% endmacro %}

{% macro default__cast_array_to_string(array) %}
    cast({{ array }} as {{ type_string() }})
{% endmacro %}

{# when casting as array to string, postgres uses {} (ex: {1,2,3}) while other dbs use [] (ex: [1,2,3]) #}
{% macro postgres__cast_array_to_string(array) %}
    {%- set array_as_string -%}cast({{ array }} as {{ type_string() }}){%- endset -%}
    {{ replace(replace(array_as_string,"'}'","']'"),"'{'","'['") }}
{% endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__cast_array_to_string(array) %}
    cast({{ array }} as {{ type_string() }})
{% endmacro %}

{% macro bigquery__cast_array_to_string(array) %}
    '['||(select string_agg(cast(element as string), ',') from unnest({{ array }}) element)||']'
{% endmacro %}
