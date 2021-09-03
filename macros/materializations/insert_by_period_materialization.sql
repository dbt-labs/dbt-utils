
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

  {{ dbt_utils.log_info("[DEBUG] Parameters are set!") }}

  {% set target_relation = this.incorporate(type='table') %}

  {%- set target_msg = "[DEBUG] Target is set to be " ~ target_relation -%}
  {{ dbt_utils.log_info(target_msg) }}

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

  {{ dbt_utils.log_info("[DEBUG] Prehooks (outside transaction) are done!") }}

  -- `BEGIN` happens here:
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {{ dbt_utils.log_info("[DEBUG] Prehooks (inside transaction) are done!") }}

  {% set to_drop = [] %}

  {# -- first check whether we want to full refresh for source view or config reasons #}
  {% set trigger_full_refresh = (full_refresh_mode or existing_relation.is_view) %}

  {# -- we create an empty table if there is no exisiting relation or a full refresh is triggered #}
  {% if existing_relation is none or trigger_full_refresh %}
      {%- set empty_sql = sql | replace("__PERIOD_FILTER__", 'false') -%} 
      {% set build_sql = create_table_as(False, target_relation, empty_sql) %}

      {{ dbt_utils.log_info("[DEBUG] Within 'if existing_relation is none or trigger_full_refresh'!") }}
      {%- set existing_relation_msg = "[DEBUG] Existing relation is: " ~ existing_relation -%}
      {%- set trigger_full_refresh_msg = "[DEBUG] Trigger full refresh flag is: " ~ trigger_full_refresh -%}
      {{ dbt_utils.log_info(existing_relation_msg) }}
      {{ dbt_utils.log_info(trigger_full_refresh_msg) }}

      {% call statement("main") %}
          {{ dbt_utils.log_info("[DEBUG] Executing the following:") }}
          {{ dbt_utils.log_info(build_sql) }}
          {{ build_sql }}
      {% endcall %}
  {% endif %}

  {{ dbt_utils.log_info("[DEBUG] We have an empty table now.") }}
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


  {%- set start_timestamp_msg = "[DEBUG] Start timestamp is: " ~ start_timestamp -%}
  {%- set stop_timestamp_msg = "[DEBUG] End timestamp is: " ~ stop_timestamp -%}
  {%- set num_periods_msg = "[DEBUG] Number of periods: " ~ num_periods ~ " " ~ period ~ "(s)" -%}
  {{ dbt_utils.log_info(start_timestamp_msg) }}
  {{ dbt_utils.log_info(stop_timestamp_msg) }}
  {{ dbt_utils.log_info(num_periods_msg) }}

  {% set target_columns = adapter.get_columns_in_relation(target_relation) %}
  {%- set target_cols_csv = target_columns | map(attribute='quoted') | join(', ') -%}

  {%- set loop_vars = {'sum_rows_inserted': 0} -%}

  {% for i in range(num_periods) -%} 
    {%- set loop_enter_msg = "[DEBUG] Entering the " ~ (i + 1) ~ ". iteration of the loop." -%}
    {{ dbt_utils.log_info(loop_enter_msg) }}

    {%- set msg = "Running for " ~ period ~ " " ~ (i + 1) ~ " of " ~ num_periods -%}
    {{ dbt_utils.log_info(msg) }}

    {%- set tmp_identifier_suffix = '__dbt_incremental_period_' ~ i ~ '_tmp' -%}
    {% set tmp_relation = make_temp_relation(target_relation, tmp_identifier_suffix) %}

    {%- set tmp_relation_msg = "[DEBUG] (Within loop) Termporary relation is: " ~ tmp_relation -%}
    {{ dbt_utils.log_info(tmp_relation_msg) }}

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
      {{ dbt_utils.log_info("[DEBUG] (Within loop) Executing the following:") }}
      {{ dbt_utils.log_info(build_sql) }}
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

  {{ dbt_utils.log_info("[DEBUG] Out of the loop.") }}

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
