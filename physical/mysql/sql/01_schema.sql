-- MySQL Physical Data Model - Schema Creation
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX
-- Based on ALDM v1.0.0

-- Set character set and collation
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- CORE TABLES
-- =====================================================

-- Main party entity table
CREATE TABLE party (
    party_id VARCHAR(36) NOT NULL COMMENT 'Unique identifier for the party (UUID)',
    party_name VARCHAR(255) NOT NULL COMMENT 'The name of the party as it is known in business',
    party_type ENUM('Person', 'Organization') NOT NULL COMMENT 'Type of party (Person or Organization)',
    party_date_time DATETIME NOT NULL COMMENT 'Date and time when the party record was created',
    status ENUM('Active', 'Inactive', 'Merged', 'Deleted') NOT NULL DEFAULT 'Active' COMMENT 'Current status of the party',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this party data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this party in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    party_identification VARCHAR(100) NULL COMMENT 'A general identification for the party (e.g., TaxID)',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this party',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (party_id),
    INDEX idx_party_type (party_type),
    INDEX idx_status (status),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_created_at (created_at),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Main party entity table';

-- Person-specific information
CREATE TABLE person (
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    first_name VARCHAR(100) NOT NULL COMMENT 'First name of the person',
    middle_name VARCHAR(100) NULL COMMENT 'Middle name of the person',
    last_name VARCHAR(100) NOT NULL COMMENT 'Last name of the person',
    given_name VARCHAR(100) NULL COMMENT 'Given name of the person (if different from first name)',
    family_name VARCHAR(100) NULL COMMENT 'Family name of the person (if different from last name)',
    birth_date DATE NULL COMMENT 'Date of birth',
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say') NULL COMMENT 'Gender of the person',
    marital_status ENUM('Single', 'Married', 'Divorced', 'Widowed', 'Separated', 'Other') NULL COMMENT 'Marital status of the person',
    nationality VARCHAR(100) NULL COMMENT 'Nationality of the person',
    residence_country VARCHAR(100) NULL COMMENT 'Country of residence',
    ethnicity VARCHAR(100) NULL COMMENT 'Ethnicity of the person',
    religion VARCHAR(100) NULL COMMENT 'Religion of the person',
    preferred_language VARCHAR(50) NULL COMMENT 'Preferred language for communication',
    residential_status VARCHAR(100) NULL COMMENT 'Residential status in the country of residence',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (party_id),
    INDEX idx_last_name (last_name),
    INDEX idx_birth_date (birth_date),
    INDEX idx_nationality (nationality),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_person_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Person-specific information';

-- Organization-specific information
CREATE TABLE organization (
    party_id VARCHAR(36) NOT NULL COMMENT 'Unique identifier for the organization',
    organization_name VARCHAR(255) NOT NULL COMMENT 'The name of the organization',
    organization_type ENUM('Company', 'Government', 'Non-Profit', 'Educational', 'Other') NOT NULL COMMENT 'Type of organization',
    industry VARCHAR(100) NULL COMMENT 'Industry of the organization',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this organization data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this organization in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this organization',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (party_id),
    INDEX idx_organization_name (organization_name),
    INDEX idx_organization_type (organization_type),
    INDEX idx_industry (industry),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_organization_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Organization-specific information';

-- Party identification documents
CREATE TABLE party_identification (
    identification_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this identification record',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    identification_type ENUM('TaxID', 'Passport', 'DriverLicense', 'Other') NOT NULL COMMENT 'Type of identification',
    identification_value VARCHAR(255) NOT NULL COMMENT 'Value of the identification',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this identification data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this identification in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this identification',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (identification_id),
    UNIQUE KEY uk_party_identification (party_id, identification_type, identification_value),
    INDEX idx_party_id (party_id),
    INDEX idx_identification_type (identification_type),
    INDEX idx_identification_value (identification_value),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_party_identification_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Party identification documents';

-- Party location information
CREATE TABLE party_location (
    location_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this location record',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    location_type ENUM('Physical', 'Postal', 'Electronic', 'Other') NOT NULL COMMENT 'Type of location',
    location_value TEXT NOT NULL COMMENT 'Value of the location',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this location data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this location in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this location',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (location_id),
    INDEX idx_party_id (party_id),
    INDEX idx_location_type (location_type),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_party_location_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Party location information';

-- Party contact information
CREATE TABLE contact_point (
    contact_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this contact record',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    contact_type ENUM('Phone', 'Email', 'SocialMedia', 'Other') NOT NULL COMMENT 'Type of contact',
    contact_value VARCHAR(255) NOT NULL COMMENT 'Value of the contact',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this contact data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this contact in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this contact',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (contact_id),
    UNIQUE KEY uk_party_contact (party_id, contact_type, contact_value),
    INDEX idx_party_id (party_id),
    INDEX idx_contact_type (contact_type),
    INDEX idx_contact_value (contact_value),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_contact_point_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Party contact information';

-- Relationships between parties
CREATE TABLE party_relationship (
    relationship_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this relationship',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity (from party)',
    related_party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the related Party entity (to party)',
    relationship_type ENUM('Customer', 'Supplier', 'Partner', 'Other') NOT NULL COMMENT 'Type of relationship',
    data_source_system VARCHAR(100) NOT NULL COMMENT 'System where this relationship data originated',
    data_source_id VARCHAR(100) NULL COMMENT 'ID of this relationship in the source system',
    is_golden_record BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this is the golden record',
    data_quality_score DECIMAL(5,2) NULL COMMENT 'Calculated data quality score from 0-100',
    confidence_score DECIMAL(5,2) NULL COMMENT 'Confidence level in the correctness of this record',
    last_verified_date DATE NULL COMMENT 'Date when this record was last verified',
    data_steward_id VARCHAR(100) NULL COMMENT 'ID of the data steward responsible for this relationship',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this record',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (relationship_id),
    UNIQUE KEY uk_party_relationship (party_id, related_party_id, relationship_type),
    INDEX idx_party_id (party_id),
    INDEX idx_related_party_id (related_party_id),
    INDEX idx_relationship_type (relationship_type),
    INDEX idx_data_source (data_source_system, data_source_id),
    INDEX idx_golden_record (is_golden_record),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_party_relationship_party_from FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE,
    CONSTRAINT fk_party_relationship_party_to FOREIGN KEY (related_party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relationships between parties';

-- =====================================================
-- SUPPORTING TABLES
-- =====================================================

-- Additional person information
CREATE TABLE person_profile (
    person_profile_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this profile',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    political_exposure_type ENUM('Foreign', 'Domestic', 'None') NULL COMMENT 'Type of political exposure',
    political_exposure_description TEXT NULL COMMENT 'Description of the political exposure',
    education_level VARCHAR(100) NULL COMMENT 'Highest level of education',
    profession VARCHAR(100) NULL COMMENT 'Current profession',
    income_range VARCHAR(100) NULL COMMENT 'Income range',
    wealth_source VARCHAR(100) NULL COMMENT 'Source of wealth',
    employment_status ENUM('Employed', 'Unemployed', 'Self-Employed', 'Retired', 'Student', 'Other') NULL COMMENT 'Current employment status',
    employer_name VARCHAR(255) NULL COMMENT 'Name of the employer',
    job_title VARCHAR(100) NULL COMMENT 'Job title',
    family_size INT NULL COMMENT 'Number of family members',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (person_profile_id),
    UNIQUE KEY uk_person_profile_party (party_id),
    INDEX idx_political_exposure (political_exposure_type),
    INDEX idx_employment_status (employment_status),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_person_profile_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Additional person information';

-- External directory references
CREATE TABLE party_directory_reference (
    party_directory_reference_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this reference',
    party_id VARCHAR(36) NOT NULL COMMENT 'Foreign key to the Party entity',
    directory_name VARCHAR(100) NOT NULL COMMENT 'Name of the external directory',
    directory_entry_id VARCHAR(255) NOT NULL COMMENT 'ID of the party in the external directory',
    directory_entry_type VARCHAR(100) NULL COMMENT 'Type of entry in the directory',
    directory_entry_date DATE NULL COMMENT 'Date of the entry in the directory',
    directory_valid_period VARCHAR(100) NULL COMMENT 'Period for which the directory entry is valid',
    is_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Flag indicating if this reference has been verified',
    verification_date DATE NULL COMMENT 'Date when this reference was verified',
    verification_method VARCHAR(100) NULL COMMENT 'Method used to verify this reference',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    deleted_at TIMESTAMP NULL COMMENT 'Date and time when this record was marked as deleted',
    PRIMARY KEY (party_directory_reference_id),
    UNIQUE KEY uk_directory_reference (party_id, directory_name, directory_entry_id),
    INDEX idx_party_id (party_id),
    INDEX idx_directory_name (directory_name),
    INDEX idx_directory_entry_id (directory_entry_id),
    INDEX idx_is_verified (is_verified),
    INDEX idx_deleted_at (deleted_at),
    CONSTRAINT fk_party_directory_reference_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reference to a party in an external directory';

-- Merge operation history
CREATE TABLE party_merge_history (
    party_merge_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this merge record',
    survivor_party_id VARCHAR(36) NOT NULL COMMENT 'ID of the surviving party',
    merged_party_id VARCHAR(36) NOT NULL COMMENT 'ID of the merged party',
    merge_date DATETIME NOT NULL COMMENT 'Date and time when the merge occurred',
    merge_reason TEXT NULL COMMENT 'Reason for the merge',
    merge_score DECIMAL(5,2) NULL COMMENT 'Confidence score for the merge',
    merge_rule VARCHAR(100) NULL COMMENT 'Rule used for the merge',
    approved_by VARCHAR(100) NULL COMMENT 'User who approved the merge',
    approval_date DATETIME NULL COMMENT 'Date and time when the merge was approved',
    merged_record_json JSON NULL COMMENT 'JSON representation of the merged record',
    status ENUM('Pending', 'Approved', 'Rejected', 'Undone') NOT NULL DEFAULT 'Pending' COMMENT 'Current status of the merge',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this record',
    PRIMARY KEY (party_merge_id),
    INDEX idx_survivor_party_id (survivor_party_id),
    INDEX idx_merged_party_id (merged_party_id),
    INDEX idx_merge_date (merge_date),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_party_merge_history_survivor FOREIGN KEY (survivor_party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='History of party merges in the MDM system';

-- Matching rules configuration
CREATE TABLE party_match_rule (
    match_rule_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this match rule',
    rule_name VARCHAR(100) NOT NULL COMMENT 'Name of the match rule',
    rule_description TEXT NULL COMMENT 'Description of the match rule',
    rule_type ENUM('Exact', 'Fuzzy', 'Deterministic', 'Probabilistic', 'Hybrid') NOT NULL COMMENT 'Type of match rule',
    rule_definition JSON NOT NULL COMMENT 'Definition of the match rule in JSON format',
    threshold DECIMAL(5,2) NOT NULL COMMENT 'Threshold for considering a match',
    priority INT NOT NULL COMMENT 'Priority of this rule in the matching hierarchy',
    party_type ENUM('Person', 'Organization', 'Both') NULL COMMENT 'Type of party this rule applies to',
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Flag indicating if this rule is active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date and time when this record was last updated',
    created_by VARCHAR(100) NOT NULL COMMENT 'User who created this rule',
    updated_by VARCHAR(100) NOT NULL COMMENT 'User who last updated this rule',
    PRIMARY KEY (match_rule_id),
    UNIQUE KEY uk_rule_name (rule_name),
    INDEX idx_rule_type (rule_type),
    INDEX idx_party_type (party_type),
    INDEX idx_is_active (is_active),
    INDEX idx_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rules for matching parties in the MDM system';

-- Audit trail
CREATE TABLE party_audit_log (
    audit_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this audit record',
    party_id VARCHAR(36) NOT NULL COMMENT 'ID of the party being audited',
    entity_name VARCHAR(100) NOT NULL COMMENT 'Name of the entity being audited',
    action ENUM('Create', 'Update', 'Delete', 'Merge', 'Split', 'Link', 'Unlink') NOT NULL COMMENT 'Action performed on the entity',
    action_date DATETIME NOT NULL COMMENT 'Date and time when the action was performed',
    user_id VARCHAR(100) NOT NULL COMMENT 'ID of the user who performed the action',
    ip_address VARCHAR(45) NULL COMMENT 'IP address from which the action was performed',
    old_values JSON NULL COMMENT 'JSON representation of the old values',
    new_values JSON NULL COMMENT 'JSON representation of the new values',
    change_reason TEXT NULL COMMENT 'Reason for the change',
    source_system VARCHAR(100) NULL COMMENT 'System from which the change originated',
    PRIMARY KEY (audit_id),
    INDEX idx_party_id (party_id),
    INDEX idx_entity_name (entity_name),
    INDEX idx_action (action),
    INDEX idx_action_date (action_date),
    INDEX idx_user_id (user_id),
    INDEX idx_source_system (source_system),
    CONSTRAINT fk_party_audit_log_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Audit log for party data changes in the MDM system';

-- Data quality metrics
CREATE TABLE party_data_quality (
    data_quality_id BIGINT AUTO_INCREMENT NOT NULL COMMENT 'Unique identifier for this data quality record',
    party_id VARCHAR(36) NOT NULL COMMENT 'ID of the party being assessed',
    assessment_date DATETIME NOT NULL COMMENT 'Date and time when the assessment was performed',
    completeness_score DECIMAL(5,2) NOT NULL COMMENT 'Score for data completeness (0-100)',
    accuracy_score DECIMAL(5,2) NOT NULL COMMENT 'Score for data accuracy (0-100)',
    consistency_score DECIMAL(5,2) NOT NULL COMMENT 'Score for data consistency (0-100)',
    timeliness_score DECIMAL(5,2) NOT NULL COMMENT 'Score for data timeliness (0-100)',
    uniqueness_score DECIMAL(5,2) NOT NULL COMMENT 'Score for data uniqueness (0-100)',
    overall_score DECIMAL(5,2) NOT NULL COMMENT 'Overall data quality score (0-100)',
    issues_found JSON NULL COMMENT 'JSON representation of data quality issues found',
    improvement_suggestions JSON NULL COMMENT 'JSON representation of suggestions for improvement',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time when this record was created',
    created_by VARCHAR(100) NOT NULL COMMENT 'User or system that created this record',
    PRIMARY KEY (data_quality_id),
    INDEX idx_party_id (party_id),
    INDEX idx_assessment_date (assessment_date),
    INDEX idx_overall_score (overall_score),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_party_data_quality_party FOREIGN KEY (party_id) REFERENCES party (party_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Data quality metrics for party data in the MDM system';

SET FOREIGN_KEY_CHECKS = 1; 