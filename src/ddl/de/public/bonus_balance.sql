create table if not exists bonus_balance
(
    id      integer generated always as identity
        primary key,
    user_id integer                  not null
        references users,
    balance numeric(19, 5) default 0 not null
        constraint bonus_balance_balance_check
            check (balance >= (0)::numeric)
);

alter table bonus_balance
    owner to jovyan;

create unique index if not exists idx_bonus_balance__user_id
    on bonus_balance (user_id);

