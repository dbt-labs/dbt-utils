{%- macro group_by(n) -%}
    {{ return(adapter.dispatch('group_by', packages = dbt_utils._get_utils_namespaces())(n)) }}
{% endmacro %}

{%- macro default__group_by(n) -%}

  group by {% for i in range(1, n + 1) -%}
      {{ i }}{{ ',' if not loop.last }}   
   {%- endfor -%}

{%- endmacro -%}
