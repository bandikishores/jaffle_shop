
{% macro macro_setter() %}


{% set asdf = "sdf" ~ var("asdf","pipeline_default") %}

{% endmacro %}