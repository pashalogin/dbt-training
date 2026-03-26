{{ config(materialized='ephemeral') }}

with source as (
    select * from {{ source('comments', 'airport_comments') }}
)

select
    id               as comment_id,
    airport_ident,
    date             as comment_timestamp,
    member_nickname,
    subject          as comment_subject,
    body             as comment_body
from source
