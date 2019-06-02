{% macro width_bucket(expr, min_value, max_value, num_buckets) %}
  {{ adapter_macro('dbt_utils.width_bucket', expr, min_value, max_value, num_buckets) }}
{% endmacro %}


{% macro default__width_bucket(expr, min_value, max_value, num_buckets) -%}

    {%- set bucket_width = '((' ~ max_value ~ ' - ' ~ min_value ~ ')/' ~ num_buckets ~ ')' -%}
    (
        case
            when mod({{ expr }}, {{ bucket_width }}) = 0
            then 1
            else 0
        end
    ) +
        ceil(
            ({{ expr }} - {{ min_value }})/{{ bucket_width }}
        )

{%- endmacro %}

{% macro snowflake__width_bucket(expr, min_value, max_value, num_buckets) %}
    width_bucket({{ expr }}, {{ min_value }}, {{ max_value }}, {{ num_buckets }} )
{% endmacro %}
