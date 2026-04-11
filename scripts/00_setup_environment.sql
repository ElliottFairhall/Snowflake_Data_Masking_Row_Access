-- =============================================================================
-- 00_SETUP_ENVIRONMENT
-- =============================================================================
-- Purpose:    Provision the necessary databases, schemas, and sample data
--             required to execute the Data Masking and Row Access scripts.
-- =============================================================================

USE ROLE SYSADMIN;

-- 1. Create Databases
CREATE DATABASE IF NOT EXISTS ANALYTICS;
CREATE DATABASE IF NOT EXISTS HR;
CREATE DATABASE IF NOT EXISTS SECURITY;

-- 2. Create Schemas
CREATE SCHEMA IF NOT EXISTS ANALYTICS.MARTS;
CREATE SCHEMA IF NOT EXISTS HR.PUBLIC;
CREATE SCHEMA IF NOT EXISTS SECURITY.TAGS;

-- 3. Create and populate Customer dimension with PII
CREATE OR REPLACE TABLE ANALYTICS.MARTS.DIM_CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    PHONE_NUMBER VARCHAR,
    SEGMENT VARCHAR
);

INSERT INTO ANALYTICS.MARTS.DIM_CUSTOMERS VALUES
    (1, 'James Smith', 'james.smith@example.co.uk', '020-7946-1234', 'Enterprise'),
    (2, 'Sarah Jenkins', 'sarah.j@company.com', '07700-900456', 'SMB'),
    (3, 'David Chen', 'd.chen@enterprise.io', '01632-960111', 'Mid-Market');

-- 4. Create and populate Employee table with Salary Data
CREATE OR REPLACE TABLE HR.PUBLIC.EMPLOYEES (
    EMPLOYEE_ID INT,
    EMPLOYEE_NAME VARCHAR,
    DEPARTMENT VARCHAR,
    SALARY NUMBER
);

INSERT INTO HR.PUBLIC.EMPLOYEES VALUES
    (101, 'Alice Walker', 'Engineering', 85500),
    (102, 'Bob Thompson', 'Sales', 62300),
    (103, 'Clara Oswald', 'HR', 55000);

-- 5. Create and populate Sales fact table with Region Data
CREATE OR REPLACE TABLE ANALYTICS.MARTS.FCT_SALES (
    SALE_ID INT,
    REGION VARCHAR,
    REVENUE NUMBER
);

INSERT INTO ANALYTICS.MARTS.FCT_SALES VALUES
    (1001, 'UK', 1500),
    (1002, 'France', 2300),
    (1003, 'Germany', 4100),
    (1004, 'US', 8900);

-- Note: The security.role_region_mapping table is created in script 06.
