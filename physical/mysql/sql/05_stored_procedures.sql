-- MySQL Physical Data Model - Stored Procedures
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX

-- Stored procedures for common operations and business logic

DELIMITER //

-- =====================================================
-- PARTY MANAGEMENT PROCEDURES
-- =====================================================

-- Procedure to create a new person party
CREATE PROCEDURE sp_create_person_party(
    IN p_party_name VARCHAR(255),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_middle_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_gender ENUM('Male', 'Female', 'Other', 'Prefer not to say'),
    IN p_nationality VARCHAR(100),
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100),
    OUT p_party_id VARCHAR(36)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Generate UUID for party_id
    SET p_party_id = UUID();
    
    -- Insert party record
    INSERT INTO party (
        party_id, party_name, party_type, party_date_time, status,
        data_source_system, data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_party_name, 'Person', NOW(), 'Active',
        p_data_source_system, p_data_source_id, p_created_by, p_created_by
    );
    
    -- Insert person record
    INSERT INTO person (
        party_id, first_name, last_name, middle_name, birth_date, gender, nationality
    ) VALUES (
        p_party_id, p_first_name, p_last_name, p_middle_name, p_birth_date, p_gender, p_nationality
    );
    
    COMMIT;
END//

-- Procedure to create a new organization party
CREATE PROCEDURE sp_create_organization_party(
    IN p_party_name VARCHAR(255),
    IN p_organization_name VARCHAR(255),
    IN p_organization_type ENUM('Company', 'Government', 'Non-Profit', 'Educational', 'Other'),
    IN p_industry VARCHAR(100),
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100),
    OUT p_party_id VARCHAR(36)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Generate UUID for party_id
    SET p_party_id = UUID();
    
    -- Insert party record
    INSERT INTO party (
        party_id, party_name, party_type, party_date_time, status,
        data_source_system, data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_party_name, 'Organization', NOW(), 'Active',
        p_data_source_system, p_data_source_id, p_created_by, p_created_by
    );
    
    -- Insert organization record
    INSERT INTO organization (
        party_id, organization_name, organization_type, industry,
        data_source_system, data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_organization_name, p_organization_type, p_industry,
        p_data_source_system, p_data_source_id, p_created_by, p_created_by
    );
    
    COMMIT;
END//

-- Procedure to update party information
CREATE PROCEDURE sp_update_party(
    IN p_party_id VARCHAR(36),
    IN p_party_name VARCHAR(255),
    IN p_status ENUM('Active', 'Inactive', 'Merged', 'Deleted'),
    IN p_data_quality_score DECIMAL(5,2),
    IN p_confidence_score DECIMAL(5,2),
    IN p_updated_by VARCHAR(100)
)
BEGIN
    UPDATE party 
    SET party_name = p_party_name,
        status = p_status,
        data_quality_score = p_data_quality_score,
        confidence_score = p_confidence_score,
        updated_at = NOW(),
        updated_by = p_updated_by
    WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Party not found or already deleted.';
    END IF;
END//

-- Procedure to soft delete a party
CREATE PROCEDURE sp_soft_delete_party(
    IN p_party_id VARCHAR(36),
    IN p_updated_by VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Update party status and set deleted_at
    UPDATE party 
    SET status = 'Deleted',
        deleted_at = NOW(),
        updated_at = NOW(),
        updated_by = p_updated_by
    WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Party not found or already deleted.';
    END IF;
    
    COMMIT;
END//

-- =====================================================
-- CONTACT AND LOCATION PROCEDURES
-- =====================================================

-- Procedure to add contact point to party
CREATE PROCEDURE sp_add_contact_point(
    IN p_party_id VARCHAR(36),
    IN p_contact_type ENUM('Phone', 'Email', 'SocialMedia', 'Other'),
    IN p_contact_value VARCHAR(255),
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100)
)
BEGIN
    INSERT INTO contact_point (
        party_id, contact_type, contact_value, data_source_system, 
        data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_contact_type, p_contact_value, p_data_source_system,
        p_data_source_id, p_created_by, p_created_by
    );
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to add contact point.';
    END IF;
END//

-- Procedure to add location to party
CREATE PROCEDURE sp_add_party_location(
    IN p_party_id VARCHAR(36),
    IN p_location_type ENUM('Physical', 'Postal', 'Electronic', 'Other'),
    IN p_location_value TEXT,
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100)
)
BEGIN
    INSERT INTO party_location (
        party_id, location_type, location_value, data_source_system,
        data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_location_type, p_location_value, p_data_source_system,
        p_data_source_id, p_created_by, p_created_by
    );
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to add location.';
    END IF;
END//

-- Procedure to add identification to party
CREATE PROCEDURE sp_add_party_identification(
    IN p_party_id VARCHAR(36),
    IN p_identification_type ENUM('TaxID', 'Passport', 'DriverLicense', 'Other'),
    IN p_identification_value VARCHAR(255),
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100)
)
BEGIN
    INSERT INTO party_identification (
        party_id, identification_type, identification_value, data_source_system,
        data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_identification_type, p_identification_value, p_data_source_system,
        p_data_source_id, p_created_by, p_created_by
    );
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to add identification.';
    END IF;
END//

-- =====================================================
-- RELATIONSHIP PROCEDURES
-- =====================================================

-- Procedure to create party relationship
CREATE PROCEDURE sp_create_party_relationship(
    IN p_party_id VARCHAR(36),
    IN p_related_party_id VARCHAR(36),
    IN p_relationship_type ENUM('Customer', 'Supplier', 'Partner', 'Other'),
    IN p_data_source_system VARCHAR(100),
    IN p_data_source_id VARCHAR(100),
    IN p_created_by VARCHAR(100)
)
BEGIN
    INSERT INTO party_relationship (
        party_id, related_party_id, relationship_type, data_source_system,
        data_source_id, created_by, updated_by
    ) VALUES (
        p_party_id, p_related_party_id, p_relationship_type, p_data_source_system,
        p_data_source_id, p_created_by, p_created_by
    );
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to create party relationship.';
    END IF;
END//

-- =====================================================
-- DATA QUALITY PROCEDURES
-- =====================================================

-- Procedure to assess data quality for a party
CREATE PROCEDURE sp_assess_party_data_quality(
    IN p_party_id VARCHAR(36),
    IN p_assessed_by VARCHAR(100)
)
BEGIN
    DECLARE v_completeness_score DECIMAL(5,2);
    DECLARE v_accuracy_score DECIMAL(5,2);
    DECLARE v_consistency_score DECIMAL(5,2);
    DECLARE v_timeliness_score DECIMAL(5,2);
    DECLARE v_uniqueness_score DECIMAL(5,2);
    DECLARE v_overall_score DECIMAL(5,2);
    DECLARE v_party_type VARCHAR(20);
    DECLARE v_has_person_data BOOLEAN;
    DECLARE v_has_org_data BOOLEAN;
    DECLARE v_has_contacts BOOLEAN;
    DECLARE v_has_locations BOOLEAN;
    DECLARE v_has_identifications BOOLEAN;
    
    -- Get party type
    SELECT party_type INTO v_party_type
    FROM party
    WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    IF v_party_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Party not found.';
    END IF;
    
    -- Check data completeness
    SELECT 
        CASE WHEN v_party_type = 'Person' THEN 
            (SELECT COUNT(*) > 0 FROM person WHERE party_id = p_party_id AND deleted_at IS NULL)
        ELSE 
            (SELECT COUNT(*) > 0 FROM organization WHERE party_id = p_party_id AND deleted_at IS NULL)
        END INTO v_has_person_data;
    
    SELECT COUNT(*) > 0 INTO v_has_contacts
    FROM contact_point WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    SELECT COUNT(*) > 0 INTO v_has_locations
    FROM party_location WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    SELECT COUNT(*) > 0 INTO v_has_identifications
    FROM party_identification WHERE party_id = p_party_id AND deleted_at IS NULL;
    
    -- Calculate completeness score (basic implementation)
    SET v_completeness_score = 0;
    IF v_has_person_data THEN SET v_completeness_score = v_completeness_score + 25; END IF;
    IF v_has_contacts THEN SET v_completeness_score = v_completeness_score + 25; END IF;
    IF v_has_locations THEN SET v_completeness_score = v_completeness_score + 25; END IF;
    IF v_has_identifications THEN SET v_completeness_score = v_completeness_score + 25; END IF;
    
    -- Set other scores (simplified for this example)
    SET v_accuracy_score = 85.0;
    SET v_consistency_score = 90.0;
    SET v_timeliness_score = 95.0;
    SET v_uniqueness_score = 88.0;
    
    -- Calculate overall score
    SET v_overall_score = (v_completeness_score + v_accuracy_score + v_consistency_score + 
                          v_timeliness_score + v_uniqueness_score) / 5;
    
    -- Insert data quality assessment
    INSERT INTO party_data_quality (
        party_id, assessment_date, completeness_score, accuracy_score,
        consistency_score, timeliness_score, uniqueness_score, overall_score,
        created_by
    ) VALUES (
        p_party_id, NOW(), v_completeness_score, v_accuracy_score,
        v_consistency_score, v_timeliness_score, v_uniqueness_score, v_overall_score,
        p_assessed_by
    );
    
    -- Update party with new quality score
    UPDATE party 
    SET data_quality_score = v_overall_score,
        updated_at = NOW(),
        updated_by = p_assessed_by
    WHERE party_id = p_party_id;
    
END//

-- =====================================================
-- SEARCH AND LOOKUP PROCEDURES
-- =====================================================

-- Procedure to search parties by name
CREATE PROCEDURE sp_search_parties_by_name(
    IN p_search_term VARCHAR(255),
    IN p_party_type VARCHAR(20),
    IN p_limit INT
)
BEGIN
    SET p_limit = COALESCE(p_limit, 100);
    
    SELECT 
        p.party_id,
        p.party_name,
        p.party_type,
        p.status,
        p.is_golden_record,
        p.data_quality_score,
        per.first_name,
        per.last_name,
        per.birth_date,
        org.organization_name,
        org.organization_type,
        p.created_at
    FROM party p
    LEFT JOIN person per ON p.party_id = per.party_id AND per.deleted_at IS NULL
    LEFT JOIN organization org ON p.party_id = org.party_id AND org.deleted_at IS NULL
    WHERE p.deleted_at IS NULL
    AND (p_party_type IS NULL OR p.party_type = p_party_type)
    AND (
        p.party_name LIKE CONCAT('%', p_search_term, '%')
        OR per.first_name LIKE CONCAT('%', p_search_term, '%')
        OR per.last_name LIKE CONCAT('%', p_search_term, '%')
        OR org.organization_name LIKE CONCAT('%', p_search_term, '%')
    )
    ORDER BY p.is_golden_record DESC, p.data_quality_score DESC, p.created_at DESC
    LIMIT p_limit;
END//

-- Procedure to get party relationships
CREATE PROCEDURE sp_get_party_relationships(
    IN p_party_id VARCHAR(36)
)
BEGIN
    SELECT 
        pr.relationship_id,
        pr.relationship_type,
        p2.party_id AS related_party_id,
        p2.party_name AS related_party_name,
        p2.party_type AS related_party_type,
        p2.status AS related_party_status,
        pr.data_source_system,
        pr.is_golden_record,
        pr.data_quality_score,
        pr.created_at
    FROM party_relationship pr
    JOIN party p2 ON pr.related_party_id = p2.party_id AND p2.deleted_at IS NULL
    WHERE pr.party_id = p_party_id AND pr.deleted_at IS NULL
    ORDER BY pr.relationship_type, p2.party_name;
END//

-- =====================================================
-- REPORTING PROCEDURES
-- =====================================================

-- Procedure to get party statistics
CREATE PROCEDURE sp_get_party_statistics()
BEGIN
    SELECT 
        party_type,
        status,
        COUNT(*) AS total_count,
        SUM(CASE WHEN is_golden_record = TRUE THEN 1 ELSE 0 END) AS golden_record_count,
        AVG(data_quality_score) AS avg_data_quality_score,
        AVG(confidence_score) AS avg_confidence_score,
        MIN(created_at) AS earliest_created,
        MAX(created_at) AS latest_created
    FROM party
    WHERE deleted_at IS NULL
    GROUP BY party_type, status
    ORDER BY party_type, status;
END//

-- Procedure to get data quality summary
CREATE PROCEDURE sp_get_data_quality_summary()
BEGIN
    SELECT 
        CASE 
            WHEN overall_score >= 90 THEN 'Excellent'
            WHEN overall_score >= 80 THEN 'Good'
            WHEN overall_score >= 70 THEN 'Fair'
            WHEN overall_score >= 60 THEN 'Poor'
            ELSE 'Critical'
        END AS quality_category,
        COUNT(*) AS record_count,
        AVG(overall_score) AS avg_score,
        MIN(overall_score) AS min_score,
        MAX(overall_score) AS max_score
    FROM party_data_quality
    WHERE assessment_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY 
        CASE 
            WHEN overall_score >= 90 THEN 'Excellent'
            WHEN overall_score >= 80 THEN 'Good'
            WHEN overall_score >= 70 THEN 'Fair'
            WHEN overall_score >= 60 THEN 'Poor'
            ELSE 'Critical'
        END
    ORDER BY avg_score DESC;
END//

-- =====================================================
-- MAINTENANCE PROCEDURES
-- =====================================================

-- Procedure to clean up old audit logs
CREATE PROCEDURE sp_cleanup_audit_logs(
    IN p_days_to_keep INT
)
BEGIN
    DECLARE v_cutoff_date DATE;
    
    SET v_cutoff_date = DATE_SUB(NOW(), INTERVAL p_days_to_keep DAY);
    
    DELETE FROM party_audit_log 
    WHERE action_date < v_cutoff_date;
    
    SELECT ROW_COUNT() AS deleted_records;
END//

-- Procedure to archive old data quality records
CREATE PROCEDURE sp_archive_data_quality_records(
    IN p_months_to_keep INT
)
BEGIN
    DECLARE v_cutoff_date DATE;
    
    SET v_cutoff_date = DATE_SUB(NOW(), INTERVAL p_months_to_keep MONTH);
    
    -- Create archive table if it doesn't exist
    CREATE TABLE IF NOT EXISTS party_data_quality_archive LIKE party_data_quality;
    
    -- Move old records to archive
    INSERT INTO party_data_quality_archive
    SELECT * FROM party_data_quality
    WHERE assessment_date < v_cutoff_date;
    
    -- Delete old records from main table
    DELETE FROM party_data_quality 
    WHERE assessment_date < v_cutoff_date;
    
    SELECT ROW_COUNT() AS archived_records;
END//

DELIMITER ; 