create table if not exists stg.bonussystem_events
(
    id          integer   not null
        primary key,
    event_ts    timestamp not null,
    event_type  varchar   not null,
    event_value text      not null
);

alter table stg.bonussystem_events
    owner to jovyan;

create index if not exists idx_bonussystem_events__event_ts
    on stg.bonussystem_events (event_ts);

