# 02 · SQL Analysis: results and how to run it

**Files:** `sql/00_create_table_and_load.sql` (table + loading), `sql/01_sales_analysis_queries.sql` (the 10 required analyses),
`sql/02_additional_insights.sql` (extra queries for the business answers).
Every query has comments explaining each line, and the output columns are listed above it. All were run on the cleaned data and the results below are the real output.

## How to run (beginner path)
1. Install **DB Browser for SQLite** (free) or use MySQL Workbench / PostgreSQL.
2. Run `00_create_table_and_load.sql`, then import `data/cleaned/superstore_clean.csv` into the table `superstore`.
3. Check `SELECT COUNT(*) FROM superstore;` returns **9993**.
4. Run the queries one at a time and compare with the results below.

## SQL ideas used, in simple terms
* `SUM / COUNT / AVG`: add up, count, or average rows.
* `COUNT(DISTINCT order_id)`: counts each order once even if it has many lines.
* `GROUP BY`: makes one result row per group (per month, per region...).
* `HAVING`: filters groups *after* they are built. `WHERE` filters rows *before*.
* `CASE WHEN`: an if/else that puts rows into labelled bands.
* `CTE (WITH ...)`: a named temporary result, so big queries read step by step.
* `LAG() OVER (ORDER BY ...)`: reads the value from the previous row, which is how year-over-year growth works.
* `100.0 * a / b`: the `100.0` forces decimal division. Without it, some databases return whole numbers.

## Results

**Q1 and Q2 · Headline KPIs**
| total_revenue | total_profit | profit_margin_pct | total_orders | units_sold | order_lines | avg_order_value |
|---|---|---|---|---|---|---|
| 2,296,919.49 | 286,409.08 | 12.47 | 5,009 | 37,871 | 9,993 | 458.56 |

**Q3 · Monthly trend:** 48 rows (Jan 2014 to Dec 2017), columns `order_year, order_month, revenue, profit, margin_pct`.
First rows: 2014-01 revenue 14,236.90 / profit 2,450.19. 2014-02: 4,519.89 / 862.31. 2014-03: 55,691.01 / 498.73.

**Q4 · Top 10 products by revenue**
| Product | Revenue | Profit | Margin % |
|---|---|---|---|
| Canon imageCLASS 2200 Advanced Copier | 61,599.82 | 25,199.93 | 40.91 |
| Fellowes PB500 Electric Punch Plastic Comb Binding Machine | 27,453.38 | 7,753.04 | 28.24 |
| Cisco TelePresence System EX90 Videoconferencing Unit | 22,638.48 | -1,811.08 | -8.00 |
| HON 5400 Series Task Chairs for Big and Tall | 21,870.58 | 0.00 | 0.00 |
| GBC DocuBind TL300 Electric Binding System | 19,823.48 | 2,233.51 | 11.27 |
| GBC Ibimaster 500 Manual ProClick Binding System | 19,024.50 | 760.98 | 4.00 |
| Hewlett Packard LaserJet 3310 Copier | 18,839.69 | 6,983.88 | 37.07 |
| HP Designjet T520 Inkjet Large Format Printer | 18,374.90 | 4,094.98 | 22.29 |
| GBC DocuBind P400 Electric Binding System | 17,965.07 | -1,878.17 | -10.45 |
| High Speed Automatic Electric Letter Opener | 17,030.31 | -262.00 | -1.54 |

**Q5a · Categories**
| Category | Revenue | Profit | Margin % |
|---|---|---|---|
| Technology | 836,154.03 | 145,454.95 | 17.40 |
| Office Supplies | 719,047.03 | 122,490.80 | 17.04 |
| Furniture | 741,718.42 | 18,463.33 | 2.49 |

**Q5b · Sub-categories:** most profitable are Copiers (55,617.82), Phones (44,515.73), Accessories (41,936.64), Paper (34,053.57) and Binders (30,221.76). **Loss-making:** Tables (-17,725.48), Bookcases (-3,472.56) and Supplies (-1,189.10).

**Q6a · Regions**
| Region | Orders | Revenue | Profit | Margin % |
|---|---|---|---|---|
| West | 1,611 | 725,457.82 | 108,418.45 | 14.94 |
| East | 1,401 | 678,499.87 | 91,534.84 | 13.49 |
| Central | 1,175 | 501,239.89 | 39,706.36 | 7.92 |
| South | 822 | 391,721.91 | 46,749.43 | 11.93 |

**Q6b · Top 10 cities by revenue:** New York City 256,368 (profit 62,037), Los Angeles 175,851 (30,441), Seattle 119,541 (29,156), San Francisco 112,669 (17,507), **Philadelphia 109,077 (-13,838)**, Houston 64,505 (**-10,154**), Chicago 48,540 (**-6,655**), San Diego 47,521 (6,377), Detroit 42,447 (13,182), Jacksonville 39,133 (**-2,446**).

**Q6c · Region x category:** the only loss-making combination is **Central Furniture (-2,871.05)**. Central Office Supplies is thin at 5.32% margin.

**Q7 · Customer segments**
| Segment | Customers | Orders | Revenue | Profit | Margin % | Revenue / customer |
|---|---|---|---|---|---|---|
| Consumer | 409 | 2,586 | 1,161,401.34 | 134,119.21 | 11.55 | 2,839.61 |
| Corporate | 236 | 1,514 | 706,146.37 | 91,979.13 | 13.03 | 2,992.15 |
| Home Office | 148 | 909 | 429,371.78 | 60,310.74 | 14.05 | 2,901.16 |

**Q8a · Discount impact**
| Discount band | Order lines | Revenue | Profit | Margin % |
|---|---|---|---|---|
| No discount | 4,798 | 1,087,908.47 | 320,987.60 | **29.51** |
| Up to 20% | 3,803 | 846,522.24 | 100,785.47 | 11.91 |
| 21% to 40% | 459 | 233,856.53 | -35,805.41 | **-15.31** |
| Over 40% | 933 | 128,632.25 | -99,558.59 | **-77.40** |

Q8b shows the same by exact discount level: margin turns negative from the 30% level (-10.06%) and reaches -180.03% at 80%.

**Q9 · High sales, low profit** (revenue of at least 5,000 and margin below 5%): **35 products.** The largest are Cisco TelePresence System EX90 (22,638 revenue, -8.0% margin, 50% average discount), HON 5400 Series Task Chairs (21,871, 0.0%), GBC Ibimaster 500 (19,025, 4.0%), GBC DocuBind P400 (17,965, -10.5%) and Lexmark MX611dhe Laser Printer (16,830, -27.3%).

**Q10 · Year-over-year**
| Year | Revenue | Previous year | YoY growth % | Profit |
|---|---|---|---|---|
| 2014 | 483,966.13 | n/a | n/a | 49,556.03 |
| 2015 | 470,532.51 | 483,966.13 | -2.78 | 61,618.60 |
| 2016 | 609,205.60 | 470,532.51 | +29.47 | 81,795.17 |
| 2017 | 733,215.26 | 609,205.60 | +20.36 | 93,439.27 |

> **Portability:** the `LIMIT` clause works in SQLite, MySQL and PostgreSQL. In SQL Server use `SELECT TOP 10 ...` instead.
