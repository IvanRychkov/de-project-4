create table if not exists stg.deliverysystem_deliveries
(
    id           serial
        primary key,
    object_id    varchar not null
        unique,
    object_value json    not null
);

alter table stg.deliverysystem_deliveries
    owner to jovyan;

