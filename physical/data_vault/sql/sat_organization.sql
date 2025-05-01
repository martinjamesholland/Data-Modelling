-- Sat_Organization for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery
-- Supports time-series data and multiple update frequencies

CREATE TABLE IF NOT EXISTS data_vault.sat_organization (
    sat_organization_key STRING NOT NULL,     -- Surrogate key, generated hash
    hub_organization_key STRING NOT NULL,     -- Foreign key to hub_organization
    load_date TIMESTAMP NOT NULL,             -- Date and time the record was loaded
    load_end_date TIMESTAMP,                  -- End date for this version
    record_source STRING NOT NULL,            -- Source system the data came from
    hash_diff STRING NOT NULL,                -- Hash of all attribute values for change detection
    
    -- Business data attributes
    organization_name STRING,
    trading_name STRING,
    organization_type STRING,
    organization_sector STRING,
    registration_date DATE,
    registration_country STRING,
    tax_country STRING,
    organization_structure STRING,
    employee_count INT,
    annual_revenue DECIMAL,
    registration_authority STRING,
    website STRING,
    parent_organization_id STRING,
    
    -- Tracking and metadata attributes for versioning and change data capture (CDC)
    effective_from TIMESTAMP NOT NULL,        -- Business effective date of this version
    effective_to TIMESTAMP,                   -- Business effective end date of this version
    is_current BOOLEAN NOT NULL,              -- Flag for the current version
    update_frequency STRING NOT NULL,         -- Frequency of updates: "real-time", "daily", "weekly", etc.
    update_type STRING NOT NULL,              -- Type of update: "insert", "update", "correction", "delete", etc.
    source_update_timestamp TIMESTAMP,        -- Timestamp from the source system when the update occurred
    
    -- Standard Data Vault 2.0 metadata
    etl_version STRING NOT NULL,              -- Version of the ETL process
    etl_batch_id STRING NOT NULL,             -- Batch ID for audit and lineage
    
    -- Delta format specific
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP NULL,
    
    -- Constraints
    CONSTRAINT pk_sat_organization PRIMARY KEY (sat_organization_key, load_date) NOT ENFORCED
)
USING DELTA -- For Hadoop implementation
PARTITIONED BY (YEAR(load_date), MONTH(load_date));

-- BigQuery implementation
-- Note: For BigQuery, remove the USING DELTA clause
-- and adjust the partitioning as follows:
/*
CREATE TABLE IF NOT EXISTS data_vault.sat_organization (
    sat_organization_key STRING NOT NULL,
    hub_organization_key STRING NOT NULL,
    load_date TIMESTAMP NOT NULL,
    load_end_date TIMESTAMP,
    record_source STRING NOT NULL,
    hash_diff STRING NOT NULL,
    
    -- Business data attributes
    organization_name STRING,
    trading_name STRING,
    organization_type STRING,
    organization_sector STRING,
    registration_date DATE,
    registration_country STRING,
    tax_country STRING,
    organization_structure STRING,
    employee_count INT,
    annual_revenue DECIMAL,
    registration_authority STRING,
    website STRING,
    parent_organization_id STRING,
    
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
CLUSTER BY hub_organization_key, load_date;
*/

-- Create a view for the current state of the organization satellite
CREATE OR REPLACE VIEW data_vault.sat_organization_current AS
SELECT * 
FROM data_vault.sat_organization
WHERE is_current = TRUE;

-- Create a view for daily batch updates
CREATE OR REPLACE VIEW data_vault.sat_organization_daily AS
SELECT * 
FROM data_vault.sat_organization
WHERE update_frequency = 'daily'
ORDER BY load_date DESC; 