-- =====================================================================
-- 00_create_table_and_load.sql
-- Creates the table that every other query in this folder reads from.
-- Source file: data/cleaned/superstore_clean.csv  (9,993 rows, 24 columns)
-- Written for SQLite / MySQL 8 / PostgreSQL. Small type differences are noted.
-- =====================================================================
DROP TABLE IF EXISTS superstore;

CREATE TABLE superstore (
    row_id         INTEGER,
    order_id       VARCHAR(20),
    order_date     DATE,            -- stored as YYYY-MM-DD
    ship_date      DATE,
    ship_mode      VARCHAR(20),
    customer_id    VARCHAR(20),
    customer_name  VARCHAR(60),
    segment        VARCHAR(20),     -- Consumer / Corporate / Home Office
    country        VARCHAR(30),
    city           VARCHAR(60),
    state          VARCHAR(40),
    postal_code    VARCHAR(10),     -- text, so leading zeros are kept (e.g. 06010)
    region         VARCHAR(20),     -- Central / East / South / West
    product_id     VARCHAR(20),
    category       VARCHAR(30),
    sub_category   VARCHAR(30),
    product_name   VARCHAR(200),
    sales          DECIMAL(12,4),   -- revenue of the order line
    quantity       INTEGER,
    discount       DECIMAL(4,2),    -- 0.20 = 20% discount
    profit         DECIMAL(12,4),
    order_year     INTEGER,         -- derived by us from order_date
    order_month    INTEGER,         -- derived by us (1-12)
    ship_days      INTEGER          -- derived by us: ship_date - order_date
);

-- HOW TO LOAD THE CSV (pick the one for your tool)
-- SQLite (command line):
--     .mode csv
--     .import --skip 1 data/cleaned/superstore_clean.csv superstore
-- MySQL Workbench: right-click the table > Table Data Import Wizard > choose the CSV.
-- PostgreSQL (psql):
--     \copy superstore FROM 'data/cleaned/superstore_clean.csv' CSV HEADER

-- QUICK CHECK after loading (expect 9993 rows, 5009 orders... see below):
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_id) AS distinct_orders FROM superstore;
