-- Sat_Sync_Trigger for Data Vault 2.0
-- For use with Delta format on Hadoop and GCP BigQuery
-- Triggers and procedures to keep current and history satellites synchronized

-- Party Synchronization Procedure
-- This procedure synchronizes the party current satellite with history when changes occur

CREATE OR REPLACE PROCEDURE data_vault.sync_party_satellites()
LANGUAGE SQL
AS $$
BEGIN
  -- 1. Update the current satellite with latest values from history
  MERGE INTO data_vault.sat_party_current target
  USING (
    SELECT 
      h.sat_party_key,
      h.hub_party_key,
      h.load_date,
      h.record_source,
      h.hash_diff,
      h.party_name,
      h.party_type,
      h.party_date_time,
      h.status,
      h.data_source_system,
      h.data_source_id,
      h.is_golden_record,
      h.data_quality_score,
      h.confidence_score,
      h.last_verified_date,
      h.party_identification,
      h.data_steward_id,
      h.effective_from,
      h.update_frequency,
      h.source_update_timestamp AS last_update_timestamp,
      h.etl_version,
      h.etl_batch_id
    FROM data_vault.sat_party_history h
    INNER JOIN (
      SELECT 
        hub_party_key, 
        MAX(load_date) AS latest_load_date
      FROM data_vault.sat_party_history
      WHERE is_current = TRUE
      GROUP BY hub_party_key
    ) latest 
    ON h.hub_party_key = latest.hub_party_key 
    AND h.load_date = latest.latest_load_date
  ) source
  ON target.hub_party_key = source.hub_party_key
  WHEN MATCHED AND target.hash_diff != source.hash_diff THEN
    UPDATE SET
      sat_party_key = source.sat_party_key,
      load_date = source.load_date,
      record_source = source.record_source,
      hash_diff = source.hash_diff,
      party_name = source.party_name,
      party_type = source.party_type,
      party_date_time = source.party_date_time,
      status = source.status,
      data_source_system = source.data_source_system,
      data_source_id = source.data_source_id,
      is_golden_record = source.is_golden_record,
      data_quality_score = source.data_quality_score,
      confidence_score = source.confidence_score,
      last_verified_date = source.last_verified_date,
      party_identification = source.party_identification,
      data_steward_id = source.data_steward_id,
      effective_from = source.effective_from,
      update_frequency = source.update_frequency,
      last_update_timestamp = source.last_update_timestamp,
      etl_version = source.etl_version,
      etl_batch_id = source.etl_batch_id,
      updated_at = CURRENT_TIMESTAMP()
  WHEN NOT MATCHED THEN
    INSERT (
      sat_party_key,
      hub_party_key,
      load_date,
      record_source,
      hash_diff,
      party_name,
      party_type,
      party_date_time,
      status,
      data_source_system,
      data_source_id,
      is_golden_record,
      data_quality_score,
      confidence_score,
      last_verified_date,
      party_identification,
      data_steward_id,
      effective_from,
      update_frequency,
      last_update_timestamp,
      etl_version,
      etl_batch_id,
      created_at,
      updated_at
    )
    VALUES (
      source.sat_party_key,
      source.hub_party_key,
      source.load_date,
      source.record_source,
      source.hash_diff,
      source.party_name,
      source.party_type,
      source.party_date_time,
      source.status,
      source.data_source_system,
      source.data_source_id,
      source.is_golden_record,
      source.data_quality_score,
      source.confidence_score,
      source.last_verified_date,
      source.party_identification,
      source.data_steward_id,
      source.effective_from,
      source.update_frequency,
      source.last_update_timestamp,
      source.etl_version,
      source.etl_batch_id,
      CURRENT_TIMESTAMP(),
      NULL
    );
END;
$$;

-- Person Synchronization Procedure
CREATE OR REPLACE PROCEDURE data_vault.sync_person_satellites()
LANGUAGE SQL
AS $$
BEGIN
  -- 1. Update the current satellite with latest values from history
  MERGE INTO data_vault.sat_person_current target
  USING (
    SELECT 
      h.sat_person_key,
      h.hub_person_key,
      h.load_date,
      h.record_source,
      h.hash_diff,
      h.first_name,
      h.middle_name,
      h.last_name,
      h.given_name,
      h.family_name,
      h.birth_date,
      h.gender,
      h.marital_status,
      h.nationality,
      h.residence_country,
      h.ethnicity,
      h.religion,
      h.preferred_language,
      h.residential_status,
      h.effective_from,
      h.update_frequency,
      h.source_update_timestamp AS last_update_timestamp,
      h.etl_version,
      h.etl_batch_id
    FROM data_vault.sat_person_history h
    INNER JOIN (
      SELECT 
        hub_person_key, 
        MAX(load_date) AS latest_load_date
      FROM data_vault.sat_person_history
      WHERE is_current = TRUE
      GROUP BY hub_person_key
    ) latest 
    ON h.hub_person_key = latest.hub_person_key 
    AND h.load_date = latest.latest_load_date
  ) source
  ON target.hub_person_key = source.hub_person_key
  WHEN MATCHED AND target.hash_diff != source.hash_diff THEN
    UPDATE SET
      sat_person_key = source.sat_person_key,
      load_date = source.load_date,
      record_source = source.record_source,
      hash_diff = source.hash_diff,
      first_name = source.first_name,
      middle_name = source.middle_name,
      last_name = source.last_name,
      given_name = source.given_name,
      family_name = source.family_name,
      birth_date = source.birth_date,
      gender = source.gender,
      marital_status = source.marital_status,
      nationality = source.nationality,
      residence_country = source.residence_country,
      ethnicity = source.ethnicity,
      religion = source.religion,
      preferred_language = source.preferred_language,
      residential_status = source.residential_status,
      effective_from = source.effective_from,
      update_frequency = source.update_frequency,
      last_update_timestamp = source.last_update_timestamp,
      etl_version = source.etl_version,
      etl_batch_id = source.etl_batch_id,
      updated_at = CURRENT_TIMESTAMP()
  WHEN NOT MATCHED THEN
    INSERT (
      sat_person_key,
      hub_person_key,
      load_date,
      record_source,
      hash_diff,
      first_name,
      middle_name,
      last_name,
      given_name,
      family_name,
      birth_date,
      gender,
      marital_status,
      nationality,
      residence_country,
      ethnicity,
      religion,
      preferred_language,
      residential_status,
      effective_from,
      update_frequency,
      last_update_timestamp,
      etl_version,
      etl_batch_id,
      created_at,
      updated_at
    )
    VALUES (
      source.sat_person_key,
      source.hub_person_key,
      source.load_date,
      source.record_source,
      source.hash_diff,
      source.first_name,
      source.middle_name,
      source.last_name,
      source.given_name,
      source.family_name,
      source.birth_date,
      source.gender,
      source.marital_status,
      source.nationality,
      source.residence_country,
      source.ethnicity,
      source.religion,
      source.preferred_language,
      source.residential_status,
      source.effective_from,
      source.update_frequency,
      source.last_update_timestamp,
      source.etl_version,
      source.etl_batch_id,
      CURRENT_TIMESTAMP(),
      NULL
    );
END;
$$;

-- Schedule these procedures to run on appropriate intervals
-- For Hadoop/Spark environments:
-- CREATE SCHEDULED QUERY data_vault_satellites_sync
-- EVERY 15 MINUTES
-- EXECUTE data_vault.sync_party_satellites();
-- EXECUTE data_vault.sync_person_satellites();

-- For BigQuery:
/*
CREATE SCHEDULED QUERY `data_vault_party_sync_15min` 
OPTIONS (
  schedule='every 15 minutes',
  description='Synchronize party current and history satellites'
)
AS
CALL data_vault.sync_party_satellites();

CREATE SCHEDULED QUERY `data_vault_person_sync_15min` 
OPTIONS (
  schedule='every 15 minutes',
  description='Synchronize person current and history satellites'
)
AS
CALL data_vault.sync_person_satellites();
*/ 