WITH src as (
    select * from {{ ref("test_something")}}
)
select * From src