create table if not exists products
(
    product_id integer        not null,
    name       text           not null,
    price      numeric(14, 2) not null,
    id         serial
        constraint products_pk
            primary key,
    valid_from timestamp with time zone,
    valid_to   timestamp with time zone
);

alter table products
    owner to jovyan;

