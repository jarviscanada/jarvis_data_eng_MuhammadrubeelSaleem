\c host_agent;

CREATE TABLE IF NOT EXISTS PUBLIC.host_info (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR NOT NULL UNIQUE,
    cpu_number INT2 NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz FLOAT8 NOT NULL,
    l2_cache INT4 NOT NULL,
    total_mem INT4 NOT NULL,
    "timestamp" TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS public.host_usage (
    "timestamp"      TIMESTAMP NOT NULL,
    host_id          INTEGER NOT NULL,
    memory_free      INTEGER NOT NULL,
    cpu_idle         SMALLINT NOT NULL,
    cpu_kernel       SMALLINT NOT NULL,
    disk_io          INTEGER NOT NULL,
    disk_available   INTEGER NOT NULL,
    CONSTRAINT host_usage_host_info_fk
    FOREIGN KEY (host_id)
    REFERENCES host_info (id)
    ON DELETE CASCADE
);