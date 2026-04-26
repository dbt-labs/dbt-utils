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
#}

{% macro unpivot(relation=none, cast_to='varchar', exclude=none, remove=none, field_name='field_name', value_name='value', quote_identifiers=False) -%}
    {{ return(adapter.dispatch('unpivot', 'dbt_utils')(relation, cast_to, exclude, remove, field_name, value_name, quote_identifiers)) }}
{% endmacro %}

{% macro default__unpivot(relation=none, cast_to='varchar', exclude=none, remove=none, field_name='field_name', value_name='value', quote_identifiers=False) -%}

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
    {%- set current_col_name = adapter.quote(col.column) if quote_identifiers else col.column -%}
    select
      {%- for exclude_col in exclude %}
        {{ adapter.quote(exclude_col) if quote_identifiers else exclude_col }},
      {%- endfor %}

      cast('{{ col.column }}' as {{ dbt.type_string() }}) as {{ adapter.quote(field_name) if quote_identifiers else field_name  }},
      cast(  {% if col.data_type == 'boolean' %}
           {{ dbt.cast_bool_to_text(current_col_name) }}
             {% else %}
           {{ current_col_name }}
             {% endif %}
           as {{ cast_to }}) as {{ adapter.quote(value_name) if quote_identifiers else value_name }}

    from {{ relation }}

    {% if not loop.last -%}
      union all
    {% endif -%}
  {%- endfor -%}

{%- endmacro %}
