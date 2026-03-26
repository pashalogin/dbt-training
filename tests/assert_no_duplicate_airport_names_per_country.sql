-- Singular test: no airport name should appear more than 10 times
-- within the same country. This catches bulk data quality issues
-- while allowing legitimate duplicates (e.g. regional airports
-- sharing a common name).

select
    iso_country,
    airport_name,
    count(*) as cnt
from {{ ref('silver_airports') }}
group by iso_country, airport_name
having count(*) > 10
