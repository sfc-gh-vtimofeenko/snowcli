SET INT_TEST_USER = 'SNOWCLI_TEST';
CREATE USER IF NOT EXISTS IDENTIFIER($INT_TEST_USER);

-- BASE SETUP
CREATE ROLE IF NOT EXISTS INTEGRATION_TESTS;
GRANT CREATE ROLE ON ACCOUNT TO ROLE INTEGRATION_TESTS;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE INTEGRATION_TESTS;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE INTEGRATION_TESTS;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE INTEGRATION_TESTS;
GRANT ROLE INTEGRATION_TESTS TO USER IDENTIFIER($INT_TEST_USER);

-- WAREHOUSE SETUP
CREATE WAREHOUSE IF NOT EXISTS XSMALL WAREHOUSE_SIZE=XSMALL;
GRANT ALL ON WAREHOUSE XSMALL TO ROLE INTEGRATION_TESTS;

-- DATABASES SETUP
CREATE DATABASE IF NOT EXISTS SNOWCLI_DB;
GRANT ALL ON DATABASE SNOWCLI_DB TO ROLE INTEGRATION_TESTS;
GRANT ALL ON SCHEMA SNOWCLI_DB.PUBLIC TO ROLE INTEGRATION_TESTS;

-- STAGES SETUP
CREATE STAGE IF NOT EXISTS SNOWCLI_STAGE DIRECTORY = ( ENABLE = TRUE );

-- CONTAINERS SETUP
CREATE OR REPLACE IMAGE REPOSITORY SNOWCLI_DB.PUBLIC.SNOWCLI_REPOSITORY;
GRANT READ, WRITE ON IMAGE REPOSITORY SNOWCLI_DB.PUBLIC.SNOWCLI_REPOSITORY TO ROLE INTEGRATION_TESTS;

CREATE COMPUTE POOL IF NOT EXISTS SNOWCLI_COMPUTE_POOL
    MIN_NODES = 1
    MAX_NODES = 1
    INSTANCE_FAMILY = CPU_X64_XS;

GRANT USAGE ON COMPUTE POOL SNOWCLI_COMPUTE_POOL TO ROLE INTEGRATION_TESTS;
GRANT MONITOR ON COMPUTE POOL SNOWCLI_COMPUTE_POOL TO ROLE INTEGRATION_TESTS;

ALTER COMPUTE POOL SNOWCLI_COMPUTE_POOL SUSPEND;

-- API INTEGRATION FOR SNOWGIT
CREATE API INTEGRATION snowcli_testing_repo_api_integration
API_PROVIDER = git_https_api
API_ALLOWED_PREFIXES = ('https://github.com/snowflakedb/')
ALLOWED_AUTHENTICATION_SECRETS = ()
ENABLED = true;
GRANT USAGE ON INTEGRATION snowcli_testing_repo_api_integration TO ROLE INTEGRATION_TESTS;
