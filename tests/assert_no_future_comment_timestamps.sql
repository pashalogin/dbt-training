-- Singular test: comments should never have a future timestamp.
-- A future timestamp would indicate a data quality issue in the source.

select *
from {{ ref('silver_airport_comments') }}
where comment_timestamp > current_timestamp()
