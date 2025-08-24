# Physical Data Models (PDM)

## Purpose
This folder contains Physical Data Models (PDM), which describe the implementation of data models in specific technologies and platforms. PDMs may use various forms (3NF, star, snowflake, Data Vault) and include details such as partitions, table spaces, schemas, API contracts, and analytics platform structures.

## Contents
- **mongodb/**: MongoDB-specific PDM artifacts (e.g., `party-pdm-schema.json`)
- **mysql/**: MySQL-specific PDM artifacts (e.g., SQL scripts, stored procedures, views)
- **api/**: API contract specifications (e.g., OpenAPI YAML files)
- **data_vault/**: Data Vault 2.0 models and related artifacts
- Other technology-specific subfolders as needed

## Standards & Best Practices
- Use **lower_snake_case** for physical database objects
- Choose the most suitable modeling form for the technology and use case
- Document data retention, deletion, and security policies
- Store diagrams and schema files in appropriate subfolders
- All changes must undergo peer review and be version-controlled

## How to Use/Contribute
1. Add or update PDM artifacts in the appropriate subfolder
2. Ensure all models are aligned with logical models and business requirements
3. Document technology-specific implementation details
4. Submit changes via pull request for review and approval

## References
- [Data Vault 2.0](https://danlinstedt.com/all-about-data-vault)
- [Kimball Methodology](https://www.kimballgroup.com)
- [Data Modelling Standards](../README.md) 