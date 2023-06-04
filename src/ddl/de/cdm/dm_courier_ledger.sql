create table if not exists cdm.dm_courier_ledger
(
    id                   serial
        primary key,
    courier_id           integer  not null,
    courier_name         varchar  not null,
    settlement_year      smallint not null,
    settlement_month     smallint not null,
    orders_count         smallint not null
        constraint dm_courier_ledger_orders_count_check
            check (orders_count >= 0),
    orders_total_sum     numeric(14, 2)
        constraint dm_courier_ledger_orders_total_sum_check
            check (orders_total_sum >= (0)::numeric),
    rate_avg             numeric(14, 2)
        constraint dm_courier_ledger_rate_avg_check
            check (rate_avg >= (0)::numeric),
    order_processing_fee numeric(14, 2)
        constraint dm_courier_ledger_order_processing_fee_check
            check (order_processing_fee >= (0)::numeric),
    courier_order_sum    numeric(14, 2)
        constraint dm_courier_ledger_courier_order_sum_check
            check (courier_order_sum >= (0)::numeric),
    courier_tips_sum     numeric(14, 2)
        constraint dm_courier_ledger_courier_tips_sum_check
            check (courier_tips_sum >= (0)::numeric),
    courier_reward_sum   numeric(14, 2)
        constraint dm_courier_ledger_courier_reward_sum_check
            check (courier_reward_sum >= (0)::numeric),
    constraint dm_courier_ledger_courier_id_settlement_year_settlement_mon_key
        unique (courier_id, settlement_year, settlement_month)
);

alter table cdm.dm_courier_ledger
    owner to jovyan;

