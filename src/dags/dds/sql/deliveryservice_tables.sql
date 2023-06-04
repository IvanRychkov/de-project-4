truncate table dds.dm_courier cascade;
alter sequence dds.dm_courier_id_seq restart with 1;
insert into dds.dm_courier (courier_id, name)
select object_id, object_value ->> 'name'
from stg.deliverysystem_couriers;

truncate table dds.fct_delivery;
insert into dds.fct_delivery (delivery_id, courier_id, order_id, rating, tip_amt)
select object_id                                    as delivery_id,
       c.id                                         as courier_id,
       o.id                                         as order_id,
       (object_value ->> 'rate')::smallint          as rating,
       (object_value ->> 'tip_sum')::numeric(14, 2) as tip_amt

from stg.deliverysystem_deliveries d
         join dds.dm_orders o on d.object_value ->> 'order_id' = o.order_key
         join dds.dm_courier c on d.object_value ->> 'courier_id' = c.courier_id;