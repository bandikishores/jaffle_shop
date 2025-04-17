import snowflake.snowpark.functions as F

import snowflake.snowpark.types as T
import snowflake.snowpark.functions as F
import numpy

def register_udf_add_random():
    add_random = F.udf(
        # use 'lambda' syntax, for simple functional behavior
        lambda x: x + numpy.random.normal(),
        return_type=T.FloatType(),
        input_types=[T.IntegerType()]
    )
    return add_random

def add_one(x):
    return x + 1

def send_http(dbt, session, customer_id):
    import requests

    url = 'https://app.prophecy.io/api/md/graphql'
    headers = {
        'Accept-Language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
        'Cookie': 'accept-prophecy-cookies=true; _uetvid=893ae570b72211edb215dbb0fd2f02c5; _fbp=fb.1.1725898078944.228799868971057592; _ga_KZFTSKGR76=deleted; prophecy-session=a9f0ead0-6477-4092-ab0c-67f7594c8d35; _gid=GA1.2.1773736539.1732076432; fs_uid=#o-1HYGPZ-na1#d8cf23ea-9454-4307-ab74-301514e7c032:c9f4e327-affd-4439-9758-22458daccc28:1732088960010::1#/1757434137; __q_state_K15YXsxGRU2PqcHL=eyJ1dWlkIjoiNTA4YjZkN2ItYjc4YS00YWI0LWJjZDUtZjA5MGMwMjFiNTFkIiwiY29va2llRG9tYWluIjoicHJvcGhlY3kuaW8iLCJhY3RpdmVTZXNzaW9uSWQiOm51bGwsIm1lc3NlbmdlckV4cGFuZGVkIjpmYWxzZSwicHJvbXB0RGlzbWlzc2VkIjpmYWxzZSwic3RhdGVCeVNjcmlwdElkIjp7IjE0NTcyNDYyNDkxMTUyMDY2NzUiOnsiZGlzbWlzc2VkIjpmYWxzZSwic2Vzc2lvbklkIjpudWxsfSwiMTQ3OTg1MjkzNTU1MjI0Njc5NiI6eyJkaXNtaXNzZWQiOmZhbHNlLCJzZXNzaW9uSWQiOm51bGx9LCIxNDk5NjU2MDE2MzUyMjI0Mjk3Ijp7ImRpc21pc3NlZCI6ZmFsc2UsInNlc3Npb25JZCI6bnVsbH0sIjE1MDA0MzIxODM4MzI2MDk4MDkiOnsiZGlzbWlzc2VkIjpudWxsLCJzZXNzaW9uSWQiOm51bGx9LCIxNTAyNTI4MDAyMzM0MzE5NjQyIjp7ImRpc21pc3NlZCI6ZmFsc2UsInNlc3Npb25JZCI6bnVsbH0sIjE1MDI1MjgwMDIxNDk2ODAxNTMiOnsiZGlzbWlzc2VkIjpmYWxzZSwic2Vzc2lvbklkIjpudWxsfX0sImNvbnZlcnNhdGlvbklkIjoiMTUzMDQ3MDEwMTg0MDgzOTY5NCIsInNjcmlwdElkIjoiMTUwMjUyODAwMjMzNDMxOTY0MiJ9; _gcl_au=1.1.2142465697.1725898079.805550118.1732088966.1732088973; _clck=1ptuv38%7C2%7Cfr2%7C0%7C1713; _rdt_uuid=1725898079105.b7a8ead1-e9b1-4d5b-9d5e-c7a9e15fd6d4; _ga=GA1.1.857597996.1725898079; _uetsid=c82bf2f0a6f611efb2f33577ce190f65; _ga_D1NBL7L7NH=GS1.2.1732186397.50.0.1732186397.60.0.0; _clsk=essqf%7C1732186398575%7C1%7C1%7Co.clarity.ms%2Fcollect; _ga_KZFTSKGR76=GS1.1.1732201263.41.0.1732201263.0.0.0; prophecy-token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxLU1cL1NwSjNWZjQ1THY5MVdMdFBzY0JOSUhwUktrR3RQc0VPY1ZFN3VpMXNtWkxRZEhJeHZLT2pLRnB4WUZVQVwvWGJhRDhCZFZuSkRSVmFjdzFWTXVFWDQ4UitDK3QrRm5INHgzNDRiV2FYVlE9IiwiaXNzIjoiYXBwX3NhYXMiLCJleHAiOjE3NDYzNDEzNzMsImlhdCI6MTczMjIwNTM0NCwianRpIjoiY2U3Njk2NzlmNjEyYjY2M2VmOGI1OTE0ZjAzNWUyYjU4NjdhMmExZWFhZmQ3M2QyNzJjZDVhYTlmYjg0OTNjYzU2NzdiMmU1YWM3ZGRmNDhmYTk5M2JkNTU5OGQ4ZTAwZjBlMTliZDg2MWUyNTczYjcwMjQ5MmI1NWQ4ODEzYTBlYjljMzNjZGMxYjM1ZWJjZTVmZTIwMjRjZDMyMDc4YzFlZTNhODljNWNhZjcyOTVhYzdjMDVhYzViM2MxOTM4ODUwMDUxMmQxMWE1YmI5NmJlODhhY2I5OGU3N2IwNWRkZDBiMmFkMzFiNGRmYTk2MjllODVlNjYwNDZjYjdjZCJ9.2VG-BiVElpm3triEFDfheUu05GrvfCCeU3Y3J-5HOvY; mp_c1bf58f29206c58a3cfb97ec539d7635_mixpanel=%7B%22distinct_id%22%3A%20%22support%40prophecy.io%22%2C%22%24device_id%22%3A%20%22188d464685410c3-0ec0c8cd30fe14-1b525634-384000-188d4646855d47%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fuitesting.prophecy.io%2Fmetadata%2Fentity%2Ffabrics%2F5287%2Fproviders%22%2C%22%24initial_referring_domain%22%3A%20%22uitesting.prophecy.io%22%2C%22session_id%22%3A%20%22prophecy-050vfIpMaK%22%2C%22user_type%22%3A%20%22support%40prophecy.io%22%2C%22%24user_id%22%3A%20%22support%40prophecy.io%22%7D',
        'Origin': 'https://app.prophecy.io',
        'Referer': 'https://app.prophecy.io/metadata/sql/30906?entity=model&name=testModel1',
        'Sec-Fetch-Dest': 'empty',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
        'accept': 'application/json;',
        'csrf-token': 'GUut8oMbtIpVqj9xfOzChyEvdqdTpmMcNRbTMdFgrwY=',
        'sec-ch-ua': '"Chromium";v="130", "Google Chrome";v="130", "Not?A_Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
    }

    data = {
        "query": "query ($teamUID: String!) {\n  Team(uid: $teamUID) {\n    copilotDataSamplingEnabled\n  }\n}\n",
        "variables": {
            "teamUID": "1782"
        }
    }

    response = requests.post(url, headers=headers, json=data)
    
    import datetime
    session.sql(f"""
            INSERT INTO debug_logs (log_time, message)
            VALUES ('{datetime.datetime.now()}', '{customer_id} - Response from HTTP {response.text}')
        """).collect()


def model(dbt, session):

    # setting configuration
    dbt.config(
        materialized="table",
        packages = ["numpy", "holidays","requests"],
        external_access_integrations=["appprophecyai"],
    )

    # DataFrame representing an upstream model
    upstream_model = dbt.ref("test_snowflake").limit(1)

    if dbt.is_incremental:

        # only new rows compared to max in current table
        max_from_this = f"select max(updated_at) from {dbt.this}"
        df = df.filter(df.updated_at >= session.sql(max_from_this).collect()[0][0])

        # or only rows from the past 3 days
        df = df.filter(df.updated_at >= F.dateadd("day", F.lit(-3), F.current_timestamp()))

    # DataFrame representing an upstream source
    # upstream_source = dbt.source("upstream_source_name", "table_name")


    df = upstream_model.withColumn("customer_id_plus_one", add_one(upstream_model["customer_id"]))
    
    # Using UDF
    add_random = register_udf_add_random()
    df = df.withColumn("customer_id_random_one", add_random("customer_id"))
    
    for _, row in df.to_pandas().iterrows():
        # print(row)
        send_http(dbt, session, row['CUSTOMER_ID_RANDOM_ONE'])
    # df = df.to_pandas()

    print(f"value from config is {dbt.config.get('start_date')}") 
    
    return df


