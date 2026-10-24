-- =====================================================================
-- 02_additional_insights.sql
-- Extra queries used to answer the business questions in docs/05.
-- =====================================================================

-- I1. Top 10 products by PROFIT
SELECT product_name, ROUND(SUM(profit),2) AS profit, ROUND(SUM(sales),2) AS revenue,
       ROUND(100.0*SUM(profit)/SUM(sales),2) AS margin_pct
FROM superstore GROUP BY product_name ORDER BY profit DESC LIMIT 10;

-- I2. 10 products with the biggest LOSSES
SELECT product_name, ROUND(SUM(profit),2) AS profit, ROUND(SUM(sales),2) AS revenue,
       ROUND(100.0*AVG(discount),1) AS avg_discount_pct
FROM superstore GROUP BY product_name ORDER BY profit ASC LIMIT 10;

-- I3. Highest and lowest revenue months (top 3 and bottom 3 of 48)
SELECT order_year, order_month, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit
FROM superstore GROUP BY order_year, order_month ORDER BY revenue DESC LIMIT 3;
SELECT order_year, order_month, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit
FROM superstore GROUP BY order_year, order_month ORDER BY revenue ASC LIMIT 3;

-- I4. Seasonality: revenue by calendar month, all four years combined
SELECT order_month, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit
FROM superstore GROUP BY order_month ORDER BY order_month;

-- I5. Why is a region weak? Average discount and share of heavily discounted lines
SELECT region,
       ROUND(100.0*AVG(discount),1) AS avg_discount_pct,
       ROUND(100.0*SUM(CASE WHEN discount >= 0.3 THEN 1 ELSE 0 END)/COUNT(*),1) AS pct_lines_30pct_plus,
       ROUND(SUM(CASE WHEN discount >= 0.3 THEN profit ELSE 0 END),2) AS profit_from_30pct_plus_lines
FROM superstore GROUP BY region ORDER BY avg_discount_pct DESC;

-- I6. Weakest 8 states by profit
SELECT state, region, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit,
       ROUND(100.0*AVG(discount),1) AS avg_discount_pct
FROM superstore GROUP BY state, region ORDER BY profit ASC LIMIT 8;

-- I7. How much profit is destroyed by loss-making lines?
SELECT COUNT(*) AS loss_lines,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM superstore),1) AS pct_of_all_lines,
       ROUND(SUM(profit),2) AS total_losses
FROM superstore WHERE profit < 0;

-- I8. Tables sub-category by discount band (a known problem area)
SELECT CASE WHEN discount = 0 THEN 'No discount' WHEN discount <= 0.2 THEN 'Up to 20%' ELSE 'Over 20%' END AS band,
       COUNT(*) AS lines, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit
FROM superstore WHERE sub_category = 'Tables' GROUP BY band ORDER BY band;

-- I9. Customer segment by year (is any segment growing faster?)
SELECT segment, order_year, ROUND(SUM(sales),2) AS revenue, ROUND(SUM(profit),2) AS profit
FROM superstore GROUP BY segment, order_year ORDER BY segment, order_year;
