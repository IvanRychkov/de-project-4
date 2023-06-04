create table if not exists dds.dm_products
(
    id            serial
        primary key,
    restaurant_id integer                  not null
        references dds.dm_restaurants,
    product_id    varchar                  not null,
    product_name  varchar                  not null,
    product_price numeric(14, 2) default 0 not null
        constraint dm_products_product_price_check
            check (product_price >= (0)::numeric)
        constraint dm_products_product_price_check1
            check (product_price <= 999000000000.99),
    active_from   timestamp                not null,
    active_to     timestamp                not null
);

alter table dds.dm_products
    owner to jovyan;

