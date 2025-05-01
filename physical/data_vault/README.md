# Party Domain - Data Vault 2.0 Physical Model

This directory contains the Data Vault 2.0 physical model implementation for the Party domain in our Master Data Management system.

## Overview

The Data Vault 2.0 model provides a highly scalable, adaptable architecture that is ideal for handling:
- Time-series data with full historical tracking
- Multiple update frequencies (real-time, daily, weekly)
- Data from diverse source systems
- Changing business requirements
- Auditability and lineage tracking

## Directory Structure

- `/sql/`: SQL definitions for Delta format on Hadoop and GCP BigQuery
  - Hub tables (business keys)
  - Link tables (relationships)
  - Satellite tables (descriptive attributes with time variance)
    - Current satellites (optimized for fast queries)
    - History satellites (full time-series data)
  - Synchronization triggers and procedures
- `/svg/`: Visualization of the Data Vault 2.0 model

## Implementation Notes

### Hub Tables
Store unique business keys with immutable surrogate keys:
- `hub_party.sql`: Core party entity
- `hub_person.sql`: Person entity
- `hub_organization.sql`: Organization entity
- `hub_location.sql`: Location entity
- `hub_contact_point.sql`: Contact point entity
- `hub_agreement.sql`: Agreement entity

### Link Tables
Connect hub entities to form relationships:
- `link_party_person.sql`: Links Party to Person
- `link_party_organization.sql`: Links Party to Organization
- `link_party_location.sql`: Links Party to Location
- `link_party_contact.sql`: Links Party to Contact Points
- `link_party_relationship.sql`: Links Party to Party (relationships)
- `link_party_agreement.sql`: Links Party to Agreements

### Satellite Tables (Split Model for Performance)

#### Current Satellites
Optimized for fast queries on current values:
- `sat_party_current.sql`: Current party attributes
- `sat_person_current.sql`: Current person attributes
- `sat_organization_current.sql`: Current organization attributes

Benefits:
- Smaller table size (single row per entity)
- No partitioning required
- Fast primary key lookup
- No filtering on `is_current = TRUE`
- Optimized indexing for common queries
- Used for all real-time operational queries

#### History Satellites
Store full historical data with time-series capabilities:
- `sat_party_history.sql`: Complete party attribute history
- `sat_person_history.sql`: Complete person attribute history
- `sat_organization_history.sql`: Complete organization attribute history

Benefits:
- Full temporal data with effective dating
- Support for point-in-time analysis
- Partitioned by load date for efficient historical queries
- Maintains complete history and auditability
- Used for analytical and compliance queries

### Synchronization
The split satellite model uses automated synchronization:
- `sat_sync_trigger.sql`: Procedures to keep current and history satellites in sync
- Scheduled to run at configurable intervals (e.g., every 15 minutes)
- One-way sync from history to current (write once to history, read many from current)

## Update Frequencies

All history satellite tables support multiple update frequencies through the `update_frequency` attribute:
- `real-time`: For streaming updates requiring immediate processing
- `daily`: For daily batch updates
- `weekly`: For weekly updates
- `monthly`: For monthly updates or other less frequent changes

## Views

Each satellite has associated views:
- `*_current`: Pre-materialized current state (separate tables)
- `*_history_by_day`: Aggregated historical data by day
- `*_history_realtime`: Real-time update records for streaming
- `*_history_daily`: Daily batch update records

## Platform-Specific Implementations

### Hadoop Delta Format
- Uses `USING DELTA` clause
- Different partitioning strategies:
  - History satellites: Partitioned by year and month of load date
  - Current satellites: No partitioning (small tables with single current record per entity)
- Clustered by business keys
- Support for time-travel queries on history satellites

### GCP BigQuery
- History satellites: Date partitioning on load_date
- Current satellites: Clustering without partitioning
- Scheduled queries for synchronization
- Optimized for analytical workloads

## Handling Time-Series Data

All history satellite tables include:
- `load_date`: Technical load timestamp
- `load_end_date`: Technical end date for the record
- `effective_from`: Business effective date
- `effective_to`: Business end date
- `is_current`: Flag for current record
- `hash_diff`: Hash for detecting changes

## Entity Relationship Diagrams

See the visual representations of the Data Vault 2.0 models:
- [Party Data Vault 2.0 Base Model](svg/party_data_vault_model.svg)
- [Party Data Vault 2.0 Split Satellite Model](svg/party_data_vault_split_model.svg) 