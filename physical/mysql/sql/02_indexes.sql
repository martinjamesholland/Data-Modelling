-- MySQL Physical Data Model - Performance Indexes
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX

-- Additional performance indexes for optimal query performance

-- =====================================================
-- COMPOSITE INDEXES FOR COMMON QUERY PATTERNS
-- =====================================================

-- Party table composite indexes
CREATE INDEX idx_party_status_type ON party (status, party_type);
CREATE INDEX idx_party_source_system ON party (data_source_system, data_source_id, party_type);
CREATE INDEX idx_party_quality_golden ON party (data_quality_score, is_golden_record);
CREATE INDEX idx_party_created_status ON party (created_at, status);
CREATE INDEX idx_party_updated_status ON party (updated_at, status);

-- Person table composite indexes
CREATE INDEX idx_person_name_search ON person (last_name, first_name, middle_name);
CREATE INDEX idx_person_birth_gender ON person (birth_date, gender);
CREATE INDEX idx_person_nationality_country ON person (nationality, residence_country);

-- Organization table composite indexes
CREATE INDEX idx_organization_name_type ON organization (organization_name, organization_type);
CREATE INDEX idx_organization_industry_type ON organization (industry, organization_type);
CREATE INDEX idx_organization_quality_golden ON organization (data_quality_score, is_golden_record);

-- Party identification composite indexes
CREATE INDEX idx_identification_type_value ON party_identification (identification_type, identification_value);
CREATE INDEX idx_identification_party_type ON party_identification (party_id, identification_type);
CREATE INDEX idx_identification_quality_golden ON party_identification (data_quality_score, is_golden_record);

-- Party location composite indexes
CREATE INDEX idx_location_party_type ON party_location (party_id, location_type);
CREATE INDEX idx_location_quality_golden ON party_location (data_quality_score, is_golden_record);

-- Contact point composite indexes
CREATE INDEX idx_contact_party_type ON contact_point (party_id, contact_type);
CREATE INDEX idx_contact_type_value ON contact_point (contact_type, contact_value);
CREATE INDEX idx_contact_quality_golden ON contact_point (data_quality_score, is_golden_record);

-- Party relationship composite indexes
CREATE INDEX idx_relationship_party_type ON party_relationship (party_id, relationship_type);
CREATE INDEX idx_relationship_related_type ON party_relationship (related_party_id, relationship_type);
CREATE INDEX idx_relationship_bidirectional ON party_relationship (party_id, related_party_id);
CREATE INDEX idx_relationship_quality_golden ON party_relationship (data_quality_score, is_golden_record);

-- Person profile composite indexes
CREATE INDEX idx_profile_employment ON person_profile (employment_status, profession);
CREATE INDEX idx_profile_political ON person_profile (political_exposure_type, political_exposure_description(100));

-- Directory reference composite indexes
CREATE INDEX idx_directory_party_name ON party_directory_reference (party_id, directory_name);
CREATE INDEX idx_directory_verified ON party_directory_reference (is_verified, verification_date);
CREATE INDEX idx_directory_entry_search ON party_directory_reference (directory_name, directory_entry_id);

-- Merge history composite indexes
CREATE INDEX idx_merge_survivor_date ON party_merge_history (survivor_party_id, merge_date);
CREATE INDEX idx_merge_status_date ON party_merge_history (status, merge_date);
CREATE INDEX idx_merge_approved_date ON party_merge_history (approved_by, approval_date);

-- Match rule composite indexes
CREATE INDEX idx_match_rule_type_active ON party_match_rule (rule_type, is_active);
CREATE INDEX idx_match_rule_party_priority ON party_match_rule (party_type, priority, is_active);

-- Audit log composite indexes
CREATE INDEX idx_audit_party_action ON party_audit_log (party_id, action);
CREATE INDEX idx_audit_user_date ON party_audit_log (user_id, action_date);
CREATE INDEX idx_audit_entity_action ON party_audit_log (entity_name, action);
CREATE INDEX idx_audit_date_action ON party_audit_log (action_date, action);

-- Data quality composite indexes
CREATE INDEX idx_quality_party_date ON party_data_quality (party_id, assessment_date);
CREATE INDEX idx_quality_score_date ON party_data_quality (overall_score, assessment_date);
CREATE INDEX idx_quality_completeness ON party_data_quality (completeness_score, assessment_date);
CREATE INDEX idx_quality_accuracy ON party_data_quality (accuracy_score, assessment_date);

-- =====================================================
-- FULL-TEXT INDEXES FOR SEARCH FUNCTIONALITY
-- =====================================================

-- Full-text search indexes for name searches
CREATE FULLTEXT INDEX ft_party_name ON party (party_name);
CREATE FULLTEXT INDEX ft_person_names ON person (first_name, middle_name, last_name, given_name, family_name);
CREATE FULLTEXT INDEX ft_organization_name ON organization (organization_name);

-- Full-text search indexes for location and contact searches
CREATE FULLTEXT INDEX ft_location_value ON party_location (location_value);
CREATE FULLTEXT INDEX ft_contact_value ON contact_point (contact_value);

-- =====================================================
-- PARTITIONING INDEXES (for large tables)
-- =====================================================

-- Audit log partitioning by date (if table grows large)
-- Note: This would require table partitioning setup
-- CREATE INDEX idx_audit_partition_date ON party_audit_log (action_date);

-- Data quality partitioning by date (if table grows large)
-- Note: This would require table partitioning setup
-- CREATE INDEX idx_quality_partition_date ON party_data_quality (assessment_date);

-- =====================================================
-- COVERING INDEXES FOR FREQUENT QUERIES
-- =====================================================

-- Covering index for party list queries
CREATE INDEX idx_party_list_covering ON party (party_type, status, created_at, party_id, party_name, is_golden_record);

-- Covering index for person search
CREATE INDEX idx_person_search_covering ON person (last_name, first_name, party_id, birth_date, nationality);

-- Covering index for organization search
CREATE INDEX idx_organization_search_covering ON organization (organization_name, organization_type, party_id, industry);

-- Covering index for relationship queries
CREATE INDEX idx_relationship_covering ON party_relationship (party_id, relationship_type, related_party_id, created_at);

-- Covering index for audit queries
CREATE INDEX idx_audit_covering ON party_audit_log (party_id, action_date, action, user_id, entity_name);

-- =====================================================
-- FUNCTIONAL INDEXES (MySQL 8.0+)
-- =====================================================

-- Functional index for case-insensitive searches
CREATE INDEX idx_party_name_lower ON party ((LOWER(party_name)));
CREATE INDEX idx_person_last_name_lower ON person ((LOWER(last_name)));
CREATE INDEX idx_organization_name_lower ON organization ((LOWER(organization_name)));

-- Functional index for date-only searches
CREATE INDEX idx_party_created_date ON party ((DATE(created_at)));
CREATE INDEX idx_party_updated_date ON party ((DATE(updated_at)));
CREATE INDEX idx_audit_action_date_only ON party_audit_log ((DATE(action_date)));

-- =====================================================
-- STATISTICS AND OPTIMIZATION
-- =====================================================

-- Update table statistics for query optimizer
ANALYZE TABLE party;
ANALYZE TABLE person;
ANALYZE TABLE organization;
ANALYZE TABLE party_identification;
ANALYZE TABLE party_location;
ANALYZE TABLE contact_point;
ANALYZE TABLE party_relationship;
ANALYZE TABLE person_profile;
ANALYZE TABLE party_directory_reference;
ANALYZE TABLE party_merge_history;
ANALYZE TABLE party_match_rule;
ANALYZE TABLE party_audit_log;
ANALYZE TABLE party_data_quality; 