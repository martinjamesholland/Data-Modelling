# Logical Data Models

## Purpose
This folder contains all logical data models, which define the idealized structure of data for the enterprise and applications. Logical models are split into:
- **Enterprise Logical Data Models (ELDM):** Org-wide, future-state models in 3NF.
- **Application Logical Data Models (ALDM):** Application-specific, current-state models in 3NF, including standard attributes.

Logical models serve as the bridge between conceptual and physical models, ensuring data consistency, normalization, and alignment with business requirements.

## Contents
- **enterprise/**: ELDM artifacts (e.g., `party.svg`, `eldm_to_aldm_mapping.csv`)
- **application/**: ALDM artifacts (e.g., `party-aldm.json`, `aldm_to_bim_mapping.csv`)
- Mapping documents between logical and other model layers

## Standards & Best Practices
- Use **PascalCase** for logical entities and attributes
- All logical models must be in third normal form (3NF)
- Include standard attributes in ALDM: `created_at`, `updated_at`, `deleted_at` (if soft deletes)
- Store diagrams (SVG) in the appropriate `svg/` subfolders
- All changes must undergo peer review and be version-controlled

## How to Use/Contribute
1. Add or update logical models in the appropriate subfolder
2. Ensure diagrams and mapping documents are up-to-date
3. Follow naming conventions and normalization standards
4. Submit changes via pull request for review and approval by a data architect

## References
- [3NF Definition](https://en.wikipedia.org/wiki/Third_normal_form)
- [Data Modelling Standards](../README.md) 