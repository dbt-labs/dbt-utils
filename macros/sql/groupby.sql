{%- macro group_by(n) -%}
    {{ return(adapter.dispatch('group_by', 'dbt_utils')(n)) }}
{% endmacro %}

{%- macro default__group_by(n) -%}

  group by {{ range(1, n + 1) | join(',') }}

{%- endmacro -%}
