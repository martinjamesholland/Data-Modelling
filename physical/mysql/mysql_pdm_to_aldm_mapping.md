# MySQL PDM to ALDM Mapping Documentation

## Overview

This document provides a comprehensive mapping between the Application Logical Data Model (ALDM) and the MySQL Physical Data Model (PDM) for the Party Master Data Management system.

## Mapping Approach

### 1. **Direct Mapping**
Most ALDM attributes map directly to MySQL columns with appropriate data type conversions:
- ALDM `string` → MySQL `VARCHAR(n)` or `TEXT`
- ALDM `datetime` → MySQL `TIMESTAMP` or `DATETIME`
- ALDM `date` → MySQL `DATE`
- ALDM `boolean` → MySQL `BOOLEAN`
- ALDM `decimal` → MySQL `DECIMAL(5,2)`
- ALDM `integer` → MySQL `INT` or `BIGINT`
- ALDM `json` → MySQL `JSON`

### 2. **Data Type Enhancements**
Several ALDM string attributes are enhanced with MySQL ENUM types for data validation:
- `party_type`: `ENUM('Person', 'Organization')`
- `status`: `ENUM('Active', 'Inactive', 'Merged', 'Deleted')`
- `gender`: `ENUM('Male', 'Female', 'Other', 'Prefer not to say')`
- `marital_status`: `ENUM('Single', 'Married', 'Divorced', 'Widowed', 'Separated', 'Other')`
- `organization_type`: `ENUM('Company', 'Government', 'Non-Profit', 'Educational', 'Other')`
- `contact_type`: `ENUM('Phone', 'Email', 'SocialMedia', 'Other')`
- `location_type`: `ENUM('Physical', 'Postal', 'Electronic', 'Other')`
- `identification_type`: `ENUM('TaxID', 'Passport', 'DriverLicense', 'Other')`
- `relationship_type`: `ENUM('Customer', 'Supplier', 'Partner', 'Other')`

### 3. **Primary Key Strategy**
- **Party entities**: Use UUID (`VARCHAR(36)`) for `party_id` to ensure global uniqueness
- **Supporting entities**: Use auto-incrementing `BIGINT` for surrogate keys
- **Composite keys**: Implemented as unique constraints where appropriate

## Entity Mappings

### Core Party Entities

#### 1. **Party Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | UUID implementation |
| party_name | party_name | VARCHAR(255) | Direct | Full-text indexed |
| party_type | party_type | ENUM | Enhanced | Data validation |
| status | status | ENUM | Enhanced | Data validation |
| data_source_system | data_source_system | VARCHAR(100) | Direct | Indexed |
| is_golden_record | is_golden_record | BOOLEAN | Direct | Business rule enforced |

#### 2. **Person Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| first_name | first_name | VARCHAR(100) | Direct | Full-text indexed |
| last_name | last_name | VARCHAR(100) | Direct | Full-text indexed |
| birth_date | birth_date | DATE | Direct | Indexed |
| gender | gender | ENUM | Enhanced | Data validation |

#### 3. **Organization Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| organization_name | organization_name | VARCHAR(255) | Direct | Full-text indexed |
| organization_type | organization_type | ENUM | Enhanced | Data validation |
| industry | industry | VARCHAR(100) | Direct | Indexed |

### Supporting Entities

#### 4. **PartyIdentification Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| identification_type | identification_type | ENUM | Enhanced | Data validation |
| identification_value | identification_value | VARCHAR(255) | Direct | Indexed |

#### 5. **PartyLocation Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| location_type | location_type | ENUM | Enhanced | Data validation |
| location_value | location_value | TEXT | Enhanced | Full-text indexed |

#### 6. **ContactPoint Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| contact_type | contact_type | ENUM | Enhanced | Data validation |
| contact_value | contact_value | VARCHAR(255) | Direct | Full-text indexed |

#### 7. **PartyRelationship Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| related_party_id | related_party_id | VARCHAR(36) | Direct | FK to party table |
| relationship_type | relationship_type | ENUM | Enhanced | Data validation |

### Management Entities

#### 8. **PersonProfile Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| person_profile_id | person_profile_id | BIGINT | Enhanced | Auto-increment PK |
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| political_exposure_type | political_exposure_type | ENUM | Enhanced | Data validation |
| employment_status | employment_status | ENUM | Enhanced | Data validation |

#### 9. **PartyDirectoryReference Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_directory_reference_id | party_directory_reference_id | BIGINT | Enhanced | Auto-increment PK |
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| directory_name | directory_name | VARCHAR(100) | Direct | Indexed |
| is_verified | is_verified | BOOLEAN | Direct | Indexed |

#### 10. **PartyMergeHistory Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| party_merge_id | party_merge_id | BIGINT | Enhanced | Auto-increment PK |
| survivor_party_id | survivor_party_id | VARCHAR(36) | Direct | FK to party table |
| merged_party_id | merged_party_id | VARCHAR(36) | Direct | FK to party table |
| merged_record_json | merged_record_json | JSON | Direct | Native JSON support |

#### 11. **PartyMatchRule Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| match_rule_id | match_rule_id | BIGINT | Enhanced | Auto-increment PK |
| rule_definition | rule_definition | JSON | Direct | Native JSON support |
| rule_type | rule_type | ENUM | Enhanced | Data validation |

#### 12. **PartyAuditLog Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| audit_id | audit_id | BIGINT | Enhanced | Auto-increment PK |
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| old_values | old_values | JSON | Direct | Native JSON support |
| new_values | new_values | JSON | Direct | Native JSON support |

#### 13. **PartyDataQuality Entity**
| ALDM Attribute | MySQL Column | Data Type | Mapping Type | Notes |
|----------------|--------------|-----------|--------------|-------|
| data_quality_id | data_quality_id | BIGINT | Enhanced | Auto-increment PK |
| party_id | party_id | VARCHAR(36) | Direct | FK to party table |
| issues_found | issues_found | JSON | Direct | Native JSON support |
| improvement_suggestions | improvement_suggestions | JSON | Direct | Native JSON support |

## Data Type Conversion Summary

### String to VARCHAR/TEXT
- **Short strings** (< 255 chars): `VARCHAR(n)`
- **Long strings** (descriptions): `TEXT`
- **Fixed values**: `ENUM` for data validation

### String to ENUM
- **Categorical data** with known values
- **Provides data validation** at database level
- **Improves query performance** with indexes

### Datetime to TIMESTAMP/DATETIME
- **Standard timestamps**: `TIMESTAMP` (auto-update support)
- **Historical dates**: `DATETIME` (no timezone conversion)
- **Date only**: `DATE`

### JSON Support
- **Native MySQL JSON** type for complex data
- **JSON validation** and querying capabilities
- **Used for**: audit logs, data quality issues, rule definitions

## Implementation Enhancements

### 1. **Indexing Strategy**
- **Primary keys**: All tables have appropriate primary keys
- **Foreign keys**: Indexed for join performance
- **Business keys**: Composite indexes for common queries
- **Full-text search**: On name and description fields

### 2. **Constraints and Validation**
- **Foreign key constraints**: Maintain referential integrity
- **Unique constraints**: Prevent duplicate data
- **Check constraints**: Data validation (MySQL 8.0+)
- **ENUM constraints**: Categorical data validation

### 3. **Triggers and Business Rules**
- **Audit logging**: Automatic audit trail creation
- **Data validation**: Business rule enforcement
- **Soft delete cascade**: Maintain referential integrity
- **Timestamp management**: Automatic created_at/updated_at

### 4. **Views and Stored Procedures**
- **Reporting views**: Common query patterns
- **Search views**: Full-text search capabilities
- **Stored procedures**: Common operations
- **Data quality views**: Monitoring and reporting

## Compliance and Standards

### 1. **3NF Compliance**
- **Normalized structure**: Eliminates data redundancy
- **Proper relationships**: Maintains data integrity
- **Atomic values**: Each column contains single values

### 2. **Standard Attributes**
- **created_at**: Record creation timestamp
- **updated_at**: Record modification timestamp
- **deleted_at**: Soft delete timestamp
- **created_by/updated_by**: User tracking

### 3. **Naming Conventions**
- **lower_snake_case**: All database objects
- **Descriptive names**: Clear and meaningful
- **Consistent patterns**: Across all tables

## Performance Considerations

### 1. **Indexing Strategy**
- **Covering indexes**: For frequent queries
- **Composite indexes**: Multi-column searches
- **Functional indexes**: Case-insensitive searches
- **Full-text indexes**: Text search capabilities

### 2. **Data Types**
- **Appropriate sizes**: Avoid over-sizing columns
- **Efficient types**: Use smallest suitable type
- **Index-friendly**: Optimize for query performance

### 3. **Partitioning**
- **Large tables**: Audit logs and data quality
- **Date-based**: Natural partitioning key
- **Performance**: Improved query performance

## Migration and Deployment

### 1. **Script Organization**
- **01_schema.sql**: Table creation
- **02_indexes.sql**: Performance optimization
- **03_triggers.sql**: Business logic
- **04_views.sql**: Common queries
- **05_stored_procedures.sql**: Operations
- **06_sample_data.sql**: Test data

### 2. **Version Control**
- **Schema versioning**: Track changes over time
- **Migration scripts**: Forward-only migrations
- **Rollback procedures**: Emergency rollback capability

### 3. **Testing**
- **Sample data**: Comprehensive test dataset
- **Unit tests**: Stored procedure testing
- **Integration tests**: End-to-end workflows

## Conclusion

The MySQL PDM provides a robust, scalable, and maintainable implementation of the ALDM. The mapping preserves all logical relationships while adding physical optimizations for performance, data integrity, and operational efficiency.

Key benefits of this implementation:
- **Data integrity**: Comprehensive constraints and validation
- **Performance**: Optimized indexing and query patterns
- **Maintainability**: Clear structure and documentation
- **Scalability**: Efficient data types and partitioning support
- **Compliance**: Audit trails and data quality monitoring 