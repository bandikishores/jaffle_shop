
{{ config({
        "materialized": "incremental",
        "unique_key": "order_id",
        "tags": ["orders_snapshots"],
        "alias": "orders"
    })
}}

{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

{% set payments_dict = {
    'credit':'card10',
    'bank':'transfer11'
} %}


with orders as (

    select * from {{ ref('stg_orders') }}

),
 my_orders as (

    select 
        * 
    from {{ source('myAliasedTest','testless') }} 

    {% if target.name == 'dev' %}
        limit 10
    {% else %}
        limit 100
    {% endif %}

),

payments as (

    select *,
    

        {% for payment_method in payments_dict -%}
            case when payment_method = '{{ payment_method }}' then amount else 0 end as {{ payments_dict[payment_method] }}_amount,
        {% endfor %}

        {{ cents_to_dollars('amount') }} as macro_amount

    from {{ ref('stg_payments') }}

),

{% set my_abc = 'abc' %}

order_payments as (

    select
        order_id,
        -- {{my_abc}},
        -- {{payment_methods}},
        -- {{ var('my_payment_methods') }},
        {% for payment_method in payment_methods -%}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}
        {% endfor -%}

        sum(amount) as total_amount

    from payments

    group by order_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        order_payments.total_amount as amount

    from orders


    left join order_payments
        on orders.order_id = order_payments.order_id

)

select * from final
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where order_date > (select max(order_date) from {{ this }})

{% endif %}