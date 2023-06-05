from pendulum import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.sensors.external_task import ExternalTaskSensor

dag = DAG(
    dag_id='load_cdm',
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
        external_dag_id='load_dds',
    )

    build_dm = PostgresOperator(
        task_id='dm_settlement_report',
        sql='sql/dm_settlement_report.sql',
    )

    wait_for_dds >> build_dm
