# MySQL Physical Data Model (PDM)

This directory contains the MySQL physical data model implementation for the Party Master Data Management (MDM) system.

## Overview

The MySQL PDM is based on the Application Logical Data Model (ALDM) and implements a normalized relational database structure optimized for MySQL 8.0+. The model follows third normal form (3NF) and includes all standard application attributes as required by the data modelling standards.

## Key Features

- **Normalized Structure**: Follows 3NF for optimal data integrity and minimal redundancy
- **Standard Attributes**: All tables include `created_at`, `updated_at`, and `deleted_at` timestamps
- **Soft Deletes**: Implements soft delete functionality using `deleted_at` columns
- **Audit Trail**: Comprehensive audit logging for data changes
- **Data Quality**: Built-in data quality assessment capabilities
- **Master Data Management**: Supports party matching, merging, and golden record management

## Database Schema

### Core Tables
- `party` - Main party entity table
- `person` - Person-specific information
- `organization` - Organization-specific information
- `party_identification` - Party identification documents
- `party_location` - Party location information
- `contact_point` - Party contact information
- `party_relationship` - Relationships between parties

### Supporting Tables
- `person_profile` - Additional person information
- `party_directory_reference` - External directory references
- `party_merge_history` - Merge operation history
- `party_match_rule` - Matching rules configuration
- `party_audit_log` - Audit trail
- `party_data_quality` - Data quality metrics

## File Structure

```
mysql/
├── README.md                    # This file
├── sql/                        # SQL scripts directory
│   ├── 01_schema.sql          # Database schema creation
│   ├── 02_indexes.sql         # Performance indexes
│   ├── 03_triggers.sql        # Database triggers
│   ├── 04_views.sql           # Database views
│   ├── 05_stored_procedures.sql # Stored procedures
│   └── 06_sample_data.sql     # Sample data for testing
├── svg/                        # Model diagrams
│   └── party-mysql-pdm.svg    # MySQL PDM diagram
└── party-mysql-pdm.json       # PDM metadata
```

## Installation

1. Create a new MySQL database:
```sql
CREATE DATABASE party_mdm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Execute the SQL scripts in order:
```bash
mysql -u username -p party_mdm < sql/01_schema.sql
mysql -u username -p party_mdm < sql/02_indexes.sql
mysql -u username -p party_mdm < sql/03_triggers.sql
mysql -u username -p party_mdm < sql/04_views.sql
mysql -u username -p party_mdm < sql/05_stored_procedures.sql
```

3. Optionally load sample data:
```bash
mysql -u username -p party_mdm < sql/06_sample_data.sql
```

## Performance Considerations

- All primary keys use auto-incrementing integers for optimal performance
- Foreign keys are properly indexed
- Composite indexes are created for frequently queried columns
- Partitioning is available for large tables (audit_log, data_quality)

## Security Features

- Row-level security through application logic
- Audit logging for all data changes
- Soft deletes to maintain data history
- Input validation through stored procedures

## Compliance

- Supports GDPR compliance through audit trails and data retention policies
- Implements data quality monitoring
- Provides data lineage tracking capabilities

## Version History

- **1.0.0** - Initial MySQL PDM implementation
  - Based on ALDM v1.0.0
  - Implements all core party management functionality
  - Includes audit and data quality features 