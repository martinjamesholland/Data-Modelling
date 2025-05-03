# Data Vault SQL Scripts

## Purpose
This folder contains SQL scripts for implementing the Data Vault 2.0 physical data model. These scripts define the structure, creation, and management of hubs, links, satellites, and triggers for the Data Vault implementation.

## Contents
- **SQL scripts**: Table creation, triggers, and other DDL files (e.g., `hub_party.sql`, `sat_party_current.sql`, `sat_sync_trigger.sql`)
- Each script should correspond to a Data Vault component or process

## Standards & Best Practices
- Use **lower_snake_case** for all table and column names
- Follow Data Vault 2.0 modeling conventions for hubs, links, and satellites
- Document the purpose and dependencies of each script
- All changes must undergo peer review and be version-controlled

## How to Use/Contribute
1. Add or update SQL scripts for Data Vault components
2. Ensure scripts are consistent with the Data Vault model and naming conventions
3. Document any dependencies or special instructions in comments
4. Submit changes via pull request for review and approval

## References
- [Data Vault 2.0](https://danlinstedt.com/all-about-data-vault)
- [Data Modelling Standards](../../../../README.md) 