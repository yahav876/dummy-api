from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import psycopg2
import json
import os

# DAG defaults
default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define DAG
with DAG(
    dag_id='mockingbird_data_ingestion',
    default_args=default_args,
    start_date=datetime(2023, 1, 1),
    schedule_interval='@hourly',
    catchup=False,
    description='Ingest dummy data from Mockingbird and store in RDS',
) as dag:

    def fetch_and_insert_data():
        # Call the mockingbird API (adjust the service name if needed)
        res = requests.get('http://mockingbird:1512/api/data')  # Or use your NodePort/NLB
        res.raise_for_status()
        data = res.json()

        # Optional: Transform the data
        transformed = json.dumps(data)  # For demo purposes, just serialize

        # Connect to PostgreSQL RDS
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB", "demodb"),
            user=os.getenv("POSTGRES_USER", "postgres"),
            password=os.getenv("POSTGRES_PASSWORD", "yourpassword"),
            host=os.getenv("POSTGRES_HOST", "your-rds-endpoint"),
            port=5432
        )
        cur = conn.cursor()

        # Make sure the table exists
        cur.execute("CREATE TABLE IF NOT EXISTS dummy_data (id SERIAL PRIMARY KEY, payload JSONB, inserted_at TIMESTAMP DEFAULT NOW());")

        # Insert data
        cur.execute("INSERT INTO dummy_data (payload) VALUES (%s);", (transformed,))
        conn.commit()

        cur.close()
        conn.close()

    ingest_task = PythonOperator(
        task_id='fetch_transform_store',
        python_callable=fetch_and_insert_data,
    )
