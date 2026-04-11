# 🚀 Snowflake Data Masking & Row Access Policies Tutorial

## 🎯 Learning Objectives

1. 🧠 Understand the concepts of Dynamic Data Masking and Row Access Policies within Snowflake.

2. 🛠️ Master the creation and application of masking policies to protect sensitive data at the column level.

3. 🔗 Learn how to implement Row Access Policies to control which rows users can see based on their role.

## 📚 Table of Contents

- [🚀 Snowflake Data Masking & Row Access Policies Tutorial](#-snowflake-data-masking--row-access-policies-tutorial)
  - [🎯 Learning Objectives](#-learning-objectives)
  - [📚 Table of Contents](#-table-of-contents)
    - [🎉 Introduction](#-introduction)
    - [📝 Introduction to Data Governance Policies](#-introduction-to-data-governance-policies)
    - [🎭 Dynamic Data Masking](#-dynamic-data-masking)
    - [🔐 Row Access Policies](#-row-access-policies)
    - [🏷️ Tag-Based Masking](#%EF%B8%8F-tag-based-masking)
    - [🔍 Monitoring and Auditing Policies](#-monitoring-and-auditing-policies)
  - [💡 Tutorial](#-tutorial)
  - [🎈 Conclusion](#-conclusion)
  - [📖 Additional Resources](#-additional-resources)
  - [⚠️ Disclaimer](#%EF%B8%8F-disclaimer)

### 🎉 Introduction

Welcome to this tutorial on Dynamic Data Masking and Row Access Policies within Snowflake! This tutorial is designed to
help you understand and implement column-level and row-level security in your Snowflake environment. By the end of this
tutorial, you'll be able to confidently protect sensitive data such as PII, financial information, and confidential
business data. So, let's dive in! 🏊‍♀️

### 📝 Introduction to Data Governance Policies

Snowflake provides several policy types for governing data access:

| Policy Type            | Level  | Purpose                                       | Edition Required |
| ---------------------- | ------ | --------------------------------------------- | ---------------- |
| **Masking Policy**     | Column | Mask or redact column values based on role    | Enterprise+      |
| **Row Access Policy**  | Row    | Filter rows based on role or attributes       | Enterprise+      |
| **Projection Policy**  | Column | Prevent specific columns from being projected | Enterprise+      |
| **Aggregation Policy** | Table  | Require minimum group size for queries        | Enterprise+      |

These policies are evaluated at query time and are transparent to the user — the query runs normally, but the data
returned is filtered or masked according to the policy.

### 🎭 Dynamic Data Masking

Dynamic Data Masking allows you to define masking rules that are applied at query time based on the user's role. The
underlying data remains unchanged — only the query results are masked.

```sql
-- Masking policy for email addresses
CREATE OR REPLACE MASKING POLICY email_mask AS (val STRING)
RETURNS STRING ->
    CASE
        WHEN IS_ROLE_IN_SESSION('PII_ADMIN') THEN val
        WHEN IS_ROLE_IN_SESSION('ANALYST') THEN REGEXP_REPLACE(val, '.+@', '***@')
        ELSE '***MASKED***'
    END;

-- Apply the policy to a column
ALTER TABLE analytics.marts.dim_customers
MODIFY COLUMN email SET MASKING POLICY email_mask;
```

```sql
-- Masking policy for phone numbers
CREATE OR REPLACE MASKING POLICY phone_mask AS (val STRING)
RETURNS STRING ->
    CASE
        WHEN IS_ROLE_IN_SESSION('PII_ADMIN') THEN val
        ELSE CONCAT('***-***-', RIGHT(val, 4))
    END;

ALTER TABLE analytics.marts.dim_customers
MODIFY COLUMN phone_number SET MASKING POLICY phone_mask;
```

```sql
-- Masking policy for numeric values (e.g., salary)
CREATE OR REPLACE MASKING POLICY salary_mask AS (val NUMBER)
RETURNS NUMBER ->
    CASE
        WHEN IS_ROLE_IN_SESSION('HR_ADMIN') THEN val
        WHEN IS_ROLE_IN_SESSION('MANAGER') THEN ROUND(val, -3)  -- Round to nearest 1000
        ELSE NULL
    END;

ALTER TABLE hr.employees
MODIFY COLUMN salary SET MASKING POLICY salary_mask;
```

The result when querying as different roles:

| Role        | Email Result       | Phone Result  | Salary Result |
| ----------- | ------------------ | ------------- | ------------- |
| `PII_ADMIN` | james@example.com  | 020-7946-1234 | 65000         |
| `ANALYST`   | \*\*\*@example.com | ***-***-1234  | NULL          |
| `MANAGER`   | ***MASKED***       | ***-***-1234  | 65000         |

### 🔐 Row Access Policies

Row Access Policies control which rows a user can see when querying a table. They act as an automatic WHERE clause that
is applied transparently at query time.

```sql
-- Row access policy: Users can only see data for their assigned region
CREATE OR REPLACE ROW ACCESS POLICY region_access AS (region_val VARCHAR)
RETURNS BOOLEAN ->
    IS_ROLE_IN_SESSION('DATA_ADMIN')
    OR EXISTS (
        SELECT 1
        FROM security.role_region_mapping
        WHERE role_name = CURRENT_ROLE()
          AND region = region_val
    );

-- Apply the policy to a table
ALTER TABLE analytics.marts.fct_sales
ADD ROW ACCESS POLICY region_access ON (region);
```

```sql
-- Row access policy: Department-level access
CREATE OR REPLACE ROW ACCESS POLICY department_access AS (dept_val VARCHAR)
RETURNS BOOLEAN ->
    IS_ROLE_IN_SESSION('HR_ADMIN')
    OR dept_val = CURRENT_SESSION_CONTEXT('DEPARTMENT');

ALTER TABLE hr.employees
ADD ROW ACCESS POLICY department_access ON (department);
```

```sql
-- Mapping table for role-to-region access
CREATE TABLE IF NOT EXISTS security.role_region_mapping (
    role_name VARCHAR,
    region VARCHAR
);

INSERT INTO security.role_region_mapping VALUES
    ('UK_ANALYST', 'UK'),
    ('UK_ANALYST', 'Ireland'),
    ('EU_ANALYST', 'Germany'),
    ('EU_ANALYST', 'France'),
    ('EU_ANALYST', 'Netherlands'),
    ('GLOBAL_ANALYST', 'UK'),
    ('GLOBAL_ANALYST', 'EU'),
    ('GLOBAL_ANALYST', 'US'),
    ('GLOBAL_ANALYST', 'APAC');
```

### 🏷️ Tag-Based Masking

For large-scale deployments, you can use **tags** to apply masking policies based on data classification rather than
applying policies table-by-table.

```sql
-- Create a tag for PII classification
CREATE OR REPLACE TAG security.tags.pii_type
    ALLOWED_VALUES 'EMAIL', 'PHONE', 'NAME', 'ADDRESS', 'NI_NUMBER';

-- Assign the tag to columns
ALTER TABLE analytics.marts.dim_customers
MODIFY COLUMN email SET TAG security.tags.pii_type = 'EMAIL';

ALTER TABLE analytics.marts.dim_customers
MODIFY COLUMN phone_number SET TAG security.tags.pii_type = 'PHONE';

-- Create tag-based masking policy
ALTER TAG security.tags.pii_type
SET MASKING POLICY email_mask;
```

This approach scales well: when you tag a new column as `EMAIL`, the masking policy is applied automatically.

### 🔍 Monitoring and Auditing Policies

```sql
-- View all masking policies
SHOW MASKING POLICIES;

-- View all row access policies
SHOW ROW ACCESS POLICIES;

-- Check which columns have masking policies applied
SELECT *
FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'email_mask'
));

-- Audit policy usage in query history
SELECT
    query_id,
    user_name,
    role_name,
    query_text
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%dim_customers%'
ORDER BY start_time DESC
LIMIT 20;

-- View tag references
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES(
    'analytics.marts.dim_customers.email',
    'COLUMN'
));
```

## 💡 Tutorial

In this tutorial, we'll be exploring how to implement a comprehensive data governance model using Dynamic Data Masking
and Row Access Policies. We'll create masking policies for common PII patterns (email, phone, national insurance
number), implement region-based row access controls, and set up tag-based masking for scalable policy management.

By the end of this tutorial, you'll have gained a comprehensive understanding of how to protect sensitive data at both
the column and row level, ensuring your Snowflake environment meets regulatory and compliance requirements.

## 🎈 Conclusion

In conclusion, Dynamic Data Masking and Row Access Policies are essential data governance features in Snowflake that
enable you to protect sensitive data without modifying the underlying tables or changing application queries. Masking
policies control what users see at the column level, whilst Row Access Policies control which rows are visible. Combined
with tag-based masking for scalability, these features allow you to implement fine-grained, role-based data governance
that meets regulatory requirements such as GDPR, CCPA, and industry-specific compliance standards.

## 📖 Additional Resources

- [Dynamic Data Masking Documentation](https://docs.snowflake.com/en/user-guide/security-column-ddm-intro)
- [Row Access Policies Documentation](https://docs.snowflake.com/en/user-guide/security-row-intro)
- [Tag-Based Masking Policies](https://docs.snowflake.com/en/user-guide/tag-based-masking-policies)
- [Data Classification](https://docs.snowflake.com/en/user-guide/governance-classify)

## ⚠️ Disclaimer

Please note that whilst we strive to keep this tutorial up-to-date, Snowflake's features and capabilities may change
over time. Always refer to the [official Snowflake documentation](https://docs.snowflake.com/) for the most accurate and
current information.
