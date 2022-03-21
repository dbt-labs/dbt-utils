{%- macro order_by(n) -%}
    {{ return(adapter.dispatch('order_by', 'dbt_utils')(n)) }}
{% endmacro %}

{%- macro default__order_by(n) -%}

  order by {% for i in range(1, n + 1) -%}
      {{ i }}{{ ',' if not loop.last }}   
   {%- endfor -%}

{%- endmacro -%}
