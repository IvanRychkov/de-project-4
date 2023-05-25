create table if not exists outbox
(
    id        integer   not null,
    object_id integer   not null,
    record_ts timestamp not null,
    type      varchar   not null,
    payload   text      not null
);

alter table outbox
    owner to jovyan;

