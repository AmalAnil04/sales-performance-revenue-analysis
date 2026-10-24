# 03 · Power BI Dashboard: build guide

You need **Power BI Desktop** (free, Windows). All formulas are in `powerbi/measures.dax`.
Chart colours used here: indigo `#4F46E5`, violet `#9333EA`, red `#DC2626` (losses), page background `#F7F7FC`.

> I cannot create the `.pbix` file for you, so you build it by following this guide. Save it as `powerbi/Sales_Dashboard.pbix`, export a screenshot to `images/dashboard.png`, and the README will show it.

## Step 1 · Load and prepare the data
1. **Home > Get data > Text/CSV** > pick `data/cleaned/superstore_clean.csv` > **Transform Data**.
2. In Power Query set types: `order_date`, `ship_date` = **Date**; `postal_code` = **Text**; `sales`, `profit` = **Fixed decimal number**; `discount` = **Decimal number**; `quantity`, `order_year`, `order_month`, `ship_days` = **Whole number**.
3. **Close & Apply.** Rename the table to `Superstore`.

## Step 2 · Date table and relationship
1. **Modeling > New table**, paste the `Date` table code from `measures.dax`.
2. Select the `Month` column > **Column tools > Sort by column > Month Number** (so months sort Jan to Dec, not alphabetically).
3. Right-click the `Date` table > **Mark as date table** > column `Date`.
4. **Model view:** drag `Superstore[order_date]` onto `Date[Date]` (many-to-one). *Why:* time-intelligence functions like year-over-year only work with a proper date table.

## Step 3 · Create the measures and the discount band
Paste every block from `measures.dax`. Format `Total Revenue`, `Total Profit` and `Avg Order Value` as currency, and `Profit Margin %` and `YoY Revenue Growth %` as percentage (Measure tools tab).

## Step 4 · Page 1 "Overview"
Page size 16:9. Layout:
```
+--------------------------------------------------------------+
| Title + page navigator buttons        [Date] [Region]        |
|                                       [Category] [Segment]   |
+--------+--------+--------+--------+--------+-----------------+
| Revenue| Profit | Orders |  Qty   | Margin |   YoY growth    |  <- 6 KPI cards
+--------+--------+--------+--------+--------+-----------------+
| Monthly revenue trend (line)     | Revenue by category (bar) |
+----------------------------------+---------------------------+
| Top 10 products (bar)            | Regional sales (map/bar)  |
+--------------------------------------------------------------+
```
| Visual | Fields | How |
|---|---|---|
| 6 KPI **Card** visuals | `Total Revenue`, `Total Profit`, `Total Orders`, `Total Quantity`, `Profit Margin %`, `YoY Revenue Growth %` | Insert a Card, drag one measure into Fields. Repeat. |
| **Line chart**: monthly revenue trend | X: `Date[Year-Month]` (or Date hierarchy), Y: `Total Revenue` | Optionally add `Total Profit` as a second line |
| **Clustered bar**: revenue by category | Y: `category`, X: `Total Revenue` | Sort descending |
| **Bar chart**: Top 10 products | Y: `product_name`, X: `Total Revenue` | **Filters pane > product_name > Filter type: Top N > Top 10 > By value `Total Revenue` > Apply filter** |
| **Map or bar**: regional comparison | Location: `region` (or `state`), Size/X: `Total Revenue` | A bar chart is fine; set Tooltips to also show `Profit Margin %` |

## Step 5 · Page 2 "Profit & Discounts"
| Visual | Fields | How |
|---|---|---|
| **Bar**: profit by category | Y: `category`, X: `Total Profit` | Format > Visuals > Bars > Colors > fx > Field value > `Profit Colour` so losses show red |
| **Bar**: profit by sub-category | Y: `sub_category`, X: `Total Profit` | Same red/indigo colouring. Tables and Bookcases should be red |
| **Clustered column**: sales and profit by segment | X: `segment`, Y: `Total Revenue`, `Total Profit` | |
| **Column**: discount vs profitability | X: `Discount Band`, Y: `Profit Margin %` | The key chart: it should step down from 29.5% to -77.4% |
| **Scatter** (optional) | Details: `product_name`, X: `Total Revenue`, Y: `Total Profit`, Size: `Total Quantity`, Legend: `category` | Shows high-revenue, low-profit products |

## Step 6 · Interactivity
**Slicers (Insert > Slicer):**
* Date: field `Date[Date]`, style **Between**.
* Region: `region`. Category: `category`. Segment: `segment`. Style: **Tile** or **Dropdown**.
* **View > Sync slicers** to make them apply on every page.

**Drill-through (Region to detail):**
1. New page named `Region Detail`.
2. Drag `Superstore[region]` into the **Drill-through** well (Visualizations pane).
3. Add visuals: revenue by `state`, profit by `category`, and top 10 `city` by revenue.
4. Power BI adds a Back button automatically. On the Overview page, right-click a region bar > **Drill through > Region Detail**.
5. Repeat the same idea for a `Product Detail` page using `product_name`.

**Tooltip page:**
1. New page `Tooltip` > Format page > **Page size: Tooltip**; Page information > **Allow use as tooltip: On**.
2. Add a card (`Total Profit`), a card (`Profit Margin %`) and a small bar of profit by `sub_category`.
3. On the target visual: Format > General > **Tooltips > Type: Report page > Page: Tooltip**.

**Navigation buttons:** **Insert > Buttons > Navigator > Page navigator.** It builds buttons for all pages. Style with the indigo colour.

## Step 7 · Make it look professional
* Use consistent colours (above) and one font (Segoe UI), with titles on every visual.
* Align and distribute visuals (Format > Align). Leave white space.
* Rename pages and give the report a clear title: *Sales Performance & Revenue Analysis*.
* Add a short text box with 3 headline insights (see `docs/04_business_analysis.md`).

## Step 8 · Check your numbers
With **no slicers applied**, the cards should show:

| KPI | Expected |
|---|---|
| Total Revenue | $2,296,919 |
| Total Profit | $286,409 |
| Total Orders | 5,009 |
| Total Quantity | 37,871 |
| Profit Margin | 12.47% |
| Avg Order Value | $458.56 |
| YoY growth (2017 vs 2016) | +20.36% (select 2017 in a year slicer) |

If the numbers differ, check the data types in Step 1 and that you loaded `superstore_clean.csv` (9,993 rows), not the raw file.

## Step 9 · Share
* Save the `.pbix` in the repo's `powerbi/` folder and add a dashboard screenshot as `images/dashboard.png`.
* **Publish to web** makes the report public to anyone. The data is a public sample, but still read Power BI's warning before using it.
