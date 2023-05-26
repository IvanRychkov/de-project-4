create table if not exists stg.ordersystem_orders
(
    id           serial
        primary key,
    object_id    varchar   not null
        constraint ordersystem_orders_object_id_uindex
            unique,
    object_value text      not null,
    update_ts    timestamp not null
);

alter table stg.ordersystem_orders
    owner to jovyan;

