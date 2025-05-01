-- Link_Party_Relationship for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery

CREATE TABLE IF NOT EXISTS data_vault.link_party_relationship (
    link_party_relationship_key STRING NOT NULL,  -- Surrogate key, generated hash
    hub_party_from_key STRING NOT NULL,           -- Foreign key to hub_party (from)
    hub_party_to_key STRING NOT NULL,             -- Foreign key to hub_party (to)
    party_relationship_id STRING NOT NULL,        -- Business key
    load_date TIMESTAMP NOT NULL,                 -- Date and time the record was loaded
    record_source STRING NOT NULL,                -- Source system the data came from
    etl_version STRING NOT NULL,                  -- Version of the ETL process
    etl_batch_id STRING NOT NULL,                 -- Batch ID for audit and lineage
    
    -- Delta format specific
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP NULL,
    
    -- Constraints
    CONSTRAINT pk_link_party_relationship PRIMARY KEY (link_party_relationship_key) NOT ENFORCED
)
USING DELTA -- For Hadoop implementation
PARTITIONED BY (YEAR(load_date), MONTH(load_date));

-- BigQuery implementation
-- Note: For BigQuery, remove the USING DELTA clause
-- and adjust the partitioning as follows:
/*
CREATE TABLE IF NOT EXISTS data_vault.link_party_relationship (
    link_party_relationship_key STRING NOT NULL,
    hub_party_from_key STRING NOT NULL,
    hub_party_to_key STRING NOT NULL,
    party_relationship_id STRING NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source STRING NOT NULL,
    etl_version STRING NOT NULL,
    etl_batch_id STRING NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP
)
PARTITION BY DATE(load_date)
CLUSTER BY hub_party_from_key, hub_party_to_key;
*/ 