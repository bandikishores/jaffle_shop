{% macro create_udfs() %}

-- CREATE OR REPLACE PROCEDURE dbt_alice.insert_data(a integer, b integer)
-- LANGUAGE SQL
-- BEGIN ATOMIC
--   INSERT INTO dbt_alice.udf_support VALUES (a);
--   INSERT INTO dbt_alice.udf_support VALUES (b);
-- END;

{% endmacro %}