create table if not exists bonus_transactions
(
    id          integer generated always as identity
        primary key,
    user_id     integer                  not null
        references users,
    order_id    varchar(255)             not null,
    order_ts    timestamp                not null,
    order_sum   numeric(19, 5) default 0 not null,
    payment_sum numeric(19, 5) default 0 not null
        constraint bonus_transactions_payment_sum_check
            check (payment_sum >= (0)::numeric),
    granted_sum numeric(19, 5) default 0 not null,
    constraint bonus_transactions_check
        check ((payment_sum >= (0)::numeric) AND (payment_sum <= order_sum)),
    constraint bonus_transactions_check1
        check ((granted_sum >= (0)::numeric) AND (granted_sum <= order_sum))
);

alter table bonus_transactions
    owner to jovyan;

create index if not exists idx_bonus_transactions__order_id
    on bonus_transactions (order_id);

create index if not exists idx_bonus_transactions__user_id__order_id
    on bonus_transactions (user_id, order_id);

