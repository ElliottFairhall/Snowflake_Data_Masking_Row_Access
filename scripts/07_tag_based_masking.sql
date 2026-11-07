-- =============================================================================
-- 07_TAG_BASED_MASKING
-- =============================================================================
-- Purpose:    Implement scalable masking using Object Tags
-- =============================================================================

-- 1. Create a tag for PII classification
CREATE OR REPLACE TAG masking_security.tags.pii_type
    ALLOWED_VALUES 'EMAIL', 'PHONE', 'NAME', 'ADDRESS', 'NI_NUMBER';

-- 2. Assign the tag to columns
-- ALTER TABLE masking_analytics.marts.dim_customers
-- MODIFY COLUMN email SET TAG masking_security.tags.pii_type = 'EMAIL';

-- ALTER TABLE masking_analytics.marts.dim_customers
-- MODIFY COLUMN phone_number SET TAG masking_security.tags.pii_type = 'PHONE';

-- 3. Create tag-based masking policy link
ALTER TAG masking_security.tags.pii_type
SET MASKING POLICY email_mask;
