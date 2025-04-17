{{ config(
    materialized = 'streaming_table',
) }}

select id, count(*) as cnt from {{ ref('base') }} group by id