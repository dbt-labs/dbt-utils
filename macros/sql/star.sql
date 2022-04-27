{% macro star(from, relation_alias=False, except=[], prefix='', suffix='', regex='')   -%}
    {{ return(adapter.dispatch('star', 'dbt_utils')(from, relation_alias, except, prefix, suffix, regex)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], prefix='', suffix='', regex='') -%}
    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('*') }}
    {% endif %}

    {%- set include_cols = [] %}

    {#-- If there is no regex set, capture all columns by default #}
    {%- if not regex | length -%}
        {%- set regex = '.' %}
    {% endif %}

    {%- for col in dbt_utils.get_filtered_columns_in_relation(from, except) %}

        {%- if col | modules.re.match(regex, col | string, modules.re.IGNORECASE) -%}
            {% do include_cols.append(col) %}
        {%- endif %}

    {%- endfor %}

    {%- for col in include_cols %}
        {%- set col = col | string -%}
        {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}{{ adapter.quote(col)|trim }} {%- if prefix!='' or suffix!='' %} as {{ adapter.quote(prefix ~ col ~ suffix)|trim }} {%- endif -%}
        {%- if not loop.last %},{{ '\n  ' }}{% endif %}

    {%- endfor -%}

{%- endmacro %}
