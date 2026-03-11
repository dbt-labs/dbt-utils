{% macro percentile_cont(column, percentile_value) -%}
  {{ return(adapter.dispatch('percentile_cont', 'dbt_utils')(column, percentile_value)) }}
{%- endmacro %}

{% macro default__percentile_cont(column, percentile_value) -%}
    percentile_cont({{ percentile_value }}) within group (order by {{ column }})
{%- endmacro %}

{% macro bigquery__percentile_cont(column, percentile_value) -%}
    percentile_cont({{ column }}, {{ percentile_value }}) over()
{%- endmacro %}


{% macro percentile_disc(column, percentile_value) -%}
  {{ return(adapter.dispatch('percentile_disc', 'dbt_utils')(column, percentile_value)) }}
{%- endmacro %}

{% macro default__percentile_disc(column, percentile_value) -%}
    percentile_disc({{ percentile_value }}) within group (order by {{ column }})
{%- endmacro %}

{% macro bigquery__percentile_disc(column, percentile_value) -%}
    percentile_disc({{ column }}, {{ percentile_value }}) over()
{%- endmacro %}
