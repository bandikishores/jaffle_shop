{%- macro union_tables_by_prefix(database='jaffle_shop', schema='dbt_alice') -%}

  {%- set tables = dbt_utils.get_relations_by_prefix(database=database, schema=schema) -%}

  {% for table in tables %}

      {%- if not loop.first -%}
      union all 
      {%- endif %}
        {{ log('running') }}
      {% set query %}
        select * from {{ table.database }}.{{ table.schema }}.{{ table.name }} limit 1
      {% endset %}
      {{ log('Before running query ' ~ query, info = True)}}
      -- {% set results = run_query(query).columns[0].values()[0] %}
      {% set results = run_query(query) %}
      {{ log('SQL results ' ~ query ~ ' is ' ~ results, info = True)}}
      
  {% endfor -%}
  
{%- endmacro -%}