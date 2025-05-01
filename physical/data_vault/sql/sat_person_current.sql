-- Sat_Person_Current for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery
-- Optimized for fast queries on current values only

CREATE TABLE IF NOT EXISTS data_vault.sat_person_current (
    sat_person_key STRING NOT NULL,           -- Surrogate key, generated hash
    hub_person_key STRING NOT NULL,           -- Foreign key to hub_person
    load_date TIMESTAMP NOT NULL,             -- Date and time the record was loaded
    record_source STRING NOT NULL,            -- Source system the data came from
    hash_diff STRING NOT NULL,                -- Hash of all attribute values for change detection
    
    -- Business data attributes (current values only)
    first_name STRING,
    middle_name STRING,
    last_name STRING, 
    given_name STRING,
    family_name STRING,
    birth_date DATE,
    gender STRING,
    marital_status STRING,
    nationality STRING,
    residence_country STRING,
    ethnicity STRING,
    religion STRING,
    preferred_language STRING,
    residential_status STRING,
    
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
    CONSTRAINT pk_sat_person_current PRIMARY KEY (hub_person_key) NOT ENFORCED
)
USING DELTA -- For Hadoop implementation
-- No partitioning for current satellite as it only contains current records
;

-- BigQuery implementation
-- Note: For BigQuery, remove the USING DELTA clause
-- and optimize differently:
/*
CREATE TABLE IF NOT EXISTS data_vault.sat_person_current (
    sat_person_key STRING NOT NULL,
    hub_person_key STRING NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source STRING NOT NULL,
    hash_diff STRING NOT NULL,
    
    -- Business data attributes
    first_name STRING,
    middle_name STRING,
    last_name STRING, 
    given_name STRING,
    family_name STRING,
    birth_date DATE,
    gender STRING,
    marital_status STRING,
    nationality STRING,
    residence_country STRING,
    ethnicity STRING,
    religion STRING,
    preferred_language STRING,
    residential_status STRING,
    
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
CLUSTER BY hub_person_key;
*/

-- Create indexes for fast lookups (for relevant platforms)
-- CREATE INDEX idx_sat_person_current_hub_key ON data_vault.sat_person_current(hub_person_key);
-- CREATE INDEX idx_sat_person_current_name ON data_vault.sat_person_current(last_name, first_name); 