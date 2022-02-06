{% macro star(from, relation_alias=False, except=[], regex='', prefix='', suffix='') -%}
    {{ return(adapter.dispatch('star', 'dbt_utils')(from, relation_alias, except, regex, prefix, suffix)) }}
{% endmacro %}

{% macro default__star(from, relation_alias=False, except=[], regex='', prefix='', suffix='') -%}
    {%- do dbt_utils._is_relation(from, 'star') -%}
    {%- do dbt_utils._is_ephemeral(from, 'star') -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}


    {%- set include_cols = [] %}
    {%- set cols = adapter.get_columns_in_relation(from) -%}
    {%- set except = except | map("lower") | list %}

    {#-- If there is no regex set, capture all columns by default #}
    {%- if not regex | length -%}
        {%- set regex = '.' %}
    {% endif %}

    {{log(regex, info=True)}}

    {%- for col in cols -%}

        {%- if col.column | lower not in except and modules.re.match(regex, col.column | string, modules.re.IGNORECASE) -%}
            {% do include_cols.append(col.column) %}
        {%- endif %}

    {%- endfor %}

    {%- for col in include_cols %}
        {%- set col = col | string -%}
        {%- if relation_alias %}{{ relation_alias }}.{% else %}{%- endif -%}{{ adapter.quote(col)|trim }} as {{ adapter.quote(prefix ~ col ~ suffix)|trim }}
        {%- if not loop.last %},{{ '\n  ' }}{% endif %}

        {%- endfor -%}

{%- endmacro %}

