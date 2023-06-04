from pendulum import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

dag = DAG(
    dag_id='load_delivery_cdm',
    schedule_interval='*/15 * * * *',
    start_date=datetime(2023, 5, 9),
    catchup=False,
    default_args={
        'postgres_conn_id': 'PG_WAREHOUSE_CONNECTION',
    }
)

with dag:
    build_dm = PostgresOperator(
        task_id='dm_courier_ledger',
        sql='sql/dm_courier_ledger.sql',
    )
