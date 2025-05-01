-- Sat_Party_Relationship for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery
-- Supports time-series data and different update frequencies

CREATE TABLE IF NOT EXISTS data_vault.sat_party_relationship (
    sat_party_relationship_key STRING NOT NULL,  -- Surrogate key, generated hash
    link_party_relationship_key STRING NOT NULL, -- Foreign key to link_party_relationship
    load_date TIMESTAMP NOT NULL,                -- Date and time the record was loaded
    load_end_date TIMESTAMP,                     -- End date for this version
    record_source STRING NOT NULL,               -- Source system the data came from
    hash_diff STRING NOT NULL,                   -- Hash of all attribute values for change detection
    
    -- Business data attributes
    relationship_type STRING,
    relationship_validity_period STRING,
    start_date DATE,
    end_date DATE,
    status STRING,
    description STRING,
    priority INT,
    is_bidirectional BOOLEAN,
    
    -- Customer Relationship specific attributes (for CustomerRelationship subtype)
    customer_type STRING,
    customer_category STRING,
    customer_risk_rating STRING,
    account_manager_id STRING,
    lifecycle_stage STRING,
    credit_limit DECIMAL,
    payment_terms STRING,
    onboarding_date DATE,
    kyc_status STRING,
    kyc_review_date DATE,
    
    -- Tracking and metadata attributes for versioning and change data capture (CDC)
    effective_from TIMESTAMP NOT NULL,           -- Business effective date of this version
    effective_to TIMESTAMP,                      -- Business effective end date of this version
    is_current BOOLEAN NOT NULL,                 -- Flag for the current version
    update_frequency STRING NOT NULL,            -- Frequency of updates: "real-time", "daily", "weekly", etc.
    update_type STRING NOT NULL,                 -- Type of update: "insert", "update", "correction", "delete", etc.
    source_update_timestamp TIMESTAMP,           -- Timestamp from the source system when the update occurred
    
    -- Standard Data Vault 2.0 metadata
    etl_version STRING NOT NULL,                 -- Version of the ETL process
    etl_batch_id STRING NOT NULL,                -- Batch ID for audit and lineage
    
    -- Delta format specific
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP NULL,
    
    -- Constraints
    CONSTRAINT pk_sat_party_relationship PRIMARY KEY (sat_party_relationship_key, load_date) NOT ENFORCED
)
USING DELTA -- For Hadoop implementation
PARTITIONED BY (YEAR(load_date), MONTH(load_date));

-- BigQuery implementation
-- Note: For BigQuery, remove the USING DELTA clause
-- and adjust the partitioning as follows:
/*
CREATE TABLE IF NOT EXISTS data_vault.sat_party_relationship (
    sat_party_relationship_key STRING NOT NULL,
    link_party_relationship_key STRING NOT NULL,
    load_date TIMESTAMP NOT NULL,
    load_end_date TIMESTAMP,
    record_source STRING NOT NULL,
    hash_diff STRING NOT NULL,
    
    -- Business data attributes
    relationship_type STRING,
    relationship_validity_period STRING,
    start_date DATE,
    end_date DATE,
    status STRING,
    description STRING,
    priority INT,
    is_bidirectional BOOLEAN,
    
    -- Customer Relationship specific attributes
    customer_type STRING,
    customer_category STRING,
    customer_risk_rating STRING,
    account_manager_id STRING,
    lifecycle_stage STRING,
    credit_limit DECIMAL,
    payment_terms STRING,
    onboarding_date DATE,
    kyc_status STRING,
    kyc_review_date DATE,
    
    -- Tracking and metadata attributes
    effective_from TIMESTAMP NOT NULL,
    effective_to TIMESTAMP,
    is_current BOOLEAN NOT NULL,
    update_frequency STRING NOT NULL,
    update_type STRING NOT NULL,
    source_update_timestamp TIMESTAMP,
    
    -- Standard Data Vault 2.0 metadata
    etl_version STRING NOT NULL,
    etl_batch_id STRING NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP
)
PARTITION BY DATE(load_date)
CLUSTER BY link_party_relationship_key, load_date;
*/

-- Create a view for the current state of the party relationship satellite
CREATE OR REPLACE VIEW data_vault.sat_party_relationship_current AS
SELECT * 
FROM data_vault.sat_party_relationship
WHERE is_current = TRUE;

-- Create a view for real-time updates for streaming applications
CREATE OR REPLACE VIEW data_vault.sat_party_relationship_realtime AS
SELECT * 
FROM data_vault.sat_party_relationship
WHERE update_frequency = 'real-time'
ORDER BY load_date DESC;

-- Create a view specifically for customer relationships
CREATE OR REPLACE VIEW data_vault.sat_customer_relationship_current AS
SELECT * 
FROM data_vault.sat_party_relationship
WHERE relationship_type = 'Customer' 
  AND is_current = TRUE; 