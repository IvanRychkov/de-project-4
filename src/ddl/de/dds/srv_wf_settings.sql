create table if not exists dds.srv_wf_settings
(
    id                serial
        primary key,
    workflow_key      varchar not null
        unique,
    workflow_settings json    not null
);

alter table dds.srv_wf_settings
    owner to jovyan;

