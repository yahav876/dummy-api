from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import requests

def ingest_data():
    resp = requests.get("http://mockoon.airflow.svc.cluster.local:3000/analytics/live-streams/122")
    resp.raise_for_status()
    records = resp.json().get('data', [])

    pg_hook = PostgresHook(postgres_conn_id='postgres_default')
    insert_sql = """
        INSERT INTO dummy_stream_sessions (
          client_name, device_vendor, location_city, location_country,
          os_name, os_version, referrer_url, session_loaded_at, session_ended_at
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    for r in records:
        pg_hook.run(insert_sql, parameters=(
            r['client']['name'],
            r['device']['vendor'],
            r['location']['city'],
            r['location']['country'],
            r['os']['name'],
            r['os']['version'],
            r['referrer']['url'],
            r['session']['loadedAt'],
            r['session']['endedAt']
        ))

default_args = {
    'start_date': datetime(2023, 1, 1)
}

with DAG('dummy_stream_ingest', schedule_interval='@hourly', default_args=default_args, catchup=False) as dag:
    PythonOperator(
        task_id='fetch_and_insert_stream_data',
        python_callable=ingest_data
    )
