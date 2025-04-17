{% macro return_cols(col1,col2='dummycol') %}

  'id', 'first_name', {{col1}}, {{col2}}

{% endmacro %}