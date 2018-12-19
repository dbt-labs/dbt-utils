{% macro except() %}
  {{ adapter_macro('dbt_utils.except') }}
{% endmacro %}


{% macro default__except() %}

    except

{% endmacro %}
    
{% macro bigquery__except() %}

    except distinct

{% endmacro %}