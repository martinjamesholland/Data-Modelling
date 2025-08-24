# MySQL PDM to ALDM Mapping Summary

## Quick Reference

### Entity Mapping Overview

| ALDM Entity | MySQL Table | Primary Key | Foreign Keys | Notes |
|-------------|-------------|-------------|--------------|-------|
| Party | party | party_id (UUID) | - | Core entity table |
| Person | person | party_id (UUID) | party_id → party | 1:1 with Party |
| Organization | organization | party_id (UUID) | party_id → party | 1:1 with Party |
| PartyIdentification | party_identification | identification_id (BIGINT) | party_id → party | 1:N with Party |
| PartyLocation | party_location | location_id (BIGINT) | party_id → party | 1:N with Party |
| ContactPoint | contact_point | contact_id (BIGINT) | party_id → party | 1:N with Party |
| PartyRelationship | party_relationship | relationship_id (BIGINT) | party_id → party, related_party_id → party | M:N between Parties |
| PersonProfile | person_profile | person_profile_id (BIGINT) | party_id → party | 1:1 with Person |
| PartyDirectoryReference | party_directory_reference | party_directory_reference_id (BIGINT) | party_id → party | 1:N with Party |
| PartyMergeHistory | party_merge_history | party_merge_id (BIGINT) | survivor_party_id → party | Historical data |
| PartyMatchRule | party_match_rule | match_rule_id (BIGINT) | - | Configuration table |
| PartyAuditLog | party_audit_log | audit_id (BIGINT) | party_id → party | Audit trail |
| PartyDataQuality | party_data_quality | data_quality_id (BIGINT) | party_id → party | Quality metrics |

### Data Type Mapping Summary

| ALDM Data Type | MySQL Data Type | Examples | Notes |
|----------------|-----------------|----------|-------|
| string | VARCHAR(n) | party_name, first_name | Short strings |
| string | TEXT | location_value, description | Long strings |
| string | ENUM | party_type, status, gender | Categorical data |
| datetime | TIMESTAMP | created_at, updated_at | Auto-update support |
| datetime | DATETIME | action_date, merge_date | Historical dates |
| date | DATE | birth_date, last_verified_date | Date only |
| boolean | BOOLEAN | is_golden_record, is_verified | True/False |
| decimal | DECIMAL(5,2) | data_quality_score, confidence_score | Numeric with precision |
| integer | INT/BIGINT | family_size, priority | Whole numbers |
| json | JSON | old_values, new_values, rule_definition | Complex data |

### Key Implementation Decisions

#### 1. **Primary Key Strategy**
- **Party entities**: UUID (`VARCHAR(36)`) for global uniqueness
- **Supporting entities**: Auto-incrementing `BIGINT` for performance
- **Composite keys**: Unique constraints where needed

#### 2. **Data Validation Enhancements**
- **ENUM types**: For categorical data with known values
- **Foreign key constraints**: Maintain referential integrity
- **Unique constraints**: Prevent duplicate data
- **Check constraints**: Business rule validation

#### 3. **Performance Optimizations**
- **Indexing**: Comprehensive index strategy
- **Full-text search**: On name and description fields
- **Covering indexes**: For frequent queries
- **Partitioning**: For large tables (audit, quality)

#### 4. **Business Logic Implementation**
- **Triggers**: Audit logging, validation, timestamps
- **Stored procedures**: Common operations
- **Views**: Reporting and search capabilities
- **Soft deletes**: Maintain data history

### Standard Attributes

All tables include these standard attributes:

| Attribute | Data Type | Purpose | Notes |
|-----------|-----------|---------|-------|
| created_at | TIMESTAMP | Record creation | Auto-set on insert |
| updated_at | TIMESTAMP | Record modification | Auto-update on change |
| deleted_at | TIMESTAMP | Soft delete | NULL = active record |
| created_by | VARCHAR(100) | User tracking | Manual input |
| updated_by | VARCHAR(100) | User tracking | Manual input |

### Relationship Mapping

#### 1:1 Relationships
- **Party ↔ Person**: One party can be one person
- **Party ↔ Organization**: One party can be one organization
- **Person ↔ PersonProfile**: One person can have one profile

#### 1:N Relationships
- **Party → PartyIdentification**: One party can have multiple identifications
- **Party → PartyLocation**: One party can have multiple locations
- **Party → ContactPoint**: One party can have multiple contacts
- **Party → PartyDirectoryReference**: One party can have multiple directory references

#### M:N Relationships
- **Party ↔ PartyRelationship**: Parties can have multiple relationships with each other
- **Party ↔ PartyAuditLog**: Parties can have multiple audit entries
- **Party ↔ PartyDataQuality**: Parties can have multiple quality assessments

### Indexing Strategy

#### Primary Indexes
- All primary keys are automatically indexed
- Foreign keys are indexed for join performance

#### Business Indexes
- **party_type, status**: Common filtering
- **data_source_system, data_source_id**: Source system queries
- **is_golden_record**: Golden record queries
- **created_at, updated_at**: Temporal queries

#### Full-Text Indexes
- **party_name**: Party name search
- **first_name, last_name**: Person name search
- **organization_name**: Organization name search
- **location_value, contact_value**: Content search

#### Composite Indexes
- **party_id, identification_type**: Party identification queries
- **party_id, contact_type**: Party contact queries
- **party_id, location_type**: Party location queries
- **party_id, relationship_type**: Party relationship queries

### Audit and Compliance

#### Audit Trail
- **Automatic logging**: All changes logged via triggers
- **JSON storage**: Old and new values stored as JSON
- **User tracking**: Who made changes and when
- **IP tracking**: Source of changes

#### Data Quality
- **Quality scoring**: Comprehensive quality metrics
- **Issue tracking**: JSON storage of quality issues
- **Improvement suggestions**: JSON storage of recommendations
- **Historical tracking**: Quality assessment history

### Migration Path

#### Script Execution Order
1. **01_schema.sql**: Create all tables
2. **02_indexes.sql**: Add performance indexes
3. **03_triggers.sql**: Add business logic triggers
4. **04_views.sql**: Create reporting views
5. **05_stored_procedures.sql**: Add operational procedures
6. **06_sample_data.sql**: Load test data

#### Rollback Strategy
- **Schema versioning**: Track all changes
- **Backup procedures**: Before major changes
- **Rollback scripts**: Emergency rollback capability

### Testing and Validation

#### Sample Data
- **Comprehensive dataset**: All entity types covered
- **Edge cases**: Boundary conditions tested
- **Relationship scenarios**: Various relationship types
- **Quality variations**: Different quality scores

#### Validation Rules
- **Data type validation**: ENUM constraints
- **Referential integrity**: Foreign key constraints
- **Business rules**: Trigger-based validation
- **Performance testing**: Index effectiveness

## Conclusion

The MySQL PDM successfully implements the ALDM with:
- ✅ **Complete coverage**: All ALDM entities and attributes mapped
- ✅ **Data integrity**: Comprehensive constraints and validation
- ✅ **Performance optimization**: Strategic indexing and data types
- ✅ **Business logic**: Triggers, procedures, and views
- ✅ **Compliance**: Audit trails and quality monitoring
- ✅ **Maintainability**: Clear structure and documentation
- ✅ **Scalability**: Efficient design for growth 