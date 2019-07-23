{#
Pivot values from columns to rows. Similar to pandas DataFrame melt() function.

Example Usage: {{ unpivot(table=ref('users'), cast_to='integer', exclude=['id','created_at']) }}

Arguments:
    table: Relation object, required.
    cast_to: The datatype to cast all unpivoted columns to. Default is varchar.
    exclude: A list of columns to keep but exclude from the unpivot operation. Default is none.
    remove: A list of columns to remove from the resulting table. Default is none.
    field_name: Destination table column name for the source table column names.
    value_name: Destination table column name for the pivoted values
#}

{% macro unpivot(table, cast_to='varchar', exclude=none, remove=none, field_name='field_name', value_name='value') -%}

  {%- set exclude = exclude if exclude is not none else [] %}
  {%- set remove = remove if remove is not none else [] %}

  {%- set include_cols = [] %}

  {%- set table_columns = {} %}

  {%- set _ = table_columns.update({table: []}) %}

  {%- do dbt_utils._is_relation(table, 'unpivot') -%}
  {%- set cols = adapter.get_columns_in_relation(table) %}

  {%- for col in cols -%}
    {%- if col.column.lower() not in remove|map('lower') and col.column.lower() not in exclude|map('lower') -%}
      {% set _ = include_cols.append(col) %}
    {%- endif %}
  {%- endfor %}


  {%- for col in include_cols -%}
    select
      {%- for exclude_col in exclude %}
        {{ exclude_col }},
      {%- endfor %}

      cast('{{ col.column }}' as {{ dbt_utils.type_string() }}) as {{ field_name }},
      cast({{ col.column }} as {{ cast_to }}) as {{ value_name }}

    from {{ table }}

    {% if not loop.last -%}
      union all
    {% endif -%}
  {%- endfor -%}

{%- endmacro %}
