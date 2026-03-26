{{ config(materialized='ephemeral') }}

with source as (
    select * from {{ source('airports', 'airports') }}
)

select
    ident         as airport_ident,
    type          as airport_type,
    name          as airport_name,
    latitude_deg  as airport_lat,
    longitude_deg as airport_long,
    continent,
    iso_country,
    iso_region
from source
