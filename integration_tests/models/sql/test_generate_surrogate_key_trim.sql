with data as (

    select * from {{ ref('data_generate_surrogate_key_trim') }}

)

select
    -- Test without trim (default behavior) - should produce different hashes for whitespace variations
    {{ dbt_utils.generate_surrogate_key(['column_1', 'column_2', 'column_3']) }} as key_no_trim,
    
    -- Test with trim enabled - should produce identical hashes regardless of whitespace
    {{ dbt_utils.generate_surrogate_key(['column_1', 'column_2', 'column_3'], trim=true) }} as key_with_trim,
    
    column_1,
    column_2,
    column_3

from data