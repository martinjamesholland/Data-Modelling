# Data Modelling Project

A comprehensive repository for enterprise data modeling, following industry best practices and organizational standards for conceptual, logical, and physical data models.

## Purpose

This repository serves as the central location for all data modeling artifacts in our organization, providing a structured approach to data design across the enterprise. It ensures consistency, quality, and maintainability in data modeling outputs while supporting various stakeholders including data architects, developers, and business analysts.

## Structure

The repository is organized according to our Data Modelling Standards:

```
/data-modelling/
  /conceptual/        # Enterprise Conceptual Data Models (CDM)
  /logical/
    /enterprise/      # Enterprise Logical Data Models (ELDM)
    /application/     # Application Logical Data Models (ALDM)
  /business/          # Business Information Models (BIM)
  /physical/          # Physical Data Models (PDM)
  /Request Logs/      # Documentation of modeling requests and implementations
```

## Model Types

- **Enterprise Conceptual Data Model (CDM)**: Describes the semantics of the data domain, including entity classes and relationships.
- **Enterprise Logical Data Model (ELDM)**: Organization-wide, ideal future-state structure in third normal form (3NF).
- **Application Logical Data Model (ALDM)**: Application-specific, current-state structure in 3NF with standard attributes.
- **Business Information Model (BIM)**: Includes business glossary, glossary of terms, and acceptable values.
- **Physical Data Model (PDM)**: Describes physical storage implementations, which may use various forms (3NF, star, snowflake, Data Vault) depending on technology and use case.

## Implementation Details

### Physical Models

The repository includes various physical data model implementations:

- **Data Vault 2.0**: Highly scalable, adaptable architecture for Master Data Management, supporting:
  - Time-series data with full historical tracking
  - Multiple update frequencies (real-time, daily, weekly)
  - Data from diverse source systems
  - Auditability and lineage tracking
  - Split satellite model for performance optimization:
    - Current satellites for fast operational queries
    - History satellites for complete temporal data

### Project History and Deliverables

This repository represents a structured approach to data modeling with the following key deliverables:

1. **Data Modeling Standards**: Establishing comprehensive rules for creating, maintaining, and managing different types of data models.

2. **Party Domain Models**: Complete set of data models for the Party domain:
   - Conceptual Data Model (CDM)
   - Enterprise Logical Data Model (ELDM)
   - Application Logical Data Model (ALDM) with comprehensive UML diagrams
   - Business Information Model (BIM) with glossary and term definitions
   - Physical Data Models (PDM):
     - MongoDB implementation
     - REST API specification (OpenAPI/Swagger)
     - Data Vault 2.0 for data warehousing

3. **Data Vault 2.0 Implementation**: Specialized physical model for data warehousing:
   - Hub, link, and satellite table definitions
   - Support for both Hadoop Delta format and GCP BigQuery
   - Optimized split satellite model (current and history satellites)
   - Synchronization mechanisms for performance optimization

4. **Mapping Documents**: Cross-reference documentation between different model types and layers.

Each model includes appropriate visualizations (SVG diagrams) and implementation code where applicable.

### Standards & Best Practices

- All models follow established naming conventions and diagramming standards
- Logical models (ELDM, ALDM) adhere to third normal form (3NF)
- Standard attributes are included in application models
- Entity Relationship Diagrams (ERDs) are maintained alongside model definitions
- Security and privacy considerations are documented

## Getting Started

1. Browse the appropriate folder based on your modeling needs
2. Review existing models before creating new ones to ensure consistency
3. Follow the naming conventions and standards documented in each section
4. Maintain SVG visualizations for all conceptual and logical models

## Contributing

When contributing to this repository:

1. Follow the established folder structure
2. Adhere to naming conventions and modeling standards
3. Include appropriate documentation and diagrams
4. Submit changes through the established review process

## Review & Approval Process

- All model changes must undergo peer review
- Approval from a data architect is required for ELDM/ALDM changes
- Document review outcomes and rationale 