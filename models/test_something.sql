{{
  config({    
    "materialized": "incremental",
    "incremental_predicates": ["DBT_INTERNAL_SOURCE.status <> DBT_INTERNAL_DEST.\"STATUS\""],
    "incremental_strategy": "merge",
    "unique_key": ["ORDER_ID"],
    "asdf": "sdf" ~ var("asdf","pipeline_default"),
    "basic": "random"
  })
}}

select * from  {{ ref("sub_raw_customers") }}

select * from {{source("myAliasedTest","testless")}}

{% set asdf = "sdf" ~ var("asdf","pipeline_default") %}

{{ var('struct').inner }}

{{ "sdf" ~ 1 }}
printing
{{ asdf }}
done


P1

P2

Model {p1}{p2}

printing nonexistentProjectConfig
{{ var('non_existent_config') }}
doneprinting

{% set my_conf = "sdf" %}
{% set salary = 40 %}

WITH stg_orders AS (


  SELECT {{var('drug_type')}}
  from tab
)

  SELECT *, {{return_cols()}}, {{return_cols('sdf')}}, {{return_cols(col1='abc', col2='sfgsfdg')}},
  {% if var('abc') not in (var('sd','ads'),var('sdg','as')) %}
      matched
  {% else %}
      nothing_matched
  {% endif %},
  {{var('var_conf')}},
  {{var('default_conf')}},
  {{my_conf}}

  {% if salary not in (10,30) %}
      saalary AS saalary
    {% endif %}

{% if 'EMAIL' == 'EMAIL' %}
      first_name AS first_name
    {% endif %}
    
    {% if var('abc')  is not none %}
      account_flags
    {% endif %},
    {{ test_case() }}
    {{ test_cAse() }}


    {% if var('abc')  not in ( var('default_conf') ) %}
      account_flags AS sdf
    {% else %}
      account_flags AS scv
    {% endif %}
  
  FROM {{ ref('stg_orders')}}

),
PERSONS AS (

  SELECT * 
  
  FROM {{ source('KISHORE.TEST', 'PERSONS') }}

)

SELECT *

FROM stg_orders
