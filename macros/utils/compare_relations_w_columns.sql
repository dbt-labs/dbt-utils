{% macro pop_columns(columns, columns_to_pop) %}
{% set popped_columns=[] %}

{% for column in columns %}
    {% if column.name | lower not in columns_to_pop | lower %}
        {% do popped_columns.append(column) %}
    {% endif %}
{% endfor %}

{{ return(popped_columns) }}
{% endmacro %}


----

{% macro compare_relations_w_columns(a_relation, b_relation, exclude_columns=[], primary_key=None) %}

{%- set a_columns = adapter.get_columns_in_relation(a_relation) -%}

{% set check_columns=audit_helper.pop_columns(a_columns, exclude_columns) %}

{% set check_cols_csv = check_columns | map(attribute='quoted') | join(', ') %}

{% set a_query %}
select
    {{ check_cols_csv }}

from {{ a_relation }}
{% endset %}

{% set b_query %}
select
    {{ check_cols_csv }}

from {{ b_relation }}
{% endset %}

{{ compare_queries_w_columns(a_query, b_query, primary_key) }}



{% endmacro %}
