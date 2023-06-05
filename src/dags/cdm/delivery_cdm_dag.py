from pendulum import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.sensors.external_task import ExternalTaskSensor

dag = DAG(
    dag_id='dm_courier_ledger_dag',
    schedule_interval='0 * * * *',
    start_date=datetime(2023, 5, 9),
    catchup=False,
    default_args={
        'postgres_conn_id': 'PG_WAREHOUSE_CONNECTION',
    }
)

with dag:
    wait_for_dds = ExternalTaskSensor(
        task_id='wait_for_dds',
        external_dag_id='delivery_dds_dag',
    )

    build_dm = PostgresOperator(
        task_id='dm_courier_ledger',
        sql='sql/dm_courier_ledger.sql',
    )
