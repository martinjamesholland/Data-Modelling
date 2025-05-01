-- Sat_Party_Current for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery
-- Optimized for fast queries on current values only

CREATE TABLE IF NOT EXISTS data_vault.sat_party_current (
    sat_party_key STRING NOT NULL,            -- Surrogate key, generated hash
    hub_party_key STRING NOT NULL,            -- Foreign key to hub_party
    load_date TIMESTAMP NOT NULL,             -- Date and time the record was loaded
    record_source STRING NOT NULL,            -- Source system the data came from
    hash_diff STRING NOT NULL,                -- Hash of all attribute values for change detection
    
    -- Business data attributes (current values only)
    party_name STRING,
    party_type STRING,
    party_date_time TIMESTAMP,
    status STRING,
    data_source_system STRING,
    data_source_id STRING,
    is_golden_record BOOLEAN,
    data_quality_score DECIMAL,
    confidence_score DECIMAL,
    last_verified_date DATE,
    party_identification STRING,
    data_steward_id STRING,
    
    -- Metadata attributes (minimal set for current values)
    effective_from TIMESTAMP NOT NULL,        -- Business effective date of this version
    update_frequency STRING NOT NULL,         -- Frequency of updates
    last_update_timestamp TIMESTAMP NOT NULL, -- When this current record was last updated
    
    -- Standard Data Vault 2.0 metadata
    etl_version STRING NOT NULL,              -- Version of the ETL process
    etl_batch_id STRING NOT NULL,             -- Batch ID for audit and lineage
    
    -- Delta format specific
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP NULL,
    
    -- Constraints
    CONSTRAINT pk_sat_party_current PRIMARY KEY (hub_party_key) NOT ENFORCED
)
USING DELTA -- For Hadoop implementation
-- No partitioning for current satellite as it only contains current records
;

-- BigQuery implementation
-- Note: For BigQuery, remove the USING DELTA clause
-- and optimize differently:
/*
CREATE TABLE IF NOT EXISTS data_vault.sat_party_current (
    sat_party_key STRING NOT NULL,
    hub_party_key STRING NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source STRING NOT NULL,
    hash_diff STRING NOT NULL,
    
    -- Business data attributes
    party_name STRING,
    party_type STRING,
    party_date_time TIMESTAMP,
    status STRING,
    data_source_system STRING,
    data_source_id STRING,
    is_golden_record BOOLEAN,
    data_quality_score DECIMAL,
    confidence_score DECIMAL,
    last_verified_date DATE,
    party_identification STRING,
    data_steward_id STRING,
    
    -- Metadata attributes
    effective_from TIMESTAMP NOT NULL,
    update_frequency STRING NOT NULL,
    last_update_timestamp TIMESTAMP NOT NULL,
    
    -- Standard Data Vault 2.0 metadata
    etl_version STRING NOT NULL,
    etl_batch_id STRING NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP
)
CLUSTER BY hub_party_key;
*/

-- Create indexes for fast lookups (for relevant platforms)
-- CREATE INDEX idx_sat_party_current_hub_key ON data_vault.sat_party_current(hub_party_key);
-- CREATE INDEX idx_sat_party_current_name ON data_vault.sat_party_current(party_name); 