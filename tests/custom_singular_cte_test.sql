
{{ config({
        "tags": ["my_cte_test"]
    })
}}

WITH stg AS (
    select * from {{ ref('stg_payments') }}
)
select
    order_id,
    sum(amount) as total_amount
from stg
group by 1
having not(sum(amount) >= 0)