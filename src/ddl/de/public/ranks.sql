create table if not exists ranks
(
    id                    integer                  not null
        primary key,
    name                  varchar(2048)            not null,
    bonus_percent         numeric(19, 5) default 0 not null
        constraint ranks_bonus_percent_check
            check (bonus_percent >= (0)::numeric)
        constraint ranks_bonus_percent_check1
            check (bonus_percent >= (0)::numeric),
    min_payment_threshold numeric(19, 5) default 0 not null
);

alter table ranks
    owner to jovyan;

