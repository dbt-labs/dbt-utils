{% macro simple_call(sql_code) -%}
    select *
    from (
      {{sql_code}}
    )
{% endmacro %}

{% materialization insert_by_period, default -%}
  -- If there is no __PERIOD_FILTER__ specified, raise error. (Maybe create a macro for this.)
  {%- if sql.find('__PERIOD_FILTER__') == -1 -%}
    {%- set error_message -%}
      Model '{{ model.unique_id }}' does not include the required string '__PERIOD_FILTER__' in its sql
    {%- endset -%}
    {{ exceptions.raise_compiler_error(error_message) }}
  {%- endif -%}

  -- Configuration (required)
  {%- set timestamp_field = config.require('timestamp_field') -%}
  {%- set start_date = config.require('start_date') -%}

  -- Configuration (others)
  {%- set unique_key = config.get('unique_key') -%}
  {%- set stop_date = config.get('stop_date') or '' -%}}
  {%- set period = config.get('period') or 'hour' -%}

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

  {% if existing_relation is none %}
      {%- set empty_sql = sql | replace("__PERIOD_FILTER__", 'false') -%} -- We create an empty table
      {% set build_sql = create_table_as(False, target_relation, empty_sql) %}

      {{ dbt_utils.log_info("We are in the existing_relation is none and creating an empty table.") }}
  {% elif trigger_full_refresh %}
      {#-- Make sure the backup doesn't exist so we don't encounter issues with the rename below #}
      {% set tmp_identifier = model['name'] + '__dbt_tmp' %}
      {% set backup_identifier = model['name'] + '__dbt_backup' %}
      {% set intermediate_relation = existing_relation.incorporate(path={"identifier": tmp_identifier}) %}
      {% set backup_relation = existing_relation.incorporate(path={"identifier": backup_identifier}) %}

      {% set unfiltered_sql = sql | replace("__PERIOD_FILTER__", 'true') %} -- Period filter should have no effect
      {% set build_sql = create_table_as(False, intermediate_relation, unfiltered_sql) %}
      {% set need_swap = true %}
      {% do to_drop.append(backup_relation) %}

      {{ dbt_utils.log_info("We are in the elif trigger_full_refresh. So __PERIOD_FILTER__ is just set to true, thus it should have no effect.") }}
  {% endif %}

  -- Let's worry about this later. (If the table exists and it's not a full refresh)
  {% if existing_relation and not trigger_full_refresh %}
    {% set unfiltered_sql = sql | replace("__PERIOD_FILTER__", 'true') %} -- Period filter should have no effect. This is a BUG here. 
    {% do run_query(create_table_as(True, tmp_relation, unfiltered_sql)) %}
    {% do adapter.expand_target_column_types(
             from_relation=tmp_relation,
             to_relation=target_relation) %}
    {% do process_schema_changes(on_schema_change, tmp_relation, existing_relation) %}
    {% set build_sql = incremental_upsert(tmp_relation, target_relation, unique_key=unique_key) %}

    {{ dbt_utils.log_info("We are in our custom case.") }}
  {% endif %}

  {{ dbt_utils.log_info("Calling the empty table creation statement.") }}
  {% call statement("main") %}
      {{ build_sql }}
  {% endcall %}

  -- Now that we have an empty table, let's put something in it.

  {%- set number_of_periods = 12 -%} -- define some number manually for testing purposes

  {% for i in range(number_of_periods) -%} 
    {%- set msg = "Running for " ~ period ~ " " ~ i ~ " of " ~ number_of_periods -%}
    {{ dbt_utils.log_info(msg) }}

    {%- set tmp_identifier = model['name'] ~ '__dbt_incremental_period_' ~ i ~ '_tmp' -%}
    {%- set tmp_relation = api.Relation.create(identifier=tmp_identifier,
                                              schema=schema, type='table') -%}

    -- this is a macro (start)
    {%- set period_filter -%}
      ({{timestamp_field}} >  '2021-08-23 00:00:00'::timestamp + interval '{{i}} {{period}}' and
      {{timestamp_field}} <= '2021-08-23 00:00:00'::timestamp + interval '{{i}} {{period}}' + interval '1 {{period}}' and
      {{timestamp_field}} <  '{{stop_date}}'::timestamp)
    {%- endset -%}

    {%- set filtered_sql = sql | replace("__PERIOD_FILTER__", period_filter) -%} -- Filtering for 1st period
    -- (end)

    {{ dbt_utils.log_info("We are now calling the " ~ (i + 1) ~ ". iteration statement.") }}

    {% call statement() -%}
      {% set tmp_table_sql = dbt_utils.simple_call(filtered_sql) %}
      {{dbt.create_table_as(True, tmp_relation, tmp_table_sql)}}
    {%- endcall %}

    {{adapter.expand_target_column_types(from_relation=tmp_relation,
                                         to_relation=target_relation)}}

    {{ dbt_utils.log_info("We are now inserting the result of the " ~ (i + 1) ~ ". iteration.") }}

    {%- set name = 'main-' ~ i -%}
    {% call statement(name, fetch_result=True) -%}
      insert into {{target_relation}}
      (
          select
              *
          from {{tmp_relation.include(schema=False)}}
      );
    {%- endcall %}

    {% set result = load_result('main-' ~ i) %}
    {% if 'response' in result.keys() %} {# added in v0.19.0 #}
        {% set rows_inserted = result['response']['rows_affected'] %}
    {% else %} {# older versions #}
        {% set rows_inserted = result['status'].split(" ")[2] | int %}
    {% endif %}

    {%- set msg = "Ran for " ~ period ~ " " ~ i ~ " of " ~ number_of_periods ~ "; " ~ rows_inserted ~ " records inserted" -%}
    {{ dbt_utils.log_info(msg) }}
  {%- endfor %}

  {% if need_swap %} 
      {% do adapter.rename_relation(target_relation, backup_relation) %} 
      {% do adapter.rename_relation(intermediate_relation, target_relation) %} 
  {% endif %}

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

  {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}
