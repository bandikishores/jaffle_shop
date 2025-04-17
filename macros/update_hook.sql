
{%- macro update_hook() -%}select 1
{#update "jaffle_shop"."dbt_alice"."raw_customers" set a = 1#}
{%- endmacro -%}

