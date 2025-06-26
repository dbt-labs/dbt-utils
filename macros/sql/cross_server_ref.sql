{% macro cross_server_ref(
    source_name=none,
    table_name=none,
    target_flag=false,
    target_schema=none
) %}
  {% if target_flag %}
    {# TARGET REFERENCE #}
    {% set final_schema = target_schema if target_schema else target.schema %}
    {{ adapter.quote(target.database) }}.{{ adapter.quote(final_schema) }}.{{ adapter.quote(table_name) }}
  
  {% elif source_name and table_name %}
    {# SOURCE REFERENCE - CASE-INSENSITIVE #}
    {% set source_name_lower = source_name | lower %}
    {% set linked_server = var('linked_servers', {})[source_name_lower] %}
    
    {% if not linked_server %}
      {{ exceptions.raise_compiler_error(
        "Missing linked_server for source: " ~ source_name ~ ". " ~
        "Define in dbt_project.yml vars: linked_servers"
      ) }}
    {% endif %}
    
    {% set database = var('source_databases', {}).get(source_name_lower, 'DACO_STANDARDIZED') %}
    {% set schema = var('source_schemas', {}).get(source_name_lower, 'daco_bmat') %}
    
    {{ adapter.quote(linked_server) }}.
    {{ adapter.quote(database) }}.
    {{ adapter.quote(schema) }}.
    {{ adapter.quote(table_name) }}
  
  {% else %}
    {{ exceptions.raise_compiler_error(
      "Invalid cross_server_ref parameters. Use either:\n" ~
      "1. cross_server_ref('source_name', 'table_name') for sources\n" ~
      "2. cross_server_ref('table_name', target_flag=true) for targets"
    ) }}
  {% endif %}
{% endmacro %}
