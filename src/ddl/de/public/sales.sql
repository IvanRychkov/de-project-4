create table if not exists sales
(
    client_id  integer        not null
        constraint sales_clients_client_id_fk
            references clients,
    product_id integer        not null
        constraint sales_products_id_fk
            references products,
    amount     integer        not null,
    total_sum  numeric(14, 2) not null,
    constraint sales_pk
        primary key (client_id, product_id)
);

alter table sales
    owner to jovyan;

