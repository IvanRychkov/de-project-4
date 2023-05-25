create table if not exists stg.bonussystem_users
(
    id            integer not null
        primary key,
    order_user_id text    not null
);

alter table stg.bonussystem_users
    owner to jovyan;

