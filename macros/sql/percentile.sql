{% macro percentile(percentile_field, partition_field, percent) -%}

{{ adapter.dispatch('percentile', 'dbt_utils') (percentile_field, partition_field, percent) }}

{%- endmacro %}

{% macro default__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percent }} )
        within group ( order by {{ percentile_field }} )
        over ( partition by {{ partition_field }} )

{% endmacro %}

{# Redshift requires the percentile_field to be cast as a float for percentile_cont to work correctly #}
{% macro redshift__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percent }} )
        within group ( order by cast({{ percentile_field }} as {{ dbt.type_float() }}) )
        over ( partition by {{ partition_field }} )

{% endmacro %}

{% macro bigquery__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percentile_field }}, 
        {{ percent }}) 
        over (partition by {{ partition_field }}    
        )

{% endmacro %}

{% macro postgres__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percent }} )
        within group ( order by {{ percentile_field }} )
    {# Postgres doesn't support percentile_cont as a window function, so the caller must group by partition_field #}

{% endmacro %}

{% macro spark__percentile(percentile_field, partition_field, percent)  %}

    percentile( 
        {{ percentile_field }}, 
        {{ percent }}) 
        over (partition by {{ partition_field }}    
        )

{% endmacro %}

{% macro duckdb__percentile(percentile_field, partition_field, percent) %}

    quantile_cont(
        {{ percentile_field }},
        {{ percent }})
        over (partition by {{ partition_field }}
        )

{% endmacro %}