-- =============================================================================
-- 06_MAPPING_TABLE_SETUP
-- =============================================================================
-- Purpose:    Create and populate security mapping tables for RAP
-- =============================================================================

-- 1. Mapping table for role-to-region access
CREATE TABLE IF NOT EXISTS security.role_region_mapping (
    role_name VARCHAR,
    region VARCHAR
);

-- 2. Seed mapping data
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
