create table if not exists stg.deliverysystem_restaurants
(
    id           serial
        primary key,
    object_id    varchar not null
        unique,
    object_value json    not null
);

alter table stg.deliverysystem_restaurants
    owner to jovyan;

