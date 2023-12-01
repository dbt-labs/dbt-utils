{{ config(materialized='table') }}

select

  id,
  'incorrect_name' as first_name,
  last_name,
  email,
  ip_address,
  created_at,
  is_active

from {{ ref('data_people') }}
