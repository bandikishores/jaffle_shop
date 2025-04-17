{{
  config({    
    "materialized": "view"
  })
}}

{% set my_conf = "sdf" %}
{% set salary = 40 %}

WITH stg_orders AS (
  
  select * FROM {{ ref('stg_orders')}}

)

SELECT *

FROM stg_orders
