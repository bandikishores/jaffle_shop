{% macro grant_select(schema=target.schema, role=target.role) %}

  {{ log('Starting granting schema ' ~ target.schema ~ ' to role ' ~ role, info=True) }}
  {% set sql %}
  grant ALL on schema {{ schema }} to role {{ role }};
  -- GRANT ALL ON DATABASE jaffle_shop TO alice;
  {% endset %}

  {{ log('Granting select on all tables and views in schema ' ~ target.schema ~ ' to role ' ~ role ~ ' for sql' ~ sql, info=True) }}
  {% do run_query(sql) %}
  {{ log('Privileges granted', info=True) }}

{% endmacro %}