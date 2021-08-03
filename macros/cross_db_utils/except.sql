{% macro except() %}
  {{ return(adapter.dispatch('except', 'cc_dbt_utils')()) }}
{% endmacro %}


{% macro default__except() %}

    except

{% endmacro %}
    
{% macro bigquery__except() %}

    except distinct

{% endmacro %}