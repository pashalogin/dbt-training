-- Validate that the SCD snapshot captured the closure of
-- Los Angeles County Sheriff's Department Heliport (01CN).
-- Run with: dbt show --select la_heliport_closed
-- This is test 123
select
    airport_ident,
    airport_name,
    airport_type,
    dbt_valid_from,
    dbt_valid_to,
    dbt_scd_id,
    case
        when dbt_valid_to is null then 'CURRENT'
        else 'HISTORICAL'
    end as record_status
from {{ target.database }}.{{ target.schema }}.scd_silver_airports
where airport_ident = '01CN'
order by dbt_valid_from
