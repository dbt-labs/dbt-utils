{% set regex = '.+[^3]$' %}


WITH data AS (

    SELECT
        {{ dbt_utils.star(FROM=ref('data_star'), regex=regex) }}

    FROM {{ ref('data_star') }}

)

SELECT * FROM data

