# 🛡️ Snowflake Data Masking & Row Access

[![Snowflake](https://img.shields.io/badge/Snowflake-Cloud%20Data%20Platform-29B5E8?style=flat&logo=snowflake)](https://www.snowflake.com/)
[![SQL](https://img.shields.io/badge/SQL-Snowflake%20Dialect-lightgrey)](https://docs.snowflake.com/)
[![Status](https://img.shields.io/badge/Status-Educational-success)](https://github.com/ElliottFairhall/Snowflake_Data_Masking_Row_Access)

A complete guide to implementing **Dynamic Data Masking** and **Row Access Policies** (RAP) in Snowflake. This project
demonstrates how to protect PII, financial data, and sensitive records at both the column and row level using role-based
security.

______________________________________________________________________

## Key Features

- **Column Masking**: Techniques for partial/full redaction of emails, phones, and salaries.
- **Row-Level Security**: Filtering data visibility based on user region or department mapping.
- **Tag-Based Governance**: Scalable masking implementation using Snowflake object tags.
- **Auditing**: Monitoring policy effectiveness and usage via Snowflake query history.

______________________________________________________________________

## Project Structure

```text
Snowflake_Data_Masking_Row_Access/
├── README.md               # You are here
├── Tutorial/
│   └── DATA_MASKING_TUTORIAL.md # Step-by-step walkthrough
├── scripts/                # Extracted SQL scripts
│   ├── 01_email_masking.sql
│   ├── 02_phone_masking.sql
│   ├── 03_salary_masking.sql
│   ├── 04_region_row_access.sql
│   ├── 05_department_row_access.sql
│   ├── 06_mapping_table_setup.sql
│   ├── 07_tag_based_masking.sql
│   └── 08_monitoring_policies.sql
├── notebook/
│   └── Data_Masking_Tutorial.ipynb
└── data/                   # Security mapping definitions
```

______________________________________________________________________

## Getting Started

> **Environment Setup:** Before beginning, execute `scripts/00_setup_environment.sql` to provision the necessary
> databases, schemas, and sample data for this project.

1. Review the [Tutorial](Tutorial/DATA_MASKING_TUTORIAL.md) for concepts.
2. Deploy the masking policies in `scripts/01-03`.
3. Deploy the row-level security logic in `scripts/04-06`.

______________________________________________________________________

## Author

**Elliott Fairhall** *Data Engineering Educational Series*
