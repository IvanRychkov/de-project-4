create table if not exists clients
(
    client_id integer not null
        constraint clients_pk
            primary key,
    name      text    not null,
    login     text    not null
);

alter table clients
    owner to jovyan;

