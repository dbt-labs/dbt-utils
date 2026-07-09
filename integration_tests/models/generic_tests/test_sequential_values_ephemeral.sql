{{ config(materialized='ephemeral') }}

select
    col_a,
    my_even_sequence

from {{ ref('data_test_sequential_values') }}
