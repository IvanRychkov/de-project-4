create table if not exists dds.dm_orders
(
    id            serial
        primary key,
    user_id       integer not null
        references dds.dm_users,
    restaurant_id integer not null
        references dds.dm_restaurants,
    timestamp_id  integer not null
        references dds.dm_timestamps,
    order_key     varchar not null,
    order_status  varchar not null
);

alter table dds.dm_orders
    owner to jovyan;

