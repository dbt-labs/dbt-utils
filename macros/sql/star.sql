{% macro star(from, relation_alias=False, except=[], prefix='', suffix='', quote_identifiers=True) -%}
    {{ return(adapter.dispatch('star', 'dbt_utils')(from, relation_alias, except, prefix, suffix, quote_identifiers)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], prefix='', suffix='', quote_identifiers=True) -%}
    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {% do return('*') %}
    {%- endif -%}

    {% set cols = dbt_utils.get_filtered_columns_in_relation(from, except) %}

    {%- if cols|length <= 0 -%}
        {% if flags.WHICH == 'compile' %}
            {% set response %}
*
/* No columns were returned. Maybe the relation doesn't exist yet 
or all columns were excluded. This star is only output during  
dbt compile, and exists to keep SQLFluff happy. */
            {% endset %}
            {% do return(response) %}
        {% else %}
            {% do return("/* no columns returned from star() macro */") %}
        {% endif %}
    {%- else -%}
        {%- for col in cols %}
            {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}
                {%- if quote_identifiers -%}
                    {{ adapter.quote(col)|trim }} {%- if prefix!='' or suffix!='' %} as {{ adapter.quote(prefix ~ col ~ suffix)|trim }} {%- endif -%}
                {%- else -%}
                    {{ col|trim }} {%- if prefix!='' or suffix!='' %} as {{ (prefix ~ col ~ suffix)|trim }} {%- endif -%}
                {% endif %}
            {%- if not loop.last %},{{ '\n  ' }}{%- endif -%}
        {%- endfor -%}
    {% endif %}
{%- endmacro %}

