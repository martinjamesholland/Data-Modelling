-- MySQL Physical Data Model - Database Views
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX

-- Database views for common queries and reporting purposes

-- =====================================================
-- CORE PARTY VIEWS
-- =====================================================

-- Complete party information view (excluding soft deleted records)
CREATE VIEW v_party_complete AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    p.party_date_time,
    p.status,
    p.data_source_system,
    p.data_source_id,
    p.is_golden_record,
    p.data_quality_score,
    p.confidence_score,
    p.last_verified_date,
    p.party_identification,
    p.data_steward_id,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by,
    -- Person specific fields
    per.first_name,
    per.middle_name,
    per.last_name,
    per.given_name,
    per.family_name,
    per.birth_date,
    per.gender,
    per.marital_status,
    per.nationality,
    per.residence_country,
    per.ethnicity,
    per.religion,
    per.preferred_language,
    per.residential_status,
    -- Organization specific fields
    org.organization_name,
    org.organization_type,
    org.industry,
    -- Profile information
    pp.political_exposure_type,
    pp.political_exposure_description,
    pp.education_level,
    pp.profession,
    pp.income_range,
    pp.wealth_source,
    pp.employment_status,
    pp.employer_name,
    pp.job_title,
    pp.family_size
FROM party p
LEFT JOIN person per ON p.party_id = per.party_id AND per.deleted_at IS NULL
LEFT JOIN organization org ON p.party_id = org.party_id AND org.deleted_at IS NULL
LEFT JOIN person_profile pp ON p.party_id = pp.party_id AND pp.deleted_at IS NULL
WHERE p.deleted_at IS NULL;

-- Active parties view
CREATE VIEW v_party_active AS
SELECT 
    party_id,
    party_name,
    party_type,
    status,
    data_source_system,
    is_golden_record,
    data_quality_score,
    confidence_score,
    created_at,
    updated_at
FROM party
WHERE status = 'Active' AND deleted_at IS NULL;

-- Golden records view
CREATE VIEW v_party_golden_records AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    p.status,
    p.data_source_system,
    p.data_quality_score,
    p.confidence_score,
    p.last_verified_date,
    p.created_at,
    p.updated_at,
    -- Person specific fields
    per.first_name,
    per.middle_name,
    per.last_name,
    per.birth_date,
    per.gender,
    per.nationality,
    -- Organization specific fields
    org.organization_name,
    org.organization_type,
    org.industry
FROM party p
LEFT JOIN person per ON p.party_id = per.party_id AND per.deleted_at IS NULL
LEFT JOIN organization org ON p.party_id = org.party_id AND org.deleted_at IS NULL
WHERE p.is_golden_record = TRUE AND p.deleted_at IS NULL;

-- =====================================================
-- CONTACT AND LOCATION VIEWS
-- =====================================================

-- Party contact information view
CREATE VIEW v_party_contacts AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    cp.contact_id,
    cp.contact_type,
    cp.contact_value,
    cp.is_golden_record,
    cp.data_quality_score,
    cp.last_verified_date,
    cp.created_at,
    cp.updated_at
FROM party p
JOIN contact_point cp ON p.party_id = cp.party_id AND cp.deleted_at IS NULL
WHERE p.deleted_at IS NULL
ORDER BY p.party_id, cp.contact_type;

-- Party location information view
CREATE VIEW v_party_locations AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    pl.location_id,
    pl.location_type,
    pl.location_value,
    pl.is_golden_record,
    pl.data_quality_score,
    pl.last_verified_date,
    pl.created_at,
    pl.updated_at
FROM party p
JOIN party_location pl ON p.party_id = pl.party_id AND pl.deleted_at IS NULL
WHERE p.deleted_at IS NULL
ORDER BY p.party_id, pl.location_type;

-- Party identification view
CREATE VIEW v_party_identifications AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    pi.identification_id,
    pi.identification_type,
    pi.identification_value,
    pi.is_golden_record,
    pi.data_quality_score,
    pi.last_verified_date,
    pi.created_at,
    pi.updated_at
FROM party p
JOIN party_identification pi ON p.party_id = pi.party_id AND pi.deleted_at IS NULL
WHERE p.deleted_at IS NULL
ORDER BY p.party_id, pi.identification_type;

-- =====================================================
-- RELATIONSHIP VIEWS
-- =====================================================

-- Party relationships view
CREATE VIEW v_party_relationships AS
SELECT 
    pr.relationship_id,
    p1.party_id AS from_party_id,
    p1.party_name AS from_party_name,
    p1.party_type AS from_party_type,
    p2.party_id AS to_party_id,
    p2.party_name AS to_party_name,
    p2.party_type AS to_party_type,
    pr.relationship_type,
    pr.data_source_system,
    pr.is_golden_record,
    pr.data_quality_score,
    pr.confidence_score,
    pr.last_verified_date,
    pr.created_at,
    pr.updated_at
FROM party_relationship pr
JOIN party p1 ON pr.party_id = p1.party_id AND p1.deleted_at IS NULL
JOIN party p2 ON pr.related_party_id = p2.party_id AND p2.deleted_at IS NULL
WHERE pr.deleted_at IS NULL
ORDER BY pr.party_id, pr.relationship_type;

-- Customer relationships view
CREATE VIEW v_customer_relationships AS
SELECT 
    pr.relationship_id,
    p1.party_id AS customer_id,
    p1.party_name AS customer_name,
    p1.party_type AS customer_type,
    p2.party_id AS related_party_id,
    p2.party_name AS related_party_name,
    p2.party_type AS related_party_type,
    pr.relationship_type,
    pr.data_source_system,
    pr.is_golden_record,
    pr.data_quality_score,
    pr.created_at,
    pr.updated_at
FROM party_relationship pr
JOIN party p1 ON pr.party_id = p1.party_id AND p1.deleted_at IS NULL
JOIN party p2 ON pr.related_party_id = p2.party_id AND p2.deleted_at IS NULL
WHERE pr.relationship_type = 'Customer' AND pr.deleted_at IS NULL
ORDER BY p1.party_id;

-- =====================================================
-- DATA QUALITY VIEWS
-- =====================================================

-- Data quality summary view
CREATE VIEW v_data_quality_summary AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    p.data_quality_score AS party_quality_score,
    p.confidence_score AS party_confidence_score,
    pdq.assessment_date,
    pdq.completeness_score,
    pdq.accuracy_score,
    pdq.consistency_score,
    pdq.timeliness_score,
    pdq.uniqueness_score,
    pdq.overall_score,
    pdq.issues_found,
    pdq.improvement_suggestions,
    pdq.created_at AS quality_assessment_created
FROM party p
LEFT JOIN party_data_quality pdq ON p.party_id = pdq.party_id
WHERE p.deleted_at IS NULL
ORDER BY pdq.assessment_date DESC, p.party_id;

-- Data quality issues view
CREATE VIEW v_data_quality_issues AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    pdq.assessment_date,
    pdq.overall_score,
    pdq.issues_found,
    pdq.improvement_suggestions,
    CASE 
        WHEN pdq.overall_score < 50 THEN 'Critical'
        WHEN pdq.overall_score < 75 THEN 'Warning'
        ELSE 'Good'
    END AS quality_status
FROM party p
JOIN party_data_quality pdq ON p.party_id = pdq.party_id
WHERE p.deleted_at IS NULL AND pdq.overall_score < 75
ORDER BY pdq.overall_score ASC, pdq.assessment_date DESC;

-- =====================================================
-- AUDIT AND HISTORY VIEWS
-- =====================================================

-- Recent audit activity view
CREATE VIEW v_recent_audit_activity AS
SELECT 
    pal.audit_id,
    p.party_name,
    p.party_type,
    pal.entity_name,
    pal.action,
    pal.action_date,
    pal.user_id,
    pal.ip_address,
    pal.change_reason,
    pal.source_system
FROM party_audit_log pal
JOIN party p ON pal.party_id = p.party_id AND p.deleted_at IS NULL
ORDER BY pal.action_date DESC
LIMIT 1000;

-- Party merge history view
CREATE VIEW v_party_merge_history AS
SELECT 
    pmh.party_merge_id,
    p1.party_name AS survivor_party_name,
    p1.party_type AS survivor_party_type,
    pmh.survivor_party_id,
    pmh.merged_party_id,
    pmh.merge_date,
    pmh.merge_reason,
    pmh.merge_score,
    pmh.merge_rule,
    pmh.approved_by,
    pmh.approval_date,
    pmh.status,
    pmh.created_at,
    pmh.created_by
FROM party_merge_history pmh
JOIN party p1 ON pmh.survivor_party_id = p1.party_id AND p1.deleted_at IS NULL
ORDER BY pmh.merge_date DESC;

-- =====================================================
-- REPORTING VIEWS
-- =====================================================

-- Party statistics view
CREATE VIEW v_party_statistics AS
SELECT 
    party_type,
    status,
    data_source_system,
    COUNT(*) AS total_count,
    SUM(CASE WHEN is_golden_record = TRUE THEN 1 ELSE 0 END) AS golden_record_count,
    AVG(data_quality_score) AS avg_data_quality_score,
    AVG(confidence_score) AS avg_confidence_score,
    MIN(created_at) AS earliest_created,
    MAX(created_at) AS latest_created
FROM party
WHERE deleted_at IS NULL
GROUP BY party_type, status, data_source_system
ORDER BY party_type, status, data_source_system;

-- Data source summary view
CREATE VIEW v_data_source_summary AS
SELECT 
    data_source_system,
    party_type,
    COUNT(*) AS total_records,
    SUM(CASE WHEN is_golden_record = TRUE THEN 1 ELSE 0 END) AS golden_records,
    AVG(data_quality_score) AS avg_quality_score,
    AVG(confidence_score) AS avg_confidence_score,
    COUNT(DISTINCT data_steward_id) AS unique_stewards,
    MIN(created_at) AS first_record_date,
    MAX(created_at) AS last_record_date
FROM party
WHERE deleted_at IS NULL
GROUP BY data_source_system, party_type
ORDER BY data_source_system, party_type;

-- =====================================================
-- SEARCH AND LOOKUP VIEWS
-- =====================================================

-- Party search view (for full-text search)
CREATE VIEW v_party_search AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    p.status,
    p.is_golden_record,
    p.data_quality_score,
    -- Person fields
    per.first_name,
    per.middle_name,
    per.last_name,
    per.given_name,
    per.family_name,
    per.birth_date,
    per.gender,
    per.nationality,
    -- Organization fields
    org.organization_name,
    org.organization_type,
    org.industry,
    -- Contact information
    GROUP_CONCAT(DISTINCT cp.contact_value SEPARATOR '; ') AS contact_values,
    -- Location information
    GROUP_CONCAT(DISTINCT pl.location_value SEPARATOR '; ') AS location_values,
    -- Identification information
    GROUP_CONCAT(DISTINCT pi.identification_value SEPARATOR '; ') AS identification_values,
    p.created_at,
    p.updated_at
FROM party p
LEFT JOIN person per ON p.party_id = per.party_id AND per.deleted_at IS NULL
LEFT JOIN organization org ON p.party_id = org.party_id AND org.deleted_at IS NULL
LEFT JOIN contact_point cp ON p.party_id = cp.party_id AND cp.deleted_at IS NULL
LEFT JOIN party_location pl ON p.party_id = pl.party_id AND pl.deleted_at IS NULL
LEFT JOIN party_identification pi ON p.party_id = pi.party_id AND pi.deleted_at IS NULL
WHERE p.deleted_at IS NULL
GROUP BY p.party_id, p.party_name, p.party_type, p.status, p.is_golden_record, 
         p.data_quality_score, per.first_name, per.middle_name, per.last_name, 
         per.given_name, per.family_name, per.birth_date, per.gender, per.nationality,
         org.organization_name, org.organization_type, org.industry, p.created_at, p.updated_at;

-- =====================================================
-- COMPLIANCE AND GOVERNANCE VIEWS
-- =====================================================

-- Data stewardship view
CREATE VIEW v_data_stewardship AS
SELECT 
    p.data_steward_id,
    p.party_type,
    COUNT(*) AS total_records,
    SUM(CASE WHEN p.is_golden_record = TRUE THEN 1 ELSE 0 END) AS golden_records,
    AVG(p.data_quality_score) AS avg_quality_score,
    AVG(p.confidence_score) AS avg_confidence_score,
    MIN(p.created_at) AS first_record_date,
    MAX(p.updated_at) AS last_update_date,
    COUNT(DISTINCT p.data_source_system) AS source_systems_count
FROM party p
WHERE p.deleted_at IS NULL AND p.data_steward_id IS NOT NULL
GROUP BY p.data_steward_id, p.party_type
ORDER BY p.data_steward_id, p.party_type;

-- Verification status view
CREATE VIEW v_verification_status AS
SELECT 
    p.party_id,
    p.party_name,
    p.party_type,
    p.last_verified_date,
    p.data_quality_score,
    p.confidence_score,
    CASE 
        WHEN p.last_verified_date IS NULL THEN 'Never Verified'
        WHEN p.last_verified_date < DATE_SUB(NOW(), INTERVAL 1 YEAR) THEN 'Overdue'
        WHEN p.last_verified_date < DATE_SUB(NOW(), INTERVAL 6 MONTH) THEN 'Due Soon'
        ELSE 'Up to Date'
    END AS verification_status,
    DATEDIFF(NOW(), COALESCE(p.last_verified_date, p.created_at)) AS days_since_verification
FROM party p
WHERE p.deleted_at IS NULL
ORDER BY p.last_verified_date ASC, p.party_id; 