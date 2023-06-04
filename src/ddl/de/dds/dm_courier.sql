create table if not exists dds.dm_courier
(
    id         serial
        primary key,
    courier_id varchar not null
        unique,
    name       varchar not null
);

alter table dds.dm_courier
    owner to jovyan;

