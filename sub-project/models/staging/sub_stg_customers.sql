with source as (

    {#select * from {{ ref('sub_raw_customers') }}#}
    select * from {{ ref('raw_customers') }} 

), sub_source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ source('mySubProjectAliasedTest', 'testless') }}

), renamed as (

    select
        id as customer_id,
        s.first_name,
        s.last_name

    from source s
    left join sub_source s1 on s.first_name = s1.first_name

)

select * from renamed
