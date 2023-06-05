"""DAG для заполнения DDS-таблиц с данными доставок из staging-слоя."""

import logging

from pendulum import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

logging.basicConfig()

dag = DAG(
    dag_id='delivery_dds_dag',
    schedule_interval='0 * * * *',
    start_date=datetime(2023, 5, 1),
    catchup=False,
    max_active_runs=1,
    default_args=dict(
        postgres_conn_id='PG_WAREHOUSE_CONNECTION',
    ),
)

with dag:
    PostgresOperator(
        task_id='fill_dds_tables',
        sql='./sql/delivery_dds_tables.sql',
    )
