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

def send_email(dbt, session, customer_id):
    import smtplib
    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart

    # Email sender and recipient
    sender_email = dbt.config.get('email',"narutobaron123test@gmail.com")
    recipient_email = "kishore@prophecy.io"
    import _snowflake
    password = _snowflake.get_generic_secret_string('email_secret_variable_name')

    # Email subject and body
    subject = f"Sample Email customer_id - {customer_id}"
    body = "This is a sample email sent using Python."

    # Create the email message
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = recipient_email
    message["Subject"] = subject

    # Attach the email body
    message.attach(MIMEText(body, "plain"))

    # SMTP server configuration
    smtp_server = "smtp.gmail.com"
    port = 587  # For TLS
    server = None

    try:
        # Connect to the SMTP server
        server = smtplib.SMTP(smtp_server, port)
        server.starttls()  # Upgrade the connection to secure
        server.login(sender_email, password)  # Login to your email account
        server.sendmail(sender_email, recipient_email, message.as_string())  # Send the email
        print("Email sent successfully!")
    except Exception as e:
        import datetime
        # Insert log into Snowflake table
        session.sql(f"""
            INSERT INTO debug_logs (log_time, message)
            VALUES (?,?)""",(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), f'Error during sending email: {str(e)}')).collect()
        print(f"Error: {e}")
    finally:
        if server is not None:
            server.quit()  # Close the connection

def model(dbt, session):

    # setting configuration
    dbt.config(
        materialized="table",
        packages = ["numpy", "holidays"],
        external_access_integrations=["appprophecyai"],
        secrets={"email_secret_variable_name": "kishoreemailpassword"},
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
        # session.sql(f"""CALL SYSTEM$SEND_EMAIL(
        #     'kishore_email_int',
        #     'kishore@prophecy.io',
        #     'Email Alert: Row {row['CUSTOMER_ID_RANDOM_ONE']} has finished.',
        #     'Trying Email {dbt.config.get('email',"narutobarondefault@gmail.com")} has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
        # )""").collect()
        
        send_email(dbt, session, row['CUSTOMER_ID_RANDOM_ONE'])
    # df = df.to_pandas()

    print(f"value from config is {dbt.config.get('start_date')}") 
    
    return df


