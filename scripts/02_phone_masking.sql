-- =============================================================================
-- 02_PHONE_MASKING
-- =============================================================================
-- Purpose:    Implement Dynamic Data Masking for phone numbers
-- =============================================================================

-- 1. Create the masking policy
CREATE OR REPLACE MASKING POLICY phone_mask AS (val string)
RETURNS STRING ->
    CASE
        WHEN IS_ROLE_IN_SESSION('PII_ADMIN') THEN val
        ELSE CONCAT('***-***-', RIGHT(val, 4))
    END;

-- 2. Apply the policy to a column (Example)
-- ALTER TABLE analytics.marts.dim_customers
-- MODIFY COLUMN phone_number SET MASKING POLICY phone_mask;
