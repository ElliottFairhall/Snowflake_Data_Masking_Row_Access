-- =============================================================================
-- 08_MONITORING_POLICIES
-- =============================================================================
-- Purpose:    Audit and monitor policy references and usage
-- =============================================================================

-- 1. View all policies
SHOW MASKING POLICIES;
SHOW ROW ACCESS POLICIES;

-- 2. Check which columns have a specific masking policy applied
SELECT *
FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'email_mask'
));

-- 3. Audit policy usage in query history (Example)
/*
SELECT
    query_id,
    user_name,
    role_name,
    query_text
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%dim_customers%'
ORDER BY start_time DESC
LIMIT 20;
*/

-- 4. View tag references
-- SELECT *
-- FROM TABLE(INFORMATION_SCHEMA.TAG_REFERENCES(
--     'analytics.marts.dim_customers.email',
--     'COLUMN'
-- ));
