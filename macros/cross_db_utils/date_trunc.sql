{% macro date_trunc(datepart, date) -%}
  {{ return(adapter.dispatch('date_trunc', 'dbt_utils') (datepart, date)) }}
{%- endmacro %}

{% macro default__date_trunc(datepart, date) -%}
  {% do dbt_utils.xdb_deprecation_warning('date_trunc', model.package_name, model.name) %}
  {{ return(adapter.dispatch('date_trunc', 'dbt') (datepart, date)) }}
{%- endmacro %}

{#-/* reference: https://www.techonthenet.com/oracle/functions/trunc_date.php */#}
{% macro oracle__date_trunc(datepart, date) -%}
{%- if datepart == 'day' -%}
    trunc({{date}}, 'DDD')  
{%- elif datepart == 'week' -%}
    trunc({{date}}, 'WW')  
{%- elif datepart == 'month' -%}
    trunc({{date}}, 'MON') 
{%- elif datepart == 'quarter' -%}
    trunc({{date}}, 'Q')        
{%- elif datepart == 'year' -%}
    trunc({{date}}, 'YYYY')
{% else %}
        {{ exceptions.raise_compiler_error("Unsupported datepart for macro date_trunc in oracle: {!r}".format(datepart)) }}    
{%- endif -%}    
{%- endmacro %}
