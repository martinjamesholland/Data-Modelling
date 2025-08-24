-- MySQL Physical Data Model - Database Triggers
-- Party Master Data Management (MDM) System
-- Version: 1.0.0
-- Date: 2024-01-XX

-- Database triggers for audit logging, data validation, and automatic timestamp management

-- =====================================================
-- AUDIT TRIGGERS
-- =====================================================

DELIMITER //

-- Trigger for party table audit logging
CREATE TRIGGER tr_party_audit_insert
AFTER INSERT ON party
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id, 
        new_values, source_system
    ) VALUES (
        NEW.party_id, 'party', 'Create', NOW(), NEW.created_by,
        JSON_OBJECT(
            'party_name', NEW.party_name,
            'party_type', NEW.party_type,
            'status', NEW.status,
            'data_source_system', NEW.data_source_system,
            'is_golden_record', NEW.is_golden_record
        ),
        NEW.data_source_system
    );
END//

CREATE TRIGGER tr_party_audit_update
AFTER UPDATE ON party
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id,
        old_values, new_values, source_system
    ) VALUES (
        NEW.party_id, 'party', 'Update', NOW(), NEW.updated_by,
        JSON_OBJECT(
            'party_name', OLD.party_name,
            'party_type', OLD.party_type,
            'status', OLD.status,
            'data_source_system', OLD.data_source_system,
            'is_golden_record', OLD.is_golden_record
        ),
        JSON_OBJECT(
            'party_name', NEW.party_name,
            'party_type', NEW.party_type,
            'status', NEW.status,
            'data_source_system', NEW.data_source_system,
            'is_golden_record', NEW.is_golden_record
        ),
        NEW.data_source_system
    );
END//

CREATE TRIGGER tr_party_audit_delete
AFTER UPDATE ON party
FOR EACH ROW
BEGIN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        INSERT INTO party_audit_log (
            party_id, entity_name, action, action_date, user_id,
            old_values, new_values, source_system
        ) VALUES (
            NEW.party_id, 'party', 'Delete', NOW(), NEW.updated_by,
            JSON_OBJECT(
                'party_name', OLD.party_name,
                'party_type', OLD.party_type,
                'status', OLD.status,
                'deleted_at', NULL
            ),
            JSON_OBJECT(
                'party_name', NEW.party_name,
                'party_type', NEW.party_type,
                'status', NEW.status,
                'deleted_at', NEW.deleted_at
            ),
            NEW.data_source_system
        );
    END IF;
END//

-- Trigger for person table audit logging
CREATE TRIGGER tr_person_audit_insert
AFTER INSERT ON person
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id,
        new_values
    ) VALUES (
        NEW.party_id, 'person', 'Create', NOW(), 'SYSTEM',
        JSON_OBJECT(
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'birth_date', NEW.birth_date,
            'gender', NEW.gender
        )
    );
END//

CREATE TRIGGER tr_person_audit_update
AFTER UPDATE ON person
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id,
        old_values, new_values
    ) VALUES (
        NEW.party_id, 'person', 'Update', NOW(), 'SYSTEM',
        JSON_OBJECT(
            'first_name', OLD.first_name,
            'last_name', OLD.last_name,
            'birth_date', OLD.birth_date,
            'gender', OLD.gender
        ),
        JSON_OBJECT(
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'birth_date', NEW.birth_date,
            'gender', NEW.gender
        )
    );
END//

-- Trigger for organization table audit logging
CREATE TRIGGER tr_organization_audit_insert
AFTER INSERT ON organization
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id,
        new_values, source_system
    ) VALUES (
        NEW.party_id, 'organization', 'Create', NOW(), NEW.created_by,
        JSON_OBJECT(
            'organization_name', NEW.organization_name,
            'organization_type', NEW.organization_type,
            'industry', NEW.industry,
            'is_golden_record', NEW.is_golden_record
        ),
        NEW.data_source_system
    );
END//

CREATE TRIGGER tr_organization_audit_update
AFTER UPDATE ON organization
FOR EACH ROW
BEGIN
    INSERT INTO party_audit_log (
        party_id, entity_name, action, action_date, user_id,
        old_values, new_values, source_system
    ) VALUES (
        NEW.party_id, 'organization', 'Update', NOW(), NEW.updated_by,
        JSON_OBJECT(
            'organization_name', OLD.organization_name,
            'organization_type', OLD.organization_type,
            'industry', OLD.industry,
            'is_golden_record', OLD.is_golden_record
        ),
        JSON_OBJECT(
            'organization_name', NEW.organization_name,
            'organization_type', NEW.organization_type,
            'industry', NEW.industry,
            'is_golden_record', NEW.is_golden_record
        ),
        NEW.data_source_system
    );
END//

-- =====================================================
-- DATA VALIDATION TRIGGERS
-- =====================================================

-- Trigger to validate party type consistency
CREATE TRIGGER tr_party_type_validation
BEFORE INSERT ON party
FOR EACH ROW
BEGIN
    IF NEW.party_type NOT IN ('Person', 'Organization') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid party_type. Must be either Person or Organization.';
    END IF;
END//

CREATE TRIGGER tr_party_type_validation_update
BEFORE UPDATE ON party
FOR EACH ROW
BEGIN
    IF NEW.party_type NOT IN ('Person', 'Organization') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid party_type. Must be either Person or Organization.';
    END IF;
END//

-- Trigger to validate person data when party type is Person
CREATE TRIGGER tr_person_party_validation
BEFORE INSERT ON person
FOR EACH ROW
BEGIN
    DECLARE party_type_val VARCHAR(20);
    
    SELECT party_type INTO party_type_val
    FROM party
    WHERE party_id = NEW.party_id;
    
    IF party_type_val != 'Person' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert person data for non-Person party type.';
    END IF;
END//

-- Trigger to validate organization data when party type is Organization
CREATE TRIGGER tr_organization_party_validation
BEFORE INSERT ON organization
FOR EACH ROW
BEGIN
    DECLARE party_type_val VARCHAR(20);
    
    SELECT party_type INTO party_type_val
    FROM party
    WHERE party_id = NEW.party_id;
    
    IF party_type_val != 'Organization' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert organization data for non-Organization party type.';
    END IF;
END//

-- Trigger to validate data quality scores
CREATE TRIGGER tr_data_quality_score_validation
BEFORE INSERT ON party_data_quality
FOR EACH ROW
BEGIN
    IF NEW.completeness_score < 0 OR NEW.completeness_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
    
    IF NEW.accuracy_score < 0 OR NEW.accuracy_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
    
    IF NEW.consistency_score < 0 OR NEW.consistency_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
    
    IF NEW.timeliness_score < 0 OR NEW.timeliness_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
    
    IF NEW.uniqueness_score < 0 OR NEW.uniqueness_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
    
    IF NEW.overall_score < 0 OR NEW.overall_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data quality scores must be between 0 and 100.';
    END IF;
END//

-- =====================================================
-- BUSINESS RULE TRIGGERS
-- =====================================================

-- Trigger to ensure only one golden record per party
CREATE TRIGGER tr_golden_record_validation
BEFORE UPDATE ON party
FOR EACH ROW
BEGIN
    IF NEW.is_golden_record = TRUE AND OLD.is_golden_record = FALSE THEN
        -- Set all other records for the same party to non-golden
        UPDATE party 
        SET is_golden_record = FALSE, 
            updated_at = NOW(), 
            updated_by = NEW.updated_by
        WHERE party_id = NEW.party_id 
        AND party_id != NEW.party_id;
    END IF;
END//

-- Trigger to update party data quality score when related data changes
CREATE TRIGGER tr_party_quality_update
AFTER UPDATE ON party
FOR EACH ROW
BEGIN
    IF OLD.data_quality_score != NEW.data_quality_score THEN
        INSERT INTO party_data_quality (
            party_id, assessment_date, completeness_score, accuracy_score,
            consistency_score, timeliness_score, uniqueness_score, overall_score,
            created_by
        ) VALUES (
            NEW.party_id, NOW(), 
            COALESCE(NEW.data_quality_score, 0),
            COALESCE(NEW.data_quality_score, 0),
            COALESCE(NEW.data_quality_score, 0),
            COALESCE(NEW.data_quality_score, 0),
            COALESCE(NEW.data_quality_score, 0),
            COALESCE(NEW.data_quality_score, 0),
            NEW.updated_by
        );
    END IF;
END//

-- Trigger to prevent circular relationships
CREATE TRIGGER tr_relationship_circular_validation
BEFORE INSERT ON party_relationship
FOR EACH ROW
BEGIN
    IF NEW.party_id = NEW.related_party_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot create relationship between party and itself.';
    END IF;
END//

-- =====================================================
-- AUTOMATIC TIMESTAMP TRIGGERS
-- =====================================================

-- Trigger to automatically set created_at and updated_at for party
CREATE TRIGGER tr_party_timestamps
BEFORE INSERT ON party
FOR EACH ROW
BEGIN
    IF NEW.created_at IS NULL THEN
        SET NEW.created_at = NOW();
    END IF;
    IF NEW.updated_at IS NULL THEN
        SET NEW.updated_at = NOW();
    END IF;
END//

-- Trigger to automatically update updated_at for party
CREATE TRIGGER tr_party_timestamps_update
BEFORE UPDATE ON party
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END//

-- Similar triggers for other tables with timestamps
CREATE TRIGGER tr_person_timestamps
BEFORE INSERT ON person
FOR EACH ROW
BEGIN
    IF NEW.created_at IS NULL THEN
        SET NEW.created_at = NOW();
    END IF;
    IF NEW.updated_at IS NULL THEN
        SET NEW.updated_at = NOW();
    END IF;
END//

CREATE TRIGGER tr_person_timestamps_update
BEFORE UPDATE ON person
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END//

-- =====================================================
-- DATA INTEGRITY TRIGGERS
-- =====================================================

-- Trigger to maintain referential integrity for soft deletes
CREATE TRIGGER tr_soft_delete_cascade
BEFORE UPDATE ON party
FOR EACH ROW
BEGIN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        -- Soft delete related records
        UPDATE person SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE organization SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE party_identification SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE party_location SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE contact_point SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE party_relationship SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id OR related_party_id = NEW.party_id;
        UPDATE person_profile SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
        UPDATE party_directory_reference SET deleted_at = NEW.deleted_at WHERE party_id = NEW.party_id;
    END IF;
END//

DELIMITER ; 