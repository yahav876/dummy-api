from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
import requests
import json
from datetime import datetime

def ingest_data():
    # Call dummy data API
    resp = requests.get("http://mockingbird.airflow.svc.cluster.local:1511/api/random")
    resp.raise_for_status()
    data = resp.json()

    # Insert into Postgres
    pg_hook = PostgresHook(postgres_conn_id='postgres_default')  # This points to the URI in your secret
    insert_sql = """
        INSERT INTO dummy_table (name, email, phone)
        VALUES (%s, %s, %s)
    """
    pg_hook.run(insert_sql, parameters=(data['name'], data['email'], data['phone']))

default_args = {
    'start_date': datetime(2023, 1, 1)
}

with DAG('dummy_data_pipeline', schedule_interval='@hourly', default_args=default_args, catchup=False) as dag:
    ingest = PythonOperator(
        task_id='ingest_dummy_data',
        python_callable=ingest_data
    )
