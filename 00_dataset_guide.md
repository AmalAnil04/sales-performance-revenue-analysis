# 00 · Dataset Guide

## Where the data comes from
**Superstore Dataset (Final)**, a free retail sales sample on Kaggle:
<https://www.kaggle.com/datasets/vivek468/superstore-dataset-final> (file: `Sample - Superstore.csv`).

The copy in `data/raw/` was downloaded from a public GitHub mirror of that file
(`Ayon-coder/FUTURE_ML_01`). It has 9,994 rows and 21 columns, matching the Kaggle description.
**Check the licence on the Kaggle page** before you reuse or republish the data.

> This is a **practice/sample dataset** used widely for BI training. It is not data from a real, named company, so write "retail sales dataset" in your resume, not "company data".

## What is in it
| Item | Value |
|---|---|
| Time span | 3 Jan 2014 to 30 Dec 2017 (4 years) |
| Orders / customers | 5,009 orders / 793 customers |
| Products | 1,850 product names (1,862 product IDs) |
| Geography | United States only: 4 regions, 49 states, 531 cities |
| Currency | **Not stated in the file.** US locations suggest USD, so this project formats values as `$`. That is an assumption. |

## The 21 source columns
| Column | Plain-English meaning |
|---|---|
| Row ID | Unique row number (one row = one product line in an order) |
| Order ID | Order reference, e.g. `CA-2016-152156`. One order can have several rows |
| Order Date / Ship Date | When the order was placed / shipped (text in `M/D/YYYY` format in the raw file) |
| Ship Mode | Standard Class, Second Class, First Class, Same Day |
| Customer ID / Customer Name | Who bought |
| Segment | **Customer segment**: Consumer, Corporate, Home Office |
| Country / State / City / Postal Code | Delivery location |
| Region | Central, East, South, West |
| Product ID | Product reference |
| Category / Sub-Category | 3 categories, 17 sub-categories |
| Product Name | Name of the item |
| Sales | **Revenue** of the row |
| Quantity | Units sold |
| Discount | Discount as a fraction (0.20 = 20%) |
| Profit | Profit after costs. **Negative = the row lost money** |

All 11 fields you asked for (Order ID, Order Date, Product Name, Category, Sales, Quantity, Profit, Region, City, Segment, Discount) exist, so nothing had to be invented.

## Columns this project calculates (not in the source)
| Column | How it is built | Why |
|---|---|---|
| `order_year` | year of `order_date` | easy yearly SQL grouping |
| `order_month` | month number of `order_date` | easy monthly SQL grouping |
| `ship_days` | `ship_date - order_date` | delivery speed check |

Anything else (profit margin, average order value, growth) is calculated in SQL or DAX when needed. **Cost is not in the data.** `Sales - Profit` would be an implied cost, so it is never presented as a source field.

## Known data-quality notes
* 1 duplicated row (rows 3406 and 3407, order `US-2014-150119`, identical apart from Row ID) was removed.
* 273 product names had extra spaces; they were trimmed.
* 449 postal codes had lost their leading zero (e.g. `6010` instead of `06010`) and were restored to 5 digits.
* **32 Product IDs are linked to more than one product name** (16 product names appear under more than one ID). Because of this, products are grouped by **Product Name** in this project. This is a real inconsistency in the source and was left as it is.
* 1,871 rows in the raw file have negative profit. These are genuine losses, not errors, so they were kept.
