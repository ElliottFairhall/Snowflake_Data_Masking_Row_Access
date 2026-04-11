-- =============================================================================
-- 07_TAG_BASED_MASKING
-- =============================================================================
-- Purpose:    Implement scalable masking using Object Tags
-- =============================================================================

-- 1. Create a tag for PII classification
CREATE OR REPLACE TAG security.tags.pii_type
    ALLOWED_VALUES 'EMAIL', 'PHONE', 'NAME', 'ADDRESS', 'NI_NUMBER';

-- 2. Assign the tag to columns
-- ALTER TABLE analytics.marts.dim_customers
-- MODIFY COLUMN email SET TAG security.tags.pii_type = 'EMAIL';

-- ALTER TABLE analytics.marts.dim_customers
-- MODIFY COLUMN phone_number SET TAG security.tags.pii_type = 'PHONE';

-- 3. Create tag-based masking policy link
ALTER TAG security.tags.pii_type
SET MASKING POLICY email_mask;
