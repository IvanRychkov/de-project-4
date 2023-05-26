create table if not exists stg.ordersystem_restaurants
(
    id           serial
        primary key,
    object_id    varchar   not null
        constraint ordersystem_restaurants_object_id_uindex
            unique,
    object_value text      not null,
    update_ts    timestamp not null
);

alter table stg.ordersystem_restaurants
    owner to jovyan;

