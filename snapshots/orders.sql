
{% snapshot orders_snapshot %}

{# This will create "jaffle_shop"."snapshots"."orders_snapshot" table #}

{{
    config(
      target_database='jaffle_shop',
      target_schema='snapshots',
      unique_key='order_id',

      strategy='timestamp',
      updated_at='order_date',
    )
}}

select * from {{ ref('orders') }} limit 10

{% endsnapshot %}

{#
{% snapshot orders_snapshot_1 %}

{{
    config(
      target_database='jaffle_shop',
      target_schema='snapshots',
      unique_key='order_id',

      strategy='timestamp',
      updated_at='order_date',
    )
}}

select * from {{ ref('orders') }}

{% endsnapshot %}
#}