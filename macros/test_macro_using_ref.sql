

{% macro test_macro_using_ref(model_name) %}
	{%- set ref_model = ref(model_name) -%}
	{%- set sql_with_limit = ref_model_sql + " LIMIT 0" -%}
	{%- set result = run_query(sql_with_limit) -%}

	{%- if result is not none -%}
		{%- set column_names = [] -%}
		{%- for column in result.column_names -%}
			{%- do column_names.append(column) -%}
		{%- endfor -%}
		{{ return(column_names | sort) }}
	{%- else -%}
		{{ return([]) }}
	{%- endif -%}
{%endmacro%}