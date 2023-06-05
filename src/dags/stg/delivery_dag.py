import logging

from pendulum import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from lib.api_utils import HttpHook, request_paginated
from lib.pg_connect import ConnectionBuilder
from psycopg.sql import SQL, Identifier
from lib.dict_util import json2str

logging.basicConfig()

dag = DAG(
    dag_id='delivery_staging_dag',
    schedule_interval='0 * * * *',
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
                'sort_direction': 'asc',
            }
        )
    ),
)


def load_data_from_api(resource_name: str, id_field='_id', **kwargs):
    """Загружает данные из API-эндпоинта в staging-таблицу в Postgres."""
    # Получаем подключение к API из Airflow
    api = HttpHook(method='GET', http_conn_id='DELIVERY_API_CONNECTION')
    logging.info(kwargs.get('data'))
    n_loaded = 0
    # Создаём подключение к базе
    with ConnectionBuilder.pg_conn('PG_WAREHOUSE_CONNECTION').connection() as conn:
        # Запрашиваем объекты из API постранично
        for n_loaded, obj in enumerate(request_paginated(api, resource_name, data=kwargs.get('data')),
                                       start=1):
            logging.debug(obj)
            # Выполняем вставку с обновлением
            conn.execute(
                SQL('''
                    insert into stg.{} (object_id, object_value)
                    values (%s, %s)
                    on conflict (object_id) do update set object_value = excluded.object_value;
                    ''').format(Identifier('deliverysystem_' + resource_name)),
                (obj[id_field], json2str(obj))
            )
    logging.info(f'objects loaded: {n_loaded}')


with dag:
    # Измерения делаем одинаково - полная загрузка
    for resource in 'restaurants', 'couriers':
        PythonOperator(
            task_id='load_' + resource,
            python_callable=load_data_from_api,
            op_args=(resource,),
        )

    # Доставки загружаем окном в 7 дней
    PythonOperator(
        task_id='load_deliveries',
        python_callable=load_data_from_api,
        op_args=('deliveries', 'order_id'),
        op_kwargs={
            'data': {
                'from': '{{ data_interval_start.strftime("%Y-%m-%d %H:%M:%S") }}',
                'to': '{{ data_interval_end.strftime("%Y-%m-%d %H:%M:%S") }}',
                **dag.default_args['op_kwargs']['data'],
            }
        }
    )
