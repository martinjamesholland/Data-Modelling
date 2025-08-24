# MySQL PDM Diagrams

This directory contains SVG diagrams for the MySQL Physical Data Model (PDM).

## Diagrams

- `party-mysql-pdm.svg` - Complete MySQL PDM diagram showing all tables and relationships
- `party-mysql-pdm-core.svg` - Core tables only (party, person, organization)
- `party-mysql-pdm-relationships.svg` - Relationship-focused diagram

## Diagram Conventions

- **Tables**: Represented as rectangles with table name and key columns
- **Primary Keys**: Underlined and marked with (PK)
- **Foreign Keys**: Marked with (FK) and connected to referenced tables
- **Relationships**: Shown with crow's foot notation
- **Indexes**: Shown as small icons next to indexed columns
- **Data Types**: Shown in parentheses after column names

## Legend

- 🔑 Primary Key
- 🔗 Foreign Key
- 📊 Index
- 🔍 Full-text Index
- ⏰ Timestamp columns
- 🗑️ Soft delete column

## Usage

These diagrams can be used for:
- Database design documentation
- Development team reference
- Stakeholder presentations
- Database administration guides
- Training materials

## Generation

Diagrams are generated using standard ERD tools and follow the data modelling standards for consistency and clarity. 