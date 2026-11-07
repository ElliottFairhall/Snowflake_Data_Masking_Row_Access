-- =============================================================================
-- 04_REGION_ROW_ACCESS
-- =============================================================================
-- Purpose:    Implement Row Access Policies for regional visibility
-- =============================================================================

-- 1. Create the row access policy
CREATE OR REPLACE ROW ACCESS POLICY region_access AS (region_val VARCHAR)  -- noqa: LT01
RETURNS BOOLEAN ->
    IS_ROLE_IN_SESSION('DATA_ADMIN')
    OR EXISTS (
        SELECT 1
        FROM security.role_region_mapping
        WHERE role_name = CURRENT_ROLE()
          AND region = region_val
    );

-- 2. Apply the policy to a table (Example)
-- ALTER TABLE masking_analytics.marts.fct_sales
-- ADD ROW ACCESS POLICY region_access ON (region);
