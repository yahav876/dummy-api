helm repo add apache-airflow https://airflow.apache.org

kubectl create secret generic airflow-postgresql-secret \
  --namespace airflow \
  --from-literal=connection="postgresql+psycopg2://airflow:your-secret-password@your-rds-endpoint.rds.amazonaws.com:5432/airflow"
