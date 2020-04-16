{% macro compare_queries_w_columns(a_query, b_query, primary_key=NONE) %}

WITH a AS (
    {{ a_query }}
),

     b AS (
         {{ b_query }}
     ),

     a_intersect_b AS (
         SELECT *
         FROM a {{ dbt_utils.intersect() }}
         SELECT *
         FROM b
     ),

     a_except_b AS (
         SELECT *
         FROM a {{ dbt_utils.except() }}
         SELECT *
         FROM b
     ),

     b_except_a AS (
         SELECT *
         FROM b {{ dbt_utils.except() }}
         SELECT *
         FROM a
     ),

     all_records AS (
         SELECT *,
                TRUE AS in_a,
                TRUE AS in_b
         FROM a_intersect_b

         UNION ALL

         SELECT *,
                TRUE  AS in_a,
                FALSE AS in_b
         FROM a_except_b

         UNION ALL

         SELECT *,
                FALSE AS in_a,
                TRUE  AS in_b
         FROM b_except_a
     )
SELECT *
FROM all_records
WHERE NOT (in_a AND in_b)
    {% endmacro %}
