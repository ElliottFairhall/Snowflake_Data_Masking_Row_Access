-- =============================================================================
-- 05_DEPARTMENT_ROW_ACCESS
-- =============================================================================
-- Purpose:    Implement Row Access Policies for department-level visibility
-- =============================================================================

-- 1. Create the row access policy
CREATE OR REPLACE ROW ACCESS POLICY department_access AS (dept_val VARCHAR)
RETURNS BOOLEAN ->
    IS_ROLE_IN_SESSION('HR_ADMIN')
    OR dept_val = CURRENT_SESSION_CONTEXT('DEPARTMENT');

-- 2. Apply the policy to a table (Example)
-- ALTER TABLE hr.employees
-- ADD ROW ACCESS POLICY department_access ON (department);
