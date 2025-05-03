# Conceptual Data Models (CDM)

## Purpose
This folder contains the Enterprise Conceptual Data Models (CDM) for the organization. CDMs define the high-level semantics of the data domain, including entity classes, relationships, and the allowed expressions and facts within the model's scope. These models provide a business-oriented view of data, serving as the foundation for logical and physical models.

## Contents
- **CDM diagrams**: SVG, VSDX, or other diagram formats representing conceptual models
- **Mapping documents**: CSV or JSON files mapping CDM entities to logical models
- **Example files:**
  - `party-cdm.json` — JSON representation of the Party domain CDM
  - `svg/party-cdm.svg` — SVG diagram of the Party CDM

## Standards & Best Practices
- Use **PascalCase** for entity and relationship names
- Diagrams must use standard notations (Crow's Foot, UML)
- Store SVG diagrams in the `svg/` subfolder alongside model files
- Include a legend and date on all diagrams
- All changes must undergo peer review and be version-controlled

## How to Use/Contribute
1. Add new CDMs as JSON or diagram files
2. Update diagrams when models change
3. Ensure all diagrams are up-to-date and stored in `svg/`
4. Submit changes via pull request for review and approval by a data architect

## References
- [Crow's Foot Notation](https://vertabelo.com/blog/crow-s-foot-notation)
- [Data Modelling Standards](../README.md) 