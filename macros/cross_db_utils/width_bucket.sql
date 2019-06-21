{% macro width_bucket(expr, min_value, max_value, num_buckets) %}
  {{ adapter_macro('dbt_utils.width_bucket', expr, min_value, max_value, num_buckets) }}
{% endmacro %}


{% macro default__width_bucket(expr, min_value, max_value, num_buckets) -%}

    {% set bucket_width -%}
    (( {{ max_value }} - {{ min_value }} ) / {{ num_buckets }} )
    {% endset %}
    (
        -- to break ties when the amount is eaxtly at the bucket egde
        case
            when mod(
                        {{ dbt_utils.safe_cast(expr, 'numeric') }}, 
                        {{ dbt_utils.safe_cast(bucket_width, 'numeric') }}
                    ) = 0
            then 1
            else 0
        end
    ) +
      -- Anything over max_value goes the N+1 bucket
        least(
            ceil(
                ({{ expr }} - {{ min_value }})/{{ bucket_width }}
            ),
            {{ num_buckets }} + 1
        )
{%- endmacro %}

{% macro snowflake__width_bucket(expr, min_value, max_value, num_buckets) %}
    width_bucket({{ expr }}, {{ min_value }}, {{ max_value }}, {{ num_buckets }} )
{% endmacro %}
