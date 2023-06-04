from pendulum import datetime, parse
from airflow import DAG
from airflow.operators.python import PythonOperator
from lib.api_utils import get_api_hook, request_paginated
from lib.pg_connect import get_dwh_connection
from psycopg.sql import SQL, Identifier
from lib.dict_util import json2str

dag = DAG(
    dag_id='delivery_staging_dag',
    schedule_interval='*/15 * * * *',
    start_date=datetime(2023, 5, 1),
    catchup=False,
    max_active_tasks=3,
    max_active_runs=1,
    default_args=dict(
        retries=0,
        # Параметры HTTP-запросов
        op_kwargs=dict(
            data={
                'sort_field': '_id',
            }
        )
    ),
)


def load_data_from_api(resource_name: str, id_field='_id', **kwargs):
    """Загружает данные из API-эндпоинта в staging-таблицу в Postgres."""
    api = get_api_hook()
    print(kwargs.get('data'))
    with get_dwh_connection() as conn:
        for obj in request_paginated(api, resource_name, limit=50, data=kwargs.get('data')):
            print(obj)  # TODO удалить
            conn.execute(
                SQL('''
                    insert into stg.{} (object_id, object_value)
                    values (%s, %s)
                    on conflict (object_id) do update set object_value = excluded.object_value;
                    ''').format(Identifier('deliverysystem_' + resource_name)),  # Динамическое имя таблицы
                (obj[id_field], json2str(obj))
            )


with dag:
    # Измерения одинаково - полная загрузка
    for resource in 'restaurants', 'couriers':
        PythonOperator(
            task_id='load_' + resource,
            python_callable=load_data_from_api,
            op_args=(resource,),
        )

    PythonOperator(
        task_id='load_deliveries',
        python_callable=load_data_from_api,
        op_args=('deliveries', 'order_id'),
        op_kwargs={'data': {
            'from': '{{ data_interval_start.subtract(days=6).strftime("%Y-%m-%d %H:%M:%S") }}'},
            'to': '{{ data_interval_start.now().strftime("%Y-%m-%d %H:%M:%S") }}'
        }
    )
