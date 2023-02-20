{% macro cents_to_dollars(column_name, 
decimal_places=2
) %}
round( 1.0 * {{ column_name }} / 100, {{decimal_places}} )
{% endmacro %}

{% macro cents_to_dollars1(column_name, decimal_places=2, abc=my_abc) %}
round( 1.0 * {{ column_name }} / 100, {{decimal_places}} )
{% endmacro %}

{% macro just_concat() %}
select * from dbt_alice.test limit 1
{% endmacro %}
