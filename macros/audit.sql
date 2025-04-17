{% macro audit(results) %}
    {% do log("Audit called with " ~ results, true) %}    
    {{ upload_results(results) }}
{% endmacro %}

{% macro upload_model_executions(models) -%}
    {% do log("default__get_model_executions_dml_sql called with " ~ return(adapter.dispatch('column_identifier')(1)), true) %}   
    {% do log("default__get_model_executions_dml_sql called with " ~ return(adapter.dispatch('column_identifier')(2)), true) %}   
    {{ return(adapter.dispatch('get_model_executions_dml_sql', 'jaffle_shop')(models)) }}
{%- endmacro %}

{% macro default__get_model_executions_dml_sql(models) -%}
    {% if models != [] %}
    
        {% set model_execution_values %}
        select
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(1) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(2) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(3) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(4) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(5) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(6) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(7) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(8) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(9) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(10) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(11) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(12) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(13) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(14) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(15) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(16)) }}

        from values
        {% for model in models -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                '{{ config_full_refresh }}', {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, -- rows_affected not available {# Only available in Snowflake & BigQuery #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}', {# message #}
                '{{ tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}' {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ model_execution_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro bigquery__get_model_executions_dml_sql(models) -%}
    {% if models != [] %}
        {% set model_execution_values %}
        {% for model in models -%}
            (
            '{{ invocation_id }}', {# command_invocation_id #}
            '{{ model.node.unique_id }}', {# node_id #}
            '{{ run_started_at }}', {# run_started_at #}

            {% set config_full_refresh = model.node.config.full_refresh %}
            {% if config_full_refresh is none %}
                {% set config_full_refresh = flags.FULL_REFRESH %}
            {% endif %}
            {{ config_full_refresh }}, {# was_full_refresh #}

            '{{ model.thread_id }}', {# thread_id #}
            '{{ model.status }}', {# status #}

            {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
            {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
            {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
            {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

            {{ model.execution_time }}, {# total_node_runtime #}
            safe_cast('{{ model.adapter_response.rows_affected }}' as int64),
            safe_cast('{{ model.adapter_response.bytes_processed }}' as int64),
            '{{ model.node.config.materialized }}', {# materialization #}
            '{{ model.node.schema }}', {# schema #}
            '{{ model.node.name }}', {# name #}
            '{{ model.node.alias }}', {# alias #}
            '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') | replace("\n", "\\n") }}', {# message #}
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"')) }} {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ model_execution_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro snowflake__get_model_executions_dml_sql(models) -%}
    {% if models != [] %}
        {% set model_execution_values %}
        select
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(1) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(2) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(3) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(4) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(5) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(6) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(7) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(8) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(9) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(10) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(11) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(12) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(13) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(14) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(15) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(16)) }}
        from values
        {% for model in models -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                '{{ config_full_refresh }}', {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                try_cast('{{ model.adapter_response.rows_affected }}' as int), {# rows_affected #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}', {# message #}
                '{{ tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}' {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ model_execution_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro postgres__get_model_executions_dml_sql(models) -%}
    {% if models != [] %}
        {% set model_execution_values %}
        {% for model in models -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                {{ config_full_refresh }}, {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, {# rows_affected #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                $${{ model.message }}$$, {# message #}
                $${{ tojson(model.adapter_response) }}$$ {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ model_execution_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}


{# dbt doesn't like us ref'ing in an operation so we fetch the info from the graph #}

{% macro upload_results(results) -%}

    {% if execute %}

        {% set datasets_to_load = ['exposures', 'seeds', 'snapshots', 'invocations', 'sources', 'tests', 'models'] %}
        {% if results != [] %}
            {# When executing, and results are available, then upload the results #}
            {% set datasets_to_load = ['model_executions', 'seed_executions', 'test_executions', 'snapshot_executions'] + datasets_to_load %}
        {% endif %}

        {# Upload each data set in turn #}
        {% for dataset in datasets_to_load %}

            {% do log("Uploading " ~ dataset.replace("_", " "), true) %}

            {# Get the results that need to be uploaded #}
            {% set objects = jaffle_shop.get_dataset_content(dataset) %}

            {# Upload in chunks to reduce the query size #}
            {% if dataset == 'models' %}
                {% set upload_limit = 50 if target.type == 'bigquery' else 100 %}
            {% else %}
                {% set upload_limit = 300 if target.type == 'bigquery' else 5000 %}
            {% endif %}

            {# Loop through each chunk in turn #}
            {% for i in range(0, objects | length, upload_limit) -%}

                {# Get just the objects to load on this loop #}
                {% set content = jaffle_shop.get_table_content_values(dataset, objects[i: i + upload_limit]) %}

                {# Insert the content into the metadata table #}
                {#
                {{ jaffle_shop.insert_into_metadata_table(
                    dataset=dataset,
                    fields=jaffle_shop.get_column_name_list(dataset),
                    content=content
                    )
                }}
                #}



                {% do log("Final inserting data " ~ dataset ~ " fields " ~ jaffle_shop.get_column_name_list(dataset) ~ " content " ~ content, true) %}

            {# Loop the next 'chunk' #}
            {% endfor %}

        {# Loop the next 'dataset' #}
        {% endfor %}

    {% endif %}

{%- endmacro %}

{% macro get_dataset_content(dataset) %}

    {% if dataset in ['model_executions', 'seed_executions', 'test_executions', 'snapshot_executions'] %}
        {# Executions make use of the results object #}
        {% set objects = results | selectattr("node.resource_type", "equalto", dataset.split("_")[0]) | list %}
    {% elif dataset in ['seeds', 'snapshots', 'tests', 'models'] %}
        {# Use the nodes in the [graph](https://docs.getdbt.com/reference/dbt-jinja-functions/graph) to extract details #}
        {% set objects = graph.nodes.values() | selectattr("resource_type", "equalto", dataset[:-1]) | list %}
    {% elif dataset in ['exposures', 'sources'] %}
        {# Use the [graph](https://docs.getdbt.com/reference/dbt-jinja-functions/graph) to extract details #}
        {% set objects = graph.get(dataset).values() | list %}
    {% elif dataset == 'invocations' %}
        {#
            Invocations doesn't need anything input, but we include this so that it will still be picked up
            as part of the loop below - the length must be >0 to allow for an upload, hence the empty string
        #}
        {% set objects = [''] %}
    {% endif %}

    {{ return(objects) }}

{% endmacro %}

{% macro column_identifier(column_index) -%}
  {{ return(adapter.dispatch('column_identifier')(column_index)) }}
{%- endmacro %}

{% macro default__column_identifier(column_index) -%}
    {{ column_index }}
{%- endmacro %}

{% macro snowflake__column_identifier(column_index) -%}
    ${{ column_index }}
{%- endmacro %}

{% macro spark__column_identifier(column_index) -%}
    col{{ column_index }}
{%- endmacro %}

{% macro parse_json(field) -%}
  {{ return(adapter.dispatch('parse_json')(field)) }}
{%- endmacro %}

{% macro default__parse_json(field) -%}
    {{ field }}
{%- endmacro %}

{% macro snowflake__parse_json(field) -%}
    parse_json({{ field }})
{%- endmacro %}

{% macro bigquery__parse_json(field) -%}
    safe.parse_json("""{{ field }}""", wide_number_mode=>'round')
{%- endmacro %}

{% macro get_table_content_values(dataset, objects_to_upload) %}

    {# Convert the results to data to be imported #}

    {% if dataset == 'model_executions' %}
        {% set content = jaffle_shop.upload_model_executions(objects_to_upload) %}
    {% elif dataset == 'seed_executions' %}
        {% set content = "jaffle_shop.upload_seed_executions(objects_to_upload)" %}
    {% elif dataset == 'test_executions' %}
        {% set content = "jaffle_shop.upload_test_executions(objects_to_upload)" %}
    {% elif dataset == 'snapshot_executions' %}
        {% set content = "jaffle_shop.upload_snapshot_executions(objects_to_upload)" %}
    {% elif dataset == 'exposures' %}
        {% set content = jaffle_shop.upload_exposures(objects_to_upload) %}
    {% elif dataset == 'models' %}
        {% set content = jaffle_shop.upload_models(objects_to_upload) %}
    {% elif dataset == 'seeds' %}
        {% set content = "jaffle_shop.upload_seeds(objects_to_upload)" %}
    {% elif dataset == 'snapshots' %}
        {% set content = "jaffle_shop.upload_snapshots(objects_to_upload)" %}
    {% elif dataset == 'sources' %}
        {% set content = "jaffle_shop.upload_sources(objects_to_upload)" %}
    {% elif dataset == 'tests' %}
        {% set content = "jaffle_shop.upload_tests(objects_to_upload)" %}
    {# Invocations only requires data from variables available in the macro #}
    {% elif dataset == 'invocations' %}
        {% set content = jaffle_shop.upload_invocations() %}
    {% endif %}

    {{ return(content) }}

{% endmacro %}


{% macro upload_models(models) -%}
    {% do log("get_models_dml_sql called with ", true) %}  
    {% set content = adapter.dispatch('column_identifier', 'jaffle_shop')(1) %}
    {% do log("get_models_dml_sql called with " ~ content, true) %}  
    {% do log(return(adapter.dispatch('column_identifier')(2)), true) %}  
    {{ return(adapter.dispatch('get_models_dml_sql', 'jaffle_shop')(models)) }}
{%- endmacro %}

{% macro default__get_models_dml_sql(models) -%}

    {% if models != [] %}
        {% set model_values %}
        select
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(1) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(2) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(3) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(4) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(5) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(6) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(7)) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(8) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(9) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(10) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(11) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(12)) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(13)) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(14) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(15)) }}
        from values
        {% for model in models -%}
                {% set model_copy = model.copy() -%}
                {% do model_copy.pop('raw_code', None) %}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model_copy.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}
                '{{ model_copy.database }}', {# database #}
                '{{ model_copy.schema }}', {# schema #}
                '{{ model_copy.name }}', {# name #}
                '{{ tojson(model_copy.depends_on.nodes) | replace('\\', '\\\\') }}', {# depends_on_nodes #}
                '{{ model_copy.package_name }}', {# package_name #}
                '{{ model_copy.original_file_path | replace('\\', '\\\\') }}', {# path #}
                '{{ model_copy.checksum.checksum  | replace('\\', '\\\\') }}', {# checksum #}
                '{{ model_copy.config.materialized }}', {# materialization #}
                '{{ tojson(model_copy.tags) }}', {# tags #}
                '{{ tojson(model_copy.config.meta) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"') }}', {# meta #}
                '{{ model_copy.alias }}', {# alias #}
                {% if var('jaffle_shop_exclude_all_results', false) %}
                    null
                {% else %}
                    '{{ tojson(model_copy) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"') }}' {# all_results #}
                {% endif %}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ model_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro bigquery__get_models_dml_sql(models) -%}
    {% if models != [] %}
        {% set model_values %}
            {% for model in models -%}
                {% set model_copy = model.copy() -%}
                {% do model_copy.pop('raw_code', None) %}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    '{{ model_copy.unique_id }}', {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    '{{ model_copy.database }}', {# database #}
                    '{{ model_copy.schema }}', {# schema #}
                    '{{ model_copy.name }}', {# name #}
                    {{ tojson(model_copy.depends_on.nodes) }}, {# depends_on_nodes #}
                    '{{ model_copy.package_name }}', {# package_name #}
                    '{{ model_copy.original_file_path | replace('\\', '\\\\') }}', {# path #}
                    '{{ model_copy.checksum.checksum | replace('\\', '\\\\') }}', {# checksum #}
                    '{{ model_copy.config.materialized }}', {# materialization #}
                    {{ tojson(model_copy.tags) }}, {# tags #}
                    {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(model_copy.config.meta)) }}, {# meta #}
                    '{{ model_copy.alias }}', {# alias #}
                    {% if var('jaffle_shop_exclude_all_results', false) %}
                        null
                    {% else %}
                        {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(model_copy) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"')) }} {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ model_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro postgres__get_models_dml_sql(models) -%}
    {% if models != [] %}
        {% set model_values %}
            {% for model in models -%}
                {% set model_copy = model.copy() -%}
                {% do model_copy.pop('raw_code', None) %}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    '{{ model_copy.unique_id }}', {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    '{{ model_copy.database }}', {# database #}
                    '{{ model_copy.schema }}', {# schema #}
                    '{{ model_copy.name }}', {# name #}
                    '{{ tojson(model_copy.depends_on.nodes) }}', {# depends_on_nodes #}
                    '{{ model_copy.package_name }}', {# package_name #}
                    $${{ model_copy.original_file_path | replace('\\', '\\\\') }}$$, {# path #}
                    '{{ model_copy.checksum.checksum }}', {# checksum #}
                    '{{ model_copy.config.materialized }}', {# materialization #}
                    '{{ tojson(model_copy.tags) }}', {# tags #}
                    $${{ model_copy.config.meta }}$$, {# meta #}
                    '{{ model_copy.alias }}', {# alias #}
                    {% if var('jaffle_shop_exclude_all_results', false) %}
                        null
                    {% else %}
                        $${{ tojson(model_copy) }}$$ {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ model_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}


{% macro upload_exposures(exposures) -%}
    {{ return(adapter.dispatch('get_exposures_dml_sql', 'jaffle_shop')(exposures)) }}
{%- endmacro %}

{% macro default__get_exposures_dml_sql(exposures) -%}

    {% if exposures != [] %}
        {% set exposure_values %}
        select
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(1) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(2) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(3) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(4) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(5) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(6)) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(7) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(8) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(9) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(10) }},
            {{ adapter.dispatch('column_identifier', 'jaffle_shop')(11) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(12)) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(13)) }},
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(14)) }}
        from values
        {% for exposure in exposures -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ exposure.unique_id | replace("'","\\'") }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}
                '{{ exposure.name | replace("'","\\'") }}', {# name #}
                '{{ exposure.type }}', {# type #}
                '{{ tojson(exposure.owner) }}', {# owner #}
                '{{ exposure.maturity }}', {# maturity #}
                '{{ exposure.original_file_path | replace('\\', '\\\\') }}', {# path #}
                '{{ exposure.description | replace("'","\\'") }}', {# description #}
                '{{ exposure.url }}', {# url #}
                '{{ exposure.package_name }}', {# package_name #}
                '{{ tojson(exposure.depends_on.nodes) }}', {# depends_on_nodes #}
                '{{ tojson(exposure.tags) }}', {# tags #}
                {% if var('jaffle_shop_exclude_all_results', false) %}
                    null
                {% else %}
                    '{{ tojson(exposure) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}' {# all_results #}
                {% endif %}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ exposure_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro bigquery__get_exposures_dml_sql(exposures) -%}
    {% if exposures != [] %}
        {% set exposure_values %}
            {% for exposure in exposures -%}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    '{{ exposure.unique_id | replace("'","\\'") }}', {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    '{{ exposure.name | replace("'","\\'") }}', {# name #}
                    '{{ exposure.type }}', {# type #}
                    {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(exposure.owner) | replace("'","\\'")) }}, {# owner #}
                    '{{ exposure.maturity }}', {# maturity #}
                    '{{ exposure.original_file_path | replace('\\', '\\\\') }}', {# path #}
                    """{{ exposure.description | replace("'","\\'") }}""", {# description #}
                    '{{ exposure.url }}', {# url #}
                    '{{ exposure.package_name }}', {# package_name #}
                    {{ tojson(exposure.depends_on.nodes) }}, {# depends_on_nodes #}
                    {{ tojson(exposure.tags) }}, {# tags #}
                    {% if var('jaffle_shop_exclude_all_results', false) %}
                        null
                    {% else %}
                        {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(exposure) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"')) }} {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ exposure_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro postgres__get_exposures_dml_sql(exposures) -%}
    {% if exposures != [] %}

        {% set exposure_values %}
            {% for exposure in exposures -%}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    $${{ exposure.unique_id }}$$, {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    $${{ exposure.name }}$$, {# name #}
                    '{{ exposure.type }}', {# type #}
                    $${{ tojson(exposure.owner) }}$$, {# owner #}
                    '{{ exposure.maturity }}', {# maturity #}
                    $${{ exposure.original_file_path }}$$, {# path #}
                    $${{ exposure.description }}$$, {# description #}
                    '{{ exposure.url }}', {# url #}
                    '{{ exposure.package_name }}', {# package_name #}
                    $${{ tojson(exposure.depends_on.nodes) }}$$, {# depends_on_nodes #}
                    $${{ tojson(exposure.tags) }}$$, {# tags #}
                    {% if var('jaffle_shop_exclude_all_results', false) %}
                        null
                    {% else %}
                        $${{ tojson(exposure) }}$$ {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ exposure_values }}
    {% else %}
        {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro upload_invocations() -%}

    {# Need to remove keys with results that can't be handled properly #}
    {# warn_error_options - returns a python object in 1.5 #}
    {% if 'warn_error_options' in invocation_args_dict %}
        {% if invocation_args_dict.warn_error_options is not string %}
            {% if invocation_args_dict.warn_error_options.include %}
                {% set include_options = invocation_args_dict.warn_error_options.include %}
            {% else %}
                {% set include_options = '' %}
            {% endif %}
            {% if invocation_args_dict.warn_error_options.exclude %}
                {% set exclude_options = invocation_args_dict.warn_error_options.exclude %}
            {% else %}
                {% set exclude_options = '' %}
            {% endif %}
            {% set warn_error_options = {'include': include_options, 'exclude': exclude_options} %}
            {%- do invocation_args_dict.update({'warn_error_options': warn_error_options}) %}
        {% endif %}
    {% endif %}

    {{ return(adapter.dispatch('get_invocations_dml_sql', 'jaffle_shop')()) }}
{%- endmacro %}

{% macro default__get_invocations_dml_sql() -%}
    {% set invocation_values %}
    select
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(1) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(2) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(3) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(4) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(5) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(6) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(7) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(8) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(9) }},
        {{ adapter.dispatch('column_identifier', 'jaffle_shop')(10) }},
        nullif({{ adapter.dispatch('column_identifier', 'jaffle_shop')(11) }}, ''),
        nullif({{ adapter.dispatch('column_identifier', 'jaffle_shop')(12) }}, ''),
        nullif({{ adapter.dispatch('column_identifier', 'jaffle_shop')(13) }}, ''),
        nullif({{ adapter.dispatch('column_identifier', 'jaffle_shop')(14) }}, ''),
        nullif({{ adapter.dispatch('column_identifier', 'jaffle_shop')(15) }}, ''),
        {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(16)) }},
        {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(17)) }},
        {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(18)) }},
        {{ adapter.dispatch('parse_json', 'jaffle_shop')(adapter.dispatch('column_identifier', 'jaffle_shop')(19)) }}
    from values
    (
        '{{ invocation_id }}', {# command_invocation_id #}
        '{{ dbt_version }}', {# dbt_version #}
        '{{ project_name }}', {# project_name #}
        '{{ run_started_at }}', {# run_started_at #}
        '{{ flags.WHICH }}', {# dbt_command #}
        '{{ flags.FULL_REFRESH }}', {# full_refresh_flag #}
        '{{ target.profile_name }}', {# target_profile_name #}
        '{{ target.name }}', {# target_name #}
        '{{ target.schema }}', {# target_schema #}
        {{ target.threads }}, {# target_threads #}

        '{{ env_var('DBT_CLOUD_PROJECT_ID', '') }}', {# dbt_cloud_project_id #}
        '{{ env_var('DBT_CLOUD_JOB_ID', '') }}', {# dbt_cloud_job_id #}
        '{{ env_var('DBT_CLOUD_RUN_ID', '') }}', {# dbt_cloud_run_id #}
        '{{ env_var('DBT_CLOUD_RUN_REASON_CATEGORY', '') }}', {# dbt_cloud_run_reason_category #}
        '{{ env_var('DBT_CLOUD_RUN_REASON', '') | replace("'","\\'") }}', {# dbt_cloud_run_reason #}

        {% if var('env_vars', none) %}
            {% set env_vars_dict = {} %}
            {% for env_variable in var('env_vars') %}
                {% do env_vars_dict.update({env_variable: (env_var(env_variable, '') | replace("'", "''"))}) %}
            {% endfor %}
            '{{ tojson(env_vars_dict) }}', {# env_vars #}
        {% else %}
            null, {# env_vars #}
        {% endif %}

        {% if var('dbt_vars', none) %}
            {% set dbt_vars_dict = {} %}
            {% for dbt_var in var('dbt_vars') %}
                {% do dbt_vars_dict.update({dbt_var: (var(dbt_var, '') | replace("'", "''"))}) %}
            {% endfor %}
            '{{ tojson(dbt_vars_dict) }}', {# dbt_vars #}
        {% else %}
            null, {# dbt_vars #}
        {% endif %}

        '{{ tojson(invocation_args_dict) | replace('\\', '\\\\') | replace("'", "\\'") }}', {# invocation_args #}

        {% set metadata_env = {} %}
        {% for key, value in dbt_metadata_envs.items() %}
            {% do metadata_env.update({key: (value | replace("'", "''"))}) %}
        {% endfor %}
        '{{ tojson(metadata_env) | replace('\\', '\\\\') }}' {# dbt_custom_envs #}

    )
    {% endset %}
    {{ invocation_values }}

{% endmacro -%}

{% macro bigquery__get_invocations_dml_sql() -%}
    {% set invocation_values %}
        (
        '{{ invocation_id }}', {# command_invocation_id #}
        '{{ dbt_version }}', {# dbt_version #}
        '{{ project_name }}', {# project_name #}
        '{{ run_started_at }}', {# run_started_at #}
        '{{ flags.WHICH }}', {# dbt_command #}
        {{ flags.FULL_REFRESH }}, {# full_refresh_flag #}
        '{{ target.profile_name }}', {# target_profile_name #}
        '{{ target.name }}', {# target_name #}
        '{{ target.schema }}', {# target_schema #}
        {{ target.threads }}, {# target_threads #}

        '{{ env_var('DBT_CLOUD_PROJECT_ID', '') }}', {# dbt_cloud_project_id #}
        '{{ env_var('DBT_CLOUD_JOB_ID', '') }}', {# dbt_cloud_job_id #}
        '{{ env_var('DBT_CLOUD_RUN_ID', '') }}', {# dbt_cloud_run_id #}
        '{{ env_var('DBT_CLOUD_RUN_REASON_CATEGORY', '') }}', {# dbt_cloud_run_reason_category #}
        '{{ env_var('DBT_CLOUD_RUN_REASON', '') | replace("'","\\'") }}', {# dbt_cloud_run_reason #}

        {% if var('env_vars', none) %}
            {% set env_vars_dict = {} %}
            {% for env_variable in var('env_vars') %}
                {% do env_vars_dict.update({env_variable: (env_var(env_variable, ''))}) %}
            {% endfor %}
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(env_vars_dict)) }}, {# env_vars #}
        {% else %}
            null, {# env_vars #}
        {% endif %}

        {% if var('dbt_vars', none) %}
            {% set dbt_vars_dict = {} %}
            {% for dbt_var in var('dbt_vars') %}
                {% do dbt_vars_dict.update({dbt_var: (var(dbt_var, ''))}) %}
            {% endfor %}
            {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(dbt_vars_dict)) }}, {# dbt_vars #}
        {% else %}
            null, {# dbt_vars #}
        {% endif %}

        {% if invocation_args_dict.vars %}
            {# vars - different format for pre v1.5 (yaml vs list) #}
            {% if invocation_args_dict.vars is string %}
                {# BigQuery does not handle the yaml-string from "--vars" well, when passed to "parse_json". Workaround is to parse the string, and then "tojson" will properly format the dict as a json-object. #}
                {% set parsed_inv_args_vars = fromyaml(invocation_args_dict.vars) %}
                {% do invocation_args_dict.update({'vars': parsed_inv_args_vars}) %}
            {% endif %}
        {% endif %}

        {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(invocation_args_dict) | replace("'", "\\'")) }}, {# invocation_args #}

        {% set metadata_env = {} %}
        {% for key, value in dbt_metadata_envs.items() %}
            {% do metadata_env.update({key: value}) %}
        {% endfor %}
        {{ adapter.dispatch('parse_json', 'jaffle_shop')(tojson(metadata_env) | replace('\\', '\\\\')) }} {# dbt_custom_envs #}

        )
    {% endset %}
    {{ invocation_values }}

{% endmacro -%}

{% macro postgres__get_invocations_dml_sql() -%}
    {% set invocation_values %}
        (
            '{{ invocation_id }}', {# command_invocation_id #}
            '{{ dbt_version }}', {# dbt_version #}
            '{{ project_name }}', {# project_name #}
            '{{ run_started_at }}', {# run_started_at #}
            '{{ flags.WHICH }}', {# dbt_command #}
            {{ flags.FULL_REFRESH }}, {# full_refresh_flag #}
            '{{ target.profile_name }}', {# target_profile_name #}
            '{{ target.name }}', {# target_name #}
            '{{ target.schema }}', {# target_schema #}
            {{ target.threads }}, {# target_threads #}

            '{{ env_var("DBT_CLOUD_PROJECT_ID", "") }}', {# dbt_cloud_project_id #}
            '{{ env_var("DBT_CLOUD_JOB_ID", "") }}', {# dbt_cloud_job_id #}
            '{{ env_var("DBT_CLOUD_RUN_ID", "") }}', {# dbt_cloud_run_id #}
            '{{ env_var("DBT_CLOUD_RUN_REASON_CATEGORY", "") }}', {# dbt_cloud_run_reason_category #}
            $${{ env_var('DBT_CLOUD_RUN_REASON', '') }}$$, {# dbt_cloud_run_reason #}

            {% if var('env_vars', none) %}
                {% set env_vars_dict = {} %}
                {% for env_variable in var('env_vars') %}
                    {% do env_vars_dict.update({env_variable: (env_var(env_variable, ''))}) %}
                {% endfor %}
                $${{ tojson(env_vars_dict) }}$$, {# env_vars #}
            {% else %}
                null, {# env_vars #}
            {% endif %}

            {% if var('dbt_vars', none) %}
                {% set dbt_vars_dict = {} %}
                {% for dbt_var in var('dbt_vars') %}
                    {% do dbt_vars_dict.update({dbt_var: (var(dbt_var, ''))}) %}
                {% endfor %}
                $${{ tojson(dbt_vars_dict) }}$$, {# dbt_vars #}
            {% else %}
                null, {# dbt_vars #}
            {% endif %}

            {% if invocation_args_dict.vars %}
                {# vars - different format for pre v1.5 (yaml vs list) #}
                {% if invocation_args_dict.vars is string %}
                    {# BigQuery does not handle the yaml-string from "--vars" well, when passed to "parse_json". Workaround is to parse the string, and then "tojson" will properly format the dict as a json-object. #}
                    {% set parsed_inv_args_vars = fromyaml(invocation_args_dict.vars) %}
                    {% do invocation_args_dict.update({'vars': parsed_inv_args_vars}) %}
                {% endif %}
            {% endif %}

            $${{ tojson(invocation_args_dict) }}$$, {# invocation_args #}

            {% set metadata_env = {} %}
            {% for key, value in dbt_metadata_envs.items() %}
                {% do metadata_env.update({key: value}) %}
            {% endfor %}
            $${{ tojson(metadata_env) }}$$ {# dbt_custom_envs #}
        )
    {% endset %}
    {{ invocation_values }}

{% endmacro -%}


{#
    These are the column lists used as part of the upload macros - the order here should be the same
    as the order in each individual `upload_dataset` macro.
#}

{% macro get_column_name_list(dataset) -%}

    {% if dataset == 'exposures' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            name,
            type,
            owner,
            maturity,
            path,
            description,
            url,
            package_name,
            depends_on_nodes,
            tags,
            all_results
        )

    {% elif dataset == 'invocations' %}

        (
            command_invocation_id,
            dbt_version,
            project_name,
            run_started_at,
            dbt_command,
            full_refresh_flag,
            target_profile_name,
            target_name,
            target_schema,
            target_threads,
            dbt_cloud_project_id,
            dbt_cloud_job_id,
            dbt_cloud_run_id,
            dbt_cloud_run_reason_category,
            dbt_cloud_run_reason,
            env_vars,
            dbt_vars,
            invocation_args,
            dbt_custom_envs
        )

    {% elif dataset == 'model_executions' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected,
            {% if target.type == 'bigquery' %}
                bytes_processed,
            {% endif %}
            materialization,
            schema,
            name,
            alias,
            message,
            adapter_response
        )

    {% elif dataset == 'models' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            database,
            schema,
            name,
            depends_on_nodes,
            package_name,
            path,
            checksum,
            materialization,
            tags,
            meta,
            alias,
            all_results
        )


    {% elif dataset == 'seed_executions' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected,
            materialization,
            schema,
            name,
            alias,
            message,
            adapter_response
        )

    {% elif dataset == 'seeds' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            database,
            schema,
            name,
            package_name,
            path,
            checksum,
            meta,
            alias,
            all_results
        )

    {% elif dataset == 'snapshot_executions' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected,
            materialization,
            schema,
            name,
            alias,
            message,
            adapter_response
        )

    {% elif dataset == 'snapshots' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            database,
            schema,
            name,
            depends_on_nodes,
            package_name,
            path,
            checksum,
            strategy,
            meta,
            alias,
            all_results
        )

    {% elif dataset == 'sources' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            database,
            schema,
            source_name,
            loader,
            name,
            identifier,
            loaded_at_field,
            freshness,
            all_results
        )

    {% elif dataset == 'test_executions' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected,
            failures,
            message,
            adapter_response
        )

    {% elif dataset == 'tests' %}

        (
            command_invocation_id,
            node_id,
            run_started_at,
            name,
            depends_on_nodes,
            package_name,
            test_path,
            tags,
            all_results
        )

    {% else %}

        /* No column list available */

    {% endif %}

{%- endmacro %}