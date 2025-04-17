{# 

{% snapshot snowflake_orders_snapshot %}

-- This will create "KISHORE"."snapshots"."orders_snapshot" table

{{
    config(
      target_database='KISHORE',
      target_schema='snapshots',
      unique_key='order_id',

      strategy='timestamp',
      updated_at='order_date',
    )
}}

select * from {{ ref('orders') }} limit 10

{% endsnapshot %}
 #}