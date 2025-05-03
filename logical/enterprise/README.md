# Enterprise Logical Data Models (ELDM)

## Purpose
This folder contains Enterprise Logical Data Models (ELDM), which define the ideal, organization-wide structure of data in third normal form (3NF). ELDMs provide a future-state view of data, ensuring consistency, normalization, and alignment with business requirements across the enterprise.

## Contents
- **ELDM model files**: Diagrams (SVG, PNG), mapping documents (CSV), and other artifacts (e.g., `party.svg`, `eldm_to_aldm_mapping.csv`)
- Each diagram or mapping file should correspond to a logical entity or relationship

## Standards & Best Practices
- Use **PascalCase** for logical entities and attributes
- All ELDMs must be in 3NF
- Store diagrams in SVG or PNG format; include a legend and date
- Ensure mapping documents are up-to-date and version-controlled
- All changes must undergo peer review and approval by a data architect

## How to Use/Contribute
1. Add or update ELDM model files and diagrams
2. Ensure all models are normalized and follow naming conventions
3. Update mapping documents as needed
4. Submit changes via pull request for review and approval

## References
- [3NF Definition](https://en.wikipedia.org/wiki/Third_normal_form)
- [Data Modelling Standards](../../README.md) 