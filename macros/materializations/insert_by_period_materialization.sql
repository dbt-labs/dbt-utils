
{% materialization insert_by_period, default -%}
  -- If there is no __PERIOD_FILTER__ specified, raise error.
  {{ dbt_utils.check_for_period_filter(model.unique_id, sql) }}

  -- Configuration (required)
  {%- set timestamp_field = config.require('timestamp_field') -%}
  {%- set start_date = config.require('start_date') -%}

  -- Configuration (others)
  {%- set unique_key = config.get('unique_key') -%}
  {%- set stop_date = config.get('stop_date') or '' -%}}
  {%- set period = config.get('period') or 'week' -%}

  {% set target_relation = this.incorporate(type='table') %}
  {% set existing_relation = load_relation(this) %}
  {% set tmp_relation = make_temp_relation(target_relation) %}
  {%- set full_refresh_mode = (should_full_refresh()) -%}

  {% set on_schema_change = incremental_validate_on_schema_change(config.get('on_schema_change'), default='ignore') %}

  {% set tmp_identifier = model['name'] + '__dbt_tmp' %}
  {% set backup_identifier = model['name'] + "__dbt_backup" %}

  -- the intermediate_ and backup_ relations should not already exist in the database; get_relation
  -- will return None in that case. Otherwise, we get a relation that we can drop
  -- later, before we try to use this name for the current operation. This has to happen before
  -- BEGIN, in a separate transaction
  {% set preexisting_intermediate_relation = adapter.get_relation(identifier=tmp_identifier, 
                                                                  schema=schema,
                                                                  database=database) %}                                               
  {% set preexisting_backup_relation = adapter.get_relation(identifier=backup_identifier,
                                                            schema=schema,
                                                            database=database) %}
  {{ drop_relation_if_exists(preexisting_intermediate_relation) }}
  {{ drop_relation_if_exists(preexisting_backup_relation) }}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}

  -- `BEGIN` happens here:
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% set to_drop = [] %}

  {# -- first check whether we want to full refresh for source view or config reasons #}
  {% set trigger_full_refresh = (full_refresh_mode or existing_relation.is_view) %}

  {# -- we create an empty table if there is no exisiting relation or a full refresh is triggered #}
  {% if existing_relation is none or trigger_full_refresh %}
      {%- set empty_sql = sql | replace("__PERIOD_FILTER__", 'false') -%} 
      {% set build_sql = create_table_as(False, target_relation, empty_sql) %}

      {% call statement("main") %}
          {{ build_sql }}
      {% endcall %}
  {% endif %}

  -- Now that we have an empty table, let's put something in it.

  {% set _ = dbt_utils.get_period_boundaries(schema,
                                              identifier,
                                              timestamp_field,
                                              start_date,
                                              stop_date,
                                              period) %}
  {%- set start_timestamp = load_result('period_boundaries')['data'][0][0] | string -%}
  {%- set stop_timestamp = load_result('period_boundaries')['data'][0][1] | string -%}
  {%- set num_periods = load_result('period_boundaries')['data'][0][2] | int -%}

  {% set target_columns = adapter.get_columns_in_relation(target_relation) %}
  {%- set target_cols_csv = target_columns | map(attribute='quoted') | join(', ') -%}

  {%- set loop_vars = {'sum_rows_inserted': 0} -%}

  {% for i in range(num_periods) -%} 
    {%- set msg = "Running for " ~ period ~ " " ~ (i + 1) ~ " of " ~ num_periods -%}
    {{ dbt_utils.log_info(msg) }}

    {%- set tmp_identifier = model['name'] ~ '__dbt_incremental_period_' ~ i ~ '_tmp' -%}
    {%- set tmp_relation = api.Relation.create(identifier=tmp_identifier,
                                              schema=schema, type='table') -%}

    {% set tmp_table_sql = dbt_utils.get_period_sql(target_cols_csv,
                                                       sql,
                                                       timestamp_field,
                                                       period,
                                                       start_timestamp,
                                                       stop_timestamp,
                                                       i) %}

    {% do run_query(create_table_as(True, tmp_relation, tmp_table_sql)) %}

    {% do adapter.expand_target_column_types(
             from_relation=tmp_relation,
             to_relation=target_relation) %}

    {%- set name = 'main-' ~ i -%}
    {% set build_sql = incremental_upsert(tmp_relation, target_relation, unique_key=unique_key) %}
    {% call statement(name, fetch_result=True) -%}
      {{ build_sql }}
    {%- endcall %}

    {% set result = load_result('main-' ~ i) %}
    {% if 'response' in result.keys() %} {# added in v0.19.0 #}
        {% set rows_inserted = result['response']['rows_affected'] %}
    {% else %} {# older versions #}
        {% set rows_inserted = result['status'].split(" ")[2] | int %}
    {% endif %}

    {%- set sum_rows_inserted = loop_vars['sum_rows_inserted'] + rows_inserted -%}
    {%- if loop_vars.update({'sum_rows_inserted': sum_rows_inserted}) %} {% endif -%}

    {%- set msg = "Ran completed for " ~ period ~ " " ~ ( i + 1 ) ~ " of " ~ num_periods ~ "; " ~ rows_inserted ~ " records inserted" -%}
    {{ dbt_utils.log_info(msg) }}
  {%- endfor %}

  {% do persist_docs(target_relation, model) %}

  {% if existing_relation is none or existing_relation.is_view or should_full_refresh() %}
    {% do create_indexes(target_relation) %}
  {% endif %}

  {{ run_hooks(post_hooks, inside_transaction=True) }}

  -- `COMMIT` happens here
  {% do adapter.commit() %}

  {% for rel in to_drop %}
      {% do adapter.drop_relation(rel) %}
  {% endfor %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}

  {%- set status_string = "INSERT " ~ loop_vars['sum_rows_inserted'] -%}

  {% call noop_statement('main', status_string) -%}
    -- no-op
  {%- endcall %}

  {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}
