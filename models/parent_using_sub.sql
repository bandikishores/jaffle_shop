with source as (

    select * from {{ ref('sub_stg_customers') }}

)

select * from source
