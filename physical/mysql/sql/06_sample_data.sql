-- MySQL Physical Data Model - Sample Data
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX

-- Sample data for testing and demonstration purposes

-- =====================================================
-- SAMPLE PARTY DATA
-- =====================================================

-- Sample Person Parties
INSERT INTO party (party_id, party_name, party_type, party_date_time, status, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, party_identification, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'John Smith', 'Person', '2024-01-15 10:30:00', 'Active', 'CRM_SYSTEM', 'CRM001', TRUE, 95.5, 98.0, '2024-01-10', 'SSN123456789', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440002', 'Jane Doe', 'Person', '2024-01-15 11:15:00', 'Active', 'CRM_SYSTEM', 'CRM002', TRUE, 92.0, 95.5, '2024-01-12', 'SSN987654321', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440003', 'Robert Johnson', 'Person', '2024-01-15 12:00:00', 'Active', 'ERP_SYSTEM', 'ERP001', TRUE, 88.5, 92.0, '2024-01-08', 'PASSPORT123456', 'STEWARD002', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440004', 'Maria Garcia', 'Person', '2024-01-15 13:30:00', 'Active', 'HR_SYSTEM', 'HR001', TRUE, 90.0, 94.5, '2024-01-14', 'DL123456789', 'STEWARD003', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440005', 'David Wilson', 'Person', '2024-01-15 14:45:00', 'Inactive', 'CRM_SYSTEM', 'CRM003', FALSE, 75.0, 80.0, '2024-01-05', 'SSN555666777', 'STEWARD001', NOW(), 'admin', NOW(), 'admin');

-- Sample Organization Parties
INSERT INTO party (party_id, party_name, party_type, party_date_time, status, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, party_identification, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440006', 'Acme Corporation', 'Organization', '2024-01-15 09:00:00', 'Active', 'ERP_SYSTEM', 'ERP002', TRUE, 96.0, 97.5, '2024-01-13', 'TAX123456789', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440007', 'TechStart Inc.', 'Organization', '2024-01-15 10:00:00', 'Active', 'CRM_SYSTEM', 'CRM004', TRUE, 89.5, 93.0, '2024-01-11', 'TAX987654321', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440008', 'Global Solutions Ltd.', 'Organization', '2024-01-15 11:00:00', 'Active', 'ERP_SYSTEM', 'ERP003', TRUE, 94.0, 96.0, '2024-01-09', 'TAX555666777', 'STEWARD005', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440009', 'City Government', 'Organization', '2024-01-15 12:00:00', 'Active', 'GOV_SYSTEM', 'GOV001', TRUE, 98.0, 99.0, '2024-01-15', 'GOV123456789', 'STEWARD006', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440010', 'NonProfit Foundation', 'Organization', '2024-01-15 13:00:00', 'Active', 'NPO_SYSTEM', 'NPO001', TRUE, 91.5, 94.0, '2024-01-12', 'NPO123456789', 'STEWARD007', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE PERSON DATA
-- =====================================================

INSERT INTO person (party_id, first_name, middle_name, last_name, given_name, family_name, birth_date, gender, marital_status, nationality, residence_country, ethnicity, religion, preferred_language, residential_status) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Michael', 'Smith', NULL, NULL, '1985-03-15', 'Male', 'Married', 'American', 'United States', 'Caucasian', 'Christian', 'English', 'Citizen'),
('550e8400-e29b-41d4-a716-446655440002', 'Jane', 'Elizabeth', 'Doe', NULL, NULL, '1990-07-22', 'Female', 'Single', 'American', 'United States', 'Hispanic', 'Catholic', 'English', 'Citizen'),
('550e8400-e29b-41d4-a716-446655440003', 'Robert', 'James', 'Johnson', NULL, NULL, '1978-11-08', 'Male', 'Divorced', 'Canadian', 'Canada', 'Caucasian', 'Protestant', 'English', 'Permanent Resident'),
('550e8400-e29b-41d4-a716-446655440004', 'Maria', 'Isabella', 'Garcia', NULL, NULL, '1988-05-12', 'Female', 'Married', 'Mexican', 'United States', 'Hispanic', 'Catholic', 'Spanish', 'Citizen'),
('550e8400-e29b-41d4-a716-446655440005', 'David', 'Thomas', 'Wilson', NULL, NULL, '1975-09-30', 'Male', 'Widowed', 'American', 'United States', 'African American', 'Baptist', 'English', 'Citizen');

-- =====================================================
-- SAMPLE ORGANIZATION DATA
-- =====================================================

INSERT INTO organization (party_id, organization_name, organization_type, industry, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
('550e8400-e29b-41d4-a716-446655440006', 'Acme Corporation', 'Company', 'Technology', 'ERP_SYSTEM', 'ERP002', TRUE, 96.0, 97.5, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440007', 'TechStart Inc.', 'Company', 'Software Development', 'CRM_SYSTEM', 'CRM004', TRUE, 89.5, 93.0, '2024-01-11', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440008', 'Global Solutions Ltd.', 'Company', 'Consulting', 'ERP_SYSTEM', 'ERP003', TRUE, 94.0, 96.0, '2024-01-09', 'STEWARD005', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440009', 'City Government', 'Government', 'Public Administration', 'GOV_SYSTEM', 'GOV001', TRUE, 98.0, 99.0, '2024-01-15', 'STEWARD006', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440010', 'NonProfit Foundation', 'Non-Profit', 'Education', 'NPO_SYSTEM', 'NPO001', TRUE, 91.5, 94.0, '2024-01-12', 'STEWARD007', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE CONTACT POINT DATA
-- =====================================================

INSERT INTO contact_point (party_id, contact_type, contact_value, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
-- John Smith contacts
('550e8400-e29b-41d4-a716-446655440001', 'Email', 'john.smith@email.com', 'CRM_SYSTEM', 'CRM001_EMAIL', TRUE, 95.0, 98.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440001', 'Phone', '+1-555-123-4567', 'CRM_SYSTEM', 'CRM001_PHONE', TRUE, 90.0, 95.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Jane Doe contacts
('550e8400-e29b-41d4-a716-446655440002', 'Email', 'jane.doe@email.com', 'CRM_SYSTEM', 'CRM002_EMAIL', TRUE, 92.0, 96.0, '2024-01-12', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440002', 'Phone', '+1-555-987-6543', 'CRM_SYSTEM', 'CRM002_PHONE', TRUE, 88.0, 92.0, '2024-01-12', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Robert Johnson contacts
('550e8400-e29b-41d4-a716-446655440003', 'Email', 'robert.johnson@email.com', 'ERP_SYSTEM', 'ERP001_EMAIL', TRUE, 89.0, 93.0, '2024-01-08', 'STEWARD002', NOW(), 'admin', NOW(), 'admin'),
-- Maria Garcia contacts
('550e8400-e29b-41d4-a716-446655440004', 'Email', 'maria.garcia@email.com', 'HR_SYSTEM', 'HR001_EMAIL', TRUE, 91.0, 95.0, '2024-01-14', 'STEWARD003', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440004', 'Phone', '+1-555-456-7890', 'HR_SYSTEM', 'HR001_PHONE', TRUE, 87.0, 91.0, '2024-01-14', 'STEWARD003', NOW(), 'admin', NOW(), 'admin'),
-- Organization contacts
('550e8400-e29b-41d4-a716-446655440006', 'Email', 'contact@acme.com', 'ERP_SYSTEM', 'ERP002_EMAIL', TRUE, 96.0, 98.0, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440006', 'Phone', '+1-555-000-1234', 'ERP_SYSTEM', 'ERP002_PHONE', TRUE, 94.0, 97.0, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440007', 'Email', 'info@techstart.com', 'CRM_SYSTEM', 'CRM004_EMAIL', TRUE, 90.0, 94.0, '2024-01-11', 'STEWARD004', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE LOCATION DATA
-- =====================================================

INSERT INTO party_location (party_id, location_type, location_value, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
-- John Smith locations
('550e8400-e29b-41d4-a716-446655440001', 'Physical', '123 Main Street, Apt 4B, New York, NY 10001', 'CRM_SYSTEM', 'CRM001_ADDR', TRUE, 93.0, 96.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440001', 'Postal', 'P.O. Box 123, New York, NY 10001', 'CRM_SYSTEM', 'CRM001_POBOX', FALSE, 85.0, 88.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Jane Doe locations
('550e8400-e29b-41d4-a716-446655440002', 'Physical', '456 Oak Avenue, Los Angeles, CA 90210', 'CRM_SYSTEM', 'CRM002_ADDR', TRUE, 91.0, 94.0, '2024-01-12', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Robert Johnson locations
('550e8400-e29b-41d4-a716-446655440003', 'Physical', '789 Maple Drive, Toronto, ON M5V 3A8', 'ERP_SYSTEM', 'ERP001_ADDR', TRUE, 89.0, 92.0, '2024-01-08', 'STEWARD002', NOW(), 'admin', NOW(), 'admin'),
-- Organization locations
('550e8400-e29b-41d4-a716-446655440006', 'Physical', '1000 Corporate Plaza, New York, NY 10001', 'ERP_SYSTEM', 'ERP002_ADDR', TRUE, 96.0, 98.0, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440007', 'Physical', '2000 Tech Park, San Francisco, CA 94105', 'CRM_SYSTEM', 'CRM004_ADDR', TRUE, 90.0, 93.0, '2024-01-11', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440008', 'Physical', '3000 Business Center, Chicago, IL 60601', 'ERP_SYSTEM', 'ERP003_ADDR', TRUE, 94.0, 96.0, '2024-01-09', 'STEWARD005', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE IDENTIFICATION DATA
-- =====================================================

INSERT INTO party_identification (party_id, identification_type, identification_value, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
-- John Smith identifications
('550e8400-e29b-41d4-a716-446655440001', 'TaxID', '123-45-6789', 'CRM_SYSTEM', 'CRM001_TAXID', TRUE, 95.0, 98.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440001', 'DriverLicense', 'DL123456789', 'CRM_SYSTEM', 'CRM001_DL', FALSE, 88.0, 92.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Jane Doe identifications
('550e8400-e29b-41d4-a716-446655440002', 'TaxID', '987-65-4321', 'CRM_SYSTEM', 'CRM002_TAXID', TRUE, 92.0, 96.0, '2024-01-12', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
-- Robert Johnson identifications
('550e8400-e29b-41d4-a716-446655440003', 'Passport', 'CA123456789', 'ERP_SYSTEM', 'ERP001_PASSPORT', TRUE, 89.0, 93.0, '2024-01-08', 'STEWARD002', NOW(), 'admin', NOW(), 'admin'),
-- Organization identifications
('550e8400-e29b-41d4-a716-446655440006', 'TaxID', '12-3456789', 'ERP_SYSTEM', 'ERP002_TAXID', TRUE, 96.0, 98.0, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440007', 'TaxID', '98-7654321', 'CRM_SYSTEM', 'CRM004_TAXID', TRUE, 90.0, 94.0, '2024-01-11', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440008', 'TaxID', '55-6667777', 'ERP_SYSTEM', 'ERP003_TAXID', TRUE, 94.0, 96.0, '2024-01-09', 'STEWARD005', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE RELATIONSHIP DATA
-- =====================================================

INSERT INTO party_relationship (party_id, related_party_id, relationship_type, data_source_system, data_source_id, is_golden_record, data_quality_score, confidence_score, last_verified_date, data_steward_id, created_at, created_by, updated_at, updated_by) VALUES
-- Customer relationships
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'Customer', 'CRM_SYSTEM', 'CRM001_REL', TRUE, 95.0, 98.0, '2024-01-10', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440007', 'Customer', 'CRM_SYSTEM', 'CRM002_REL', TRUE, 92.0, 96.0, '2024-01-12', 'STEWARD001', NOW(), 'admin', NOW(), 'admin'),
('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008', 'Customer', 'ERP_SYSTEM', 'ERP001_REL', TRUE, 89.0, 93.0, '2024-01-08', 'STEWARD002', NOW(), 'admin', NOW(), 'admin'),
-- Supplier relationships
('550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440007', 'Supplier', 'ERP_SYSTEM', 'ERP002_SUPPLIER', TRUE, 96.0, 98.0, '2024-01-13', 'STEWARD004', NOW(), 'admin', NOW(), 'admin'),
-- Partner relationships
('550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440008', 'Partner', 'CRM_SYSTEM', 'CRM004_PARTNER', TRUE, 90.0, 94.0, '2024-01-11', 'STEWARD004', NOW(), 'admin', NOW(), 'admin');

-- =====================================================
-- SAMPLE PERSON PROFILE DATA
-- =====================================================

INSERT INTO person_profile (party_id, political_exposure_type, political_exposure_description, education_level, profession, income_range, wealth_source, employment_status, employer_name, job_title, family_size) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'None', NULL, 'Bachelor''s Degree', 'Software Engineer', '$75,000 - $100,000', 'Employment', 'Employed', 'Acme Corporation', 'Senior Developer', 3),
('550e8400-e29b-41d4-a716-446655440002', 'None', NULL, 'Master''s Degree', 'Marketing Manager', '$100,000 - $150,000', 'Employment', 'Employed', 'TechStart Inc.', 'Marketing Director', 2),
('550e8400-e29b-41d4-a716-446655440003', 'Foreign', 'Business dealings in multiple countries', 'PhD', 'Consultant', '$150,000 - $200,000', 'Business Ownership', 'Self-Employed', 'Global Solutions Ltd.', 'Principal Consultant', 4),
('550e8400-e29b-41d4-a716-446655440004', 'None', NULL, 'Bachelor''s Degree', 'Human Resources Specialist', '$50,000 - $75,000', 'Employment', 'Employed', 'City Government', 'HR Coordinator', 2);

-- =====================================================
-- SAMPLE DIRECTORY REFERENCE DATA
-- =====================================================

INSERT INTO party_directory_reference (party_id, directory_name, directory_entry_id, directory_entry_type, directory_entry_date, directory_valid_period, is_verified, verification_date, verification_method, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'LinkedIn', 'john-smith-12345', 'Professional Profile', '2024-01-10', 'Ongoing', TRUE, '2024-01-10', 'Email Verification', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'LinkedIn', 'jane-doe-67890', 'Professional Profile', '2024-01-12', 'Ongoing', TRUE, '2024-01-12', 'Email Verification', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440006', 'Dun & Bradstreet', 'DUNS123456789', 'Business Profile', '2024-01-13', 'Annual', TRUE, '2024-01-13', 'Phone Verification', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440007', 'Dun & Bradstreet', 'DUNS987654321', 'Business Profile', '2024-01-11', 'Annual', TRUE, '2024-01-11', 'Phone Verification', NOW(), NOW());

-- =====================================================
-- SAMPLE MATCH RULE DATA
-- =====================================================

INSERT INTO party_match_rule (rule_name, rule_description, rule_type, rule_definition, threshold, priority, party_type, is_active, created_at, updated_at, created_by, updated_by) VALUES
('Exact Name Match', 'Exact match on party name', 'Exact', '{"fields": ["party_name"], "case_sensitive": true}', 100.0, 1, 'Both', TRUE, NOW(), NOW(), 'admin', 'admin'),
('Fuzzy Name Match', 'Fuzzy match on party name using Levenshtein distance', 'Fuzzy', '{"fields": ["party_name"], "algorithm": "levenshtein", "max_distance": 2}', 85.0, 2, 'Both', TRUE, NOW(), NOW(), 'admin', 'admin'),
('Person Identity Match', 'Match on person identification fields', 'Deterministic', '{"fields": ["first_name", "last_name", "birth_date"], "required_fields": ["first_name", "last_name"]}', 90.0, 3, 'Person', TRUE, NOW(), NOW(), 'admin', 'admin'),
('Organization Tax ID Match', 'Match on organization tax identification', 'Exact', '{"fields": ["identification_value"], "identification_type": "TaxID"}', 100.0, 1, 'Organization', TRUE, NOW(), NOW(), 'admin', 'admin'),
('Email Contact Match', 'Match on email contact information', 'Exact', '{"fields": ["contact_value"], "contact_type": "Email"}', 95.0, 4, 'Both', TRUE, NOW(), NOW(), 'admin', 'admin');

-- =====================================================
-- SAMPLE DATA QUALITY ASSESSMENTS
-- =====================================================

INSERT INTO party_data_quality (party_id, assessment_date, completeness_score, accuracy_score, consistency_score, timeliness_score, uniqueness_score, overall_score, issues_found, improvement_suggestions, created_at, created_by) VALUES
('550e8400-e29b-41d4-a716-446655440001', '2024-01-15 10:30:00', 95.0, 98.0, 96.0, 97.0, 95.0, 96.2, '["Minor: Missing middle name verification"]', '["Verify middle name with official documents"]', NOW(), 'SYSTEM'),
('550e8400-e29b-41d4-a716-446655440002', '2024-01-15 11:15:00', 92.0, 95.5, 94.0, 96.0, 93.0, 94.1, '["Minor: Incomplete address information"]', '["Add postal code to address"]', NOW(), 'SYSTEM'),
('550e8400-e29b-41d4-a716-446655440003', '2024-01-15 12:00:00', 88.5, 92.0, 90.0, 94.0, 89.0, 90.7, '["Moderate: Missing contact phone number", "Minor: Incomplete employment information"]', '["Add phone number", "Update employment details"]', NOW(), 'SYSTEM'),
('550e8400-e29b-41d4-a716-446655440006', '2024-01-15 09:00:00', 96.0, 97.5, 98.0, 99.0, 96.0, 97.3, '["Minor: Missing industry classification"]', '["Add detailed industry classification"]', NOW(), 'SYSTEM'),
('550e8400-e29b-41d4-a716-446655440007', '2024-01-15 10:00:00', 89.5, 93.0, 91.0, 95.0, 90.0, 91.7, '["Moderate: Incomplete business address", "Minor: Missing website information"]', '["Complete business address", "Add website URL"]', NOW(), 'SYSTEM');

-- =====================================================
-- SAMPLE AUDIT LOG ENTRIES
-- =====================================================

INSERT INTO party_audit_log (party_id, entity_name, action, action_date, user_id, ip_address, old_values, new_values, change_reason, source_system) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'party', 'Create', '2024-01-15 10:30:00', 'admin', '192.168.1.100', NULL, '{"party_name": "John Smith", "party_type": "Person", "status": "Active"}', 'Initial party creation', 'CRM_SYSTEM'),
('550e8400-e29b-41d4-a716-446655440001', 'person', 'Create', '2024-01-15 10:30:00', 'SYSTEM', NULL, NULL, '{"first_name": "John", "last_name": "Smith", "birth_date": "1985-03-15"}', 'Person data creation', 'CRM_SYSTEM'),
('550e8400-e29b-41d4-a716-446655440001', 'contact_point', 'Create', '2024-01-15 10:31:00', 'admin', '192.168.1.100', NULL, '{"contact_type": "Email", "contact_value": "john.smith@email.com"}', 'Contact information added', 'CRM_SYSTEM'),
('550e8400-e29b-41d4-a716-446655440002', 'party', 'Create', '2024-01-15 11:15:00', 'admin', '192.168.1.100', NULL, '{"party_name": "Jane Doe", "party_type": "Person", "status": "Active"}', 'Initial party creation', 'CRM_SYSTEM'),
('550e8400-e29b-41d4-a716-446655440006', 'party', 'Create', '2024-01-15 09:00:00', 'admin', '192.168.1.100', NULL, '{"party_name": "Acme Corporation", "party_type": "Organization", "status": "Active"}', 'Initial party creation', 'ERP_SYSTEM'),
('550e8400-e29b-41d4-a716-446655440006', 'organization', 'Create', '2024-01-15 09:00:00', 'admin', '192.168.1.100', NULL, '{"organization_name": "Acme Corporation", "organization_type": "Company", "industry": "Technology"}', 'Organization data creation', 'ERP_SYSTEM');

-- =====================================================
-- SAMPLE MERGE HISTORY
-- =====================================================

INSERT INTO party_merge_history (survivor_party_id, merged_party_id, merge_date, merge_reason, merge_score, merge_rule, approved_by, approval_date, merged_record_json, status, created_at, created_by) VALUES
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', '2024-01-14 15:30:00', 'Duplicate person records identified', 95.5, 'Fuzzy Name Match', 'admin', '2024-01-14 15:30:00', '{"merge_criteria": ["name_similarity", "birth_date_match", "contact_match"]}', 'Approved', NOW(), 'admin'); 