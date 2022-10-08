{#
Pivot values from columns to rows. Similar to pandas DataFrame melt() function.

Example Usage: {{ unpivot(relation=ref('users'), cast_to='integer', exclude=['id','created_at']) }}

Arguments:
    relation: Relation object, required.
    cast_to: The datatype to cast all unpivoted columns to. Default is varchar.
    exclude: A list of columns to keep but exclude from the unpivot operation. Default is none.
    remove: A list of columns to remove from the resulting table. Default is none.
    field_name: Destination table column name for the source table column names.
    value_name: Destination table column name for the pivoted values
    quote_identifiers: Whether to surround column aliases with double quotes, default is false
#}

{% macro unpivot(relation=none, cast_to='varchar', exclude=none, remove=none, field_name='field_name', value_name='value', quote_identifiers=fals) -%}
    {{ return(adapter.dispatch('unpivot', 'dbt_utils')(relation, cast_to, exclude, remove, field_name, value_name, quote_identifiers)) }}
{% endmacro %}

{% macro default__unpivot(relation=none, cast_to='varchar', exclude=none, remove=none, field_name='field_name', value_name='value', quote_identifiers=fals) -%}

    {% if not relation %}
        {{ exceptions.raise_compiler_error("Error: argument `relation` is required for `unpivot` macro.") }}
    {% endif %}

  {%- set exclude = exclude if exclude is not none else [] %}
  {%- set remove = remove if remove is not none else [] %}

  {%- set include_cols = [] %}

  {%- set table_columns = {} %}

  {%- do table_columns.update({relation: []}) %}

  {%- do dbt_utils._is_relation(relation, 'unpivot') -%}
  {%- do dbt_utils._is_ephemeral(relation, 'unpivot') -%}
  {%- set cols = adapter.get_columns_in_relation(relation) %}

  {%- for col in cols -%}
    {%- if col.column.lower() not in remove|map('lower') and col.column.lower() not in exclude|map('lower') -%}
      {% do include_cols.append(col) %}
    {%- endif %}
  {%- endfor %}


  {%- for col in include_cols -%}
    select
      {%- for exclude_col in exclude %}
        {{ exclude_col }},
      {%- endfor %}

      cast('{{ col.column }}' as {{ type_string() }}) as {{ field_name }},
      cast(  {% if quote_identifiers %}
               {% set column_identifier = adapter.quote(col.column) %}
             {% else %}
               {% set column_identifier = col.column %}
             {% endif %}
             {% if col.data_type == 'boolean' %}
               {{ dbt_utils.cast_bool_to_text(column_identifier) }}
             {% else %}
               {{ column_identifier }}
             {% endif %}
           as {{ cast_to }}) as {{ value_name }}

    from {{ relation }}

    {% if not loop.last -%}
      union all
    {% endif -%}
  {%- endfor -%}

{%- endmacro %}
