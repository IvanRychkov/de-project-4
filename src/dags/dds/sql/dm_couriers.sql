truncate table dds.dm_courier cascade;
alter sequence dds.dm_courier_id_seq restart with 1;
insert into dds.dm_courier (courier_id, name)
select object_id, object_value ->> 'name'
from stg.deliverysystem_couriers;