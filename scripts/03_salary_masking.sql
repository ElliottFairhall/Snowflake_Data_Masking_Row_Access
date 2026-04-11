-- =============================================================================
-- 03_SALARY_MASKING
-- =============================================================================
-- Purpose:    Implement Dynamic Data Masking for numeric salary data
-- =============================================================================

-- 1. Create the masking policy
CREATE OR REPLACE MASKING POLICY salary_mask AS (val number)
RETURNS NUMBER ->
    CASE
        WHEN IS_ROLE_IN_SESSION('HR_ADMIN') THEN val
        WHEN IS_ROLE_IN_SESSION('MANAGER') THEN ROUND(val, -3)  -- Round to nearest 1000
    END;

-- 2. Apply the policy to a column (Example)
-- ALTER TABLE hr.employees
-- MODIFY COLUMN salary SET MASKING POLICY salary_mask;
