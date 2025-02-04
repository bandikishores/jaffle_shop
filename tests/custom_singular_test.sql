
{{ config({
        "tags": ["my_test_tag"]
    })
}}

select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_payments') }}
group by 1
having not(sum(amount) >= 0)