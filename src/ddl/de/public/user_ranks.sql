create table if not exists user_ranks
(
    id      integer generated always as identity
        primary key,
    user_id integer not null
        references users,
    rank_id integer not null
        references ranks
);

alter table user_ranks
    owner to jovyan;

create index if not exists idx_user_ranks__rank_id
    on user_ranks (rank_id);

create unique index if not exists idx_user_ranks__user_id
    on user_ranks (user_id);

