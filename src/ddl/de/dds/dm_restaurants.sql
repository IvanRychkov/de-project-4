create table if not exists dds.dm_restaurants
(
    id              serial
        primary key,
    restaurant_id   varchar   not null,
    restaurant_name varchar   not null,
    active_from     timestamp not null,
    active_to       timestamp not null
);

alter table dds.dm_restaurants
    owner to jovyan;

