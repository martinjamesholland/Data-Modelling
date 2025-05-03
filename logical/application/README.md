# Application Logical Data Models (ALDM)

## Purpose
This folder contains Application Logical Data Models (ALDM), which define the current-state, application-specific logical structure of data. ALDMs are reusable across application layers (data stores, APIs, analytics) and must be in third normal form (3NF). Each ALDM includes standard attributes and is aligned with the enterprise logical model.

## Contents
- **ALDM model files**: JSON, CSV, or other formats (e.g., `party-aldm.json`)
- **Mapping documents**: Files mapping ALDM to BIM or other models (e.g., `aldm_to_bim_mapping.csv`)
- **svg/**: Folder containing SVG diagrams of ALDMs

## Standards & Best Practices
- Use **PascalCase** for logical entities and attributes
- All ALDMs must be in 3NF and include `created_at`, `updated_at`, and `deleted_at` (if soft deletes)
- Store diagrams in the `svg/` subfolder
- Ensure mapping documents are up-to-date and version-controlled
- All changes must undergo peer review

## How to Use/Contribute
1. Add or update ALDM model files and diagrams
2. Ensure all models are normalized and include standard attributes
3. Update mapping documents as needed
4. Submit changes via pull request for review and approval by a data architect

## References
- [3NF Definition](https://en.wikipedia.org/wiki/Third_normal_form)
- [Data Modelling Standards](../../README.md) 