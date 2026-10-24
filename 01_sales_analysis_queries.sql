-- =====================================================================
-- 01_sales_analysis_queries.sql
-- Sales Performance & Revenue Analysis | Table: superstore
-- Each query = goal, line-by-line explanation, expected output columns.
-- Tested in SQLite. MySQL 8 / PostgreSQL run it as-is. SQL Server users:
-- replace "LIMIT 10" with "SELECT TOP 10" and use CAST for decimals.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q1. TOTAL REVENUE, TOTAL PROFIT, PROFIT MARGIN
-- Output: 1 row -> total_revenue | total_profit | profit_margin_pct
-- ---------------------------------------------------------------------
SELECT
    ROUND(SUM(sales), 2)                      AS total_revenue,      -- add up every line's sales
    ROUND(SUM(profit), 2)                     AS total_profit,       -- add up every line's profit (losses are negative)
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS profit_margin_pct  -- profit as % of revenue (100.0 forces decimal division)
FROM superstore;

-- ---------------------------------------------------------------------
-- Q2. TOTAL ORDERS, UNITS SOLD, AVERAGE ORDER VALUE
-- Output: 1 row -> total_orders | units_sold | order_lines | avg_order_value
-- ---------------------------------------------------------------------
SELECT
    COUNT(DISTINCT order_id)                          AS total_orders,     -- an order has many lines, so count unique IDs
    SUM(quantity)                                     AS units_sold,       -- total items
    COUNT(*)                                          AS order_lines,      -- rows in the table
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2)   AS avg_order_value   -- revenue per order
FROM superstore;

-- ---------------------------------------------------------------------
-- Q3. MONTHLY SALES AND PROFIT TREND
-- Output: 48 rows (Jan 2014 - Dec 2017) -> order_year | order_month | revenue | profit | margin_pct
-- ---------------------------------------------------------------------
SELECT
    order_year,                                       -- year part (derived column)
    order_month,                                      -- month number 1-12
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY order_year, order_month                      -- one row per year-month
ORDER BY order_year, order_month;                     -- oldest first so it reads like a timeline

-- ---------------------------------------------------------------------
-- Q4. TOP 10 PRODUCTS BY REVENUE
-- Output: 10 rows -> product_name | revenue | profit | units_sold | margin_pct
-- ---------------------------------------------------------------------
SELECT
    product_name,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    SUM(quantity)                             AS units_sold,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY product_name                                  -- combine all lines of the same product
ORDER BY revenue DESC                                  -- biggest first
LIMIT 10;                                              -- keep the top 10 only

-- ---------------------------------------------------------------------
-- Q5a. MOST PROFITABLE PRODUCT CATEGORIES
-- Output: 3 rows -> category | revenue | profit | margin_pct
-- ---------------------------------------------------------------------
SELECT
    category,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY category
ORDER BY profit DESC;

-- Q5b. SAME, BY SUB-CATEGORY (finds the loss-making ones)
-- Output: 17 rows -> category | sub_category | revenue | profit | margin_pct
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY category, sub_category
ORDER BY profit DESC;                                  -- losses appear at the bottom

-- ---------------------------------------------------------------------
-- Q6a. REGION-WISE SALES
-- Output: 4 rows -> region | orders | revenue | profit | margin_pct
-- ---------------------------------------------------------------------
SELECT
    region,
    COUNT(DISTINCT order_id)                  AS orders,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY region
ORDER BY revenue DESC;

-- Q6b. CITY-WISE SALES (top 10 cities by revenue)
-- Output: 10 rows -> city | state | revenue | profit | margin_pct
SELECT
    city,
    state,                                             -- 57 city names exist in several states, so group by both
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY city, state
ORDER BY revenue DESC
LIMIT 10;

-- Q6c. REGION x CATEGORY PROFIT (where exactly is a region weak?)
-- Output: 12 rows -> region | category | revenue | profit | margin_pct
SELECT
    region,
    category,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY region, category
ORDER BY region, profit DESC;

-- ---------------------------------------------------------------------
-- Q7. CUSTOMER SEGMENT PERFORMANCE
-- Output: 3 rows -> segment | customers | orders | revenue | profit | margin_pct | revenue_per_customer
-- ---------------------------------------------------------------------
SELECT
    segment,
    COUNT(DISTINCT customer_id)               AS customers,
    COUNT(DISTINCT order_id)                  AS orders,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct,
    ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM superstore
GROUP BY segment
ORDER BY revenue DESC;

-- ---------------------------------------------------------------------
-- Q8a. DISCOUNT IMPACT ON PROFITABILITY (grouped into bands)
-- Output: 4 rows -> discount_band | order_lines | revenue | profit | margin_pct
-- ---------------------------------------------------------------------
SELECT
    CASE                                               -- CASE puts each line into a band
        WHEN discount = 0    THEN '1) No discount'
        WHEN discount <= 0.2 THEN '2) Up to 20%'
        WHEN discount <= 0.4 THEN '3) 21% to 40%'
        ELSE                      '4) Over 40%'
    END                                       AS discount_band,
    COUNT(*)                                  AS order_lines,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY discount_band                                 -- group by the label created above
ORDER BY discount_band;                                -- numbers in the labels keep the order

-- Q8b. THE SAME, FOR EVERY EXACT DISCOUNT LEVEL
-- Output: 12 rows -> discount | order_lines | revenue | profit | margin_pct
SELECT
    discount,
    COUNT(*)                                  AS order_lines,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct
FROM superstore
GROUP BY discount
ORDER BY discount;

-- ---------------------------------------------------------------------
-- Q9. HIGH SALES BUT LOW PROFIT PRODUCTS
-- Rule used: revenue of at least 5,000 AND profit margin below 5%.
-- Output: rows -> product_name | revenue | profit | margin_pct | avg_discount_pct
-- ---------------------------------------------------------------------
SELECT
    product_name,
    ROUND(SUM(sales), 2)                      AS revenue,
    ROUND(SUM(profit), 2)                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(sales), 2) AS margin_pct,
    ROUND(100.0 * AVG(discount), 1)           AS avg_discount_pct  -- is heavy discounting the cause?
FROM superstore
GROUP BY product_name
HAVING SUM(sales) >= 5000                              -- HAVING filters AFTER grouping (WHERE cannot)
   AND 100.0 * SUM(profit) / SUM(sales) < 5
ORDER BY revenue DESC;

-- ---------------------------------------------------------------------
-- Q10. YEAR-OVER-YEAR GROWTH
-- Output: 4 rows -> order_year | revenue | prev_year_revenue | yoy_growth_pct | profit
-- ---------------------------------------------------------------------
WITH yearly AS (                                       -- step 1: one row per year
    SELECT order_year,
           SUM(sales)  AS revenue,
           SUM(profit) AS profit
    FROM superstore
    GROUP BY order_year
)
SELECT
    order_year,
    ROUND(revenue, 2)                                              AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY order_year), 2)              AS prev_year_revenue,  -- LAG looks one row back
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY order_year))
          / LAG(revenue) OVER (ORDER BY order_year), 2)            AS yoy_growth_pct,     -- (this - last) / last
    ROUND(profit, 2)                                               AS profit
FROM yearly
ORDER BY order_year;                                   -- first year has NULL growth: nothing to compare with
