create table if not exists dm_users
(
    id         serial
        primary key,
    user_id    varchar not null,
    user_name  varchar not null,
    user_login varchar not null
);

alter table dm_users
    owner to jovyan;

