-- =============================================================================
-- 01_EMAIL_MASKING
-- =============================================================================
-- Purpose:    Implement Dynamic Data Masking for email addresses
-- =============================================================================

-- 1. Create the masking policy
CREATE OR REPLACE MASKING POLICY email_mask AS (val string)  -- noqa: LT01
RETURNS STRING ->
    CASE
        WHEN IS_ROLE_IN_SESSION('PII_ADMIN') THEN val
        WHEN IS_ROLE_IN_SESSION('ANALYST') THEN REGEXP_REPLACE(val, '.+@', '***@')
        ELSE '***MASKED***'
    END;

-- 2. Apply the policy to a column (Example)
-- ALTER TABLE masking_analytics.marts.dim_customers
-- MODIFY COLUMN email SET MASKING POLICY email_mask;
