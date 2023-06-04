from pendulum import datetime, parse
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.http.hooks.http import HttpHook
from lib.api_utils import get_api_hook, request_paginated
from lib.pg_connect import ConnectionBuilder

dag = DAG(
    dag_id='delivery_staging_dag',
    schedule_interval='*/15 * * * *',
    start_date=datetime(2023, 5, 1),
    catchup=False,
    max_active_tasks=1,
    max_active_runs=1,
    default_args=dict(
        retries=0,
    ),
)


def load_couriers():
    """Загружает данные курьеров в Postgres."""
    api = get_api_hook()
    for c in request_paginated(api, 'couriers', limit=50, data={'sort_field': '_id', 'sort_direction': 'asc'}):
        print(c)

    with ConnectionBuilder.pg_conn('PG_WAREHOUSE_CONNECTION').connection() as conn:
        print(conn.execute(
            '''
            insert into stg.deliverysystem_couriers (object_id, name)
            values()
            '''))


with dag:
    PythonOperator(
        task_id='load_couriers',
        python_callable=load_couriers,
    )
