from fastapi import FastAPI
from faker import Faker
import psycopg2
import os

app = FastAPI()
fake = Faker()

# Configure your DB connection
DB_HOST = os.getenv("DB_HOST", "demodb.XXX.us-east-1.rds.amazonaws.com")
DB_NAME = os.getenv("DB_NAME", "demodb")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "XXXX")

def insert_to_db(data):
    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            name TEXT,
            email TEXT
        )
    """)
    for user in data:
        cur.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (user['name'], user['email']))
    conn.commit()
    cur.close()
    conn.close()

@app.post("/generate")
def generate_dummy_data(count: int = 10):
    data = [{"name": fake.name(), "email": fake.email()} for _ in range(count)]
    insert_to_db(data)
    return {"inserted": len(data)}