{% test my_not_null(model, column_name='abc') %}

    select *
    from {{ model }}
    where {{ column_name }} is null

{% endtest %}

{% test custom_singular_test(model, column_name='abc') %}

    select *
    from {{ model }}
    where {{ column_name }} is null

{% endtest %}