create table if not exists dds.fct_delivery
(
    id          serial
        primary key,
    delivery_id varchar
        unique,
    courier_id  integer
        references dds.dm_courier,
    order_id    integer
        references dds.dm_orders,
    rating      smallint not null,
    tip_amt     numeric(14, 2) default 0
);

alter table dds.fct_delivery
    owner to jovyan;

