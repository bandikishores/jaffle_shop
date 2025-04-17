

{{ config({
        "materialized": "streaming_table"
    })
}}


select * from {{ ref('stg_orders') }}