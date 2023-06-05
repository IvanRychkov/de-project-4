-- truncate table cdm.dm_courier_ledger;
delete
from cdm.dm_courier_ledger
where settlement_year = extract(year from date '{{ ds }}')
  and settlement_month = extract(month from date '{{ ds }}');


insert
into cdm.dm_courier_ledger (courier_id, courier_name, settlement_year, settlement_month, orders_count,
                            orders_total_sum, rate_avg, order_processing_fee, courier_order_sum,
                            courier_tips_sum, courier_reward_sum)
-- Суммы заказов
with orders_sums as (select order_id,
                            sum(total_sum) as order_sum
                     from dds.fct_product_sales
                     group by order_id),
     agg as (select d.courier_id,
                    ts.year,
                    ts.month,
                    count(order_id)            as orders_count,
                    sum(os.order_sum)          as orders_total_sum,
                    avg(rating::numeric(4, 3)) as rate_avg,
                    sum(os.order_sum) * .25    as order_processing_fee,
                    sum(tip_amt)               as courier_tips_sum
             from dds.fct_delivery d
                      join dds.dm_orders o on d.order_id = o.id
                      join dds.dm_timestamps ts on o.timestamp_id = ts.id
                      join orders_sums os using (order_id)
             where ts.year = extract(year from date '{{ ds }}')
               and ts.month = extract(month from date '{{ ds }}')
             group by 1, 2, 3),
     courier_order_sums as (select *,
                                   case
                                       when rate_avg < 4
                                           then greatest(orders_total_sum * .05, orders_count * 100)
                                       when rate_avg < 4.5
                                           then greatest(orders_total_sum * .07, orders_count * 150)
                                       when rate_avg < 4.9
                                           then greatest(orders_total_sum * .08, orders_count * 175)
                                       else greatest(orders_total_sum * .1, orders_count * 200) end
                                       as courier_order_sum
                            from agg)
select t.courier_id,
       c.name,
       year,
       month,
       orders_count,
       orders_total_sum,
       rate_avg,
       order_processing_fee,
       courier_order_sum,
       courier_tips_sum,
       courier_order_sum + courier_tips_sum * .95 as courier_reward_sum
from courier_order_sums t
         join dds.dm_courier c
              on t.courier_id = c.id
order by 1, 3, 4
;