create table if not exists public_test.dm_settlement_report_actual
(
    id                       integer generated always as identity
        constraint dm_settlement_report_pkey_actual
            primary key,
    restaurant_id            integer                  not null,
    restaurant_name          varchar                  not null,
    settlement_year          smallint                 not null
        constraint dm_settlement_report_settlement_year_check
            check ((settlement_year >= 2022) AND (settlement_year < 2500)),
    settlement_month         smallint                 not null
        constraint dm_settlement_report_settlement_month_check
            check ((settlement_month >= 1) AND (settlement_month <= 12)),
    orders_count             integer                  not null
        constraint dm_settlement_report_orders_count_check
            check (orders_count >= 0),
    orders_total_sum         numeric(14, 2) default 0 not null
        constraint dm_settlement_report_orders_total_sum_check
            check (orders_total_sum >= (0)::numeric),
    orders_bonus_payment_sum numeric(14, 2) default 0 not null
        constraint dm_settlement_report_orders_bonus_payment_sum_check
            check (orders_bonus_payment_sum >= (0)::numeric),
    orders_bonus_granted_sum numeric(14, 2) default 0 not null
        constraint dm_settlement_report_orders_bonus_granted_sum_check
            check (orders_bonus_granted_sum >= (0)::numeric),
    order_processing_fee     numeric(14, 2) default 0 not null
        constraint dm_settlement_report_order_processing_fee_check
            check (order_processing_fee >= (0)::numeric),
    restaurant_reward_sum    numeric(14, 2) default 0 not null
        constraint dm_settlement_report_restaurant_reward_sum_check
            check (restaurant_reward_sum >= (0)::numeric),
    constraint dm_settlement_report_restaurant_id_settlement_year_settleme_ac
        unique (restaurant_id, settlement_year, settlement_month)
);

alter table public_test.dm_settlement_report_actual
    owner to jovyan;

