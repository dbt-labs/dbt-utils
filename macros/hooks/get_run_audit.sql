
{% macro get_run_audit(results, flags, target) %}
{#
This macro gets back a dictionary like:
    {
        'run_results': [
            {
                'name': 'stg_customers',
                'package': 'jaffle_shop',
                'timing': {
                    'started_at': '2019-05-03T22:20:16.315020Z',
                    'completed_at': '2019-05-03T22:20:16.716081Z'
                }
            }
        ],
        'target': {
            'name': 'dev',
            'user': 'claire',
            'database': 'claire',
            'schema': 'jaffle_shop_dev'
        },
        'flags': {
            'full_refresh': False
        }
    }
 #}
{% set run_audit={} %}

-- add the run results to the run audit
{% set run_results=[] %}

-- for each result
{% for result in results %}

    -- only include passed models (is this the best way to find it?)
    {% if not result.error and result.skipped == False %}

        {% set model_result={} %}
        -- Get the materelizaed type of our model, View, Incremental etc.
        {% set materialization=config.get("materialized")%}

        {% do model_result.update({'name': result.node.name}) %}
        {% do model_result.update({'package': result.node.package_name}) %}
        -- Schema the model belongs to
        {% do model_result.update({'schema': result.node.schema}) %}
        {% do model_result.update({'materialized': materialization}) %}

        {% for timing in result.timing %}
            {% if timing['name'] == 'execute' %}
                {% set timing_result={} %}

                {% do timing_result.update({'started_at': timing['started_at'].strftime("%Y-%m-%d %H:%M:%S:%f") }) %}
                {% do timing_result.update({'completed_at': timing['completed_at'].strftime("%Y-%m-%d %H:%M:%S:%f") }) %}
                {% do model_result.update({'timing': timing_result}) %}
            {% endif %}
        {% endfor %}

    {% do run_results.append(model_result) %}

    {% endif %}

{% endfor %}

{% do run_audit.update({'run_results': run_results}) %}

-- add the target to the run audit
{% set run_target={} %}

{% for key in cc_dbt_utils.get_target_keys() %}
    {% do run_target.update({key: target[key]}) %}
{% endfor %}

{% do run_audit.update({'target': run_target}) %}

-- add the run flags to the run audit
{% set run_flags={} %}

{% do run_flags.update({'full_refresh': flags.FULL_REFRESH}) %}

{% do run_audit.update({'flags': run_flags}) %}

{#- Escape quotes -#}
{{ return(run_audit | replace("'", "''")) }}


select 1;
{% endmacro %}

{% macro get_target_keys() %}
{# Abstracting this into a macro so people can override it in their own projects #}
    {{ return([
        'name',
        'user',
        'database',
        'schema'
    ]) }}
{% endmacro %}
