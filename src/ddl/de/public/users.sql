create table if not exists users
(
    id            integer generated always as identity
        primary key,
    order_user_id text not null
);

alter table users
    owner to jovyan;

