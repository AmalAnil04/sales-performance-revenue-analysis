# 01 · Excel Data Cleaning (step by step)

Goal: turn `data/raw/Sample - Superstore.csv` into a clean file for SQL and Power BI.
`scripts/clean_data.py` does the same steps, and the numbers below are what it found, so you can check your Excel results against them.

**Golden rule:** never edit the original. Work on a copy and keep the raw file untouched.

## Step 0 · Open the file correctly
1. Excel > **Data > From Text/CSV**, choose the file.
2. Set **File Origin** to `1252: Western European (Windows)`. The file is not UTF-8, and the wrong setting shows strange characters.
3. Click **Load**. Press **Ctrl+T** to make it a Table and name it `tblSales` (Table Design tab).

## Step 1 · Duplicates
Two rows can be "the same order line" even when Row ID differs, so compare everything *except* Row ID.

Add a helper column `DupCheck`:
```excel
=COUNTIFS([Order ID],[@[Order ID]],[Product ID],[@[Product ID]],[Sales],[@Sales],
          [Quantity],[@Quantity],[Discount],[@Discount],[Profit],[@Profit])
```
*Why:* COUNTIFS counts how many rows share the same values. Any value above 1 is a duplicate candidate.
**Expected:** 2 rows show `2` (Row IDs 3406 and 3407).

Remove: **Data > Remove Duplicates**, untick **Row ID** and `DupCheck`, tick everything else.
**Expected:** "1 duplicate value found and removed; 9,993 unique values remain."

## Step 2 · Missing values
```excel
=COUNTBLANK(tblSales[#Data])
```
*Why:* a blank sales or date cell would silently break totals.
**Expected:** 0. (Also try Home > Find & Select > Go To Special > Blanks.) This dataset has no gaps, so just document that you checked.

## Step 3 · Inconsistent text
Count cells with extra spaces in Product Name:
```excel
=SUMPRODUCT(--(LEN(tblSales[Product Name])<>LEN(TRIM(tblSales[Product Name]))))
```
*Why:* `"Staples  Paper"` and `"Staples Paper"` look the same but group as two products.
**Expected:** 273. Fix with a helper column `=TRIM(CLEAN([@[Product Name]]))`, then copy and **Paste Special > Values** over the original column and delete the helper.
`TRIM` removes extra spaces; `CLEAN` removes hidden non-printing characters.

Check category fields: `=UNIQUE(tblSales[Region])` (Excel 365) or a PivotTable.
**Expected:** 4 regions, 3 segments, 3 categories, 17 sub-categories, no spelling variants.

## Step 4 · Dates
In this file dates are **text** like `11/8/2016` in US order (month/day/year). Excel with a UK/India region setting may read `11/8` as 11 August, which would be wrong.

Safest way: select the date columns > **Data > Get & Transform (Power Query)** > Change Type > **Using Locale** > Date, locale **English (United States)**.
Formula alternative for `Order Date` in C2:
```excel
=DATE(RIGHT(C2,4), LEFT(C2,FIND("/",C2)-1), MID(C2,FIND("/",C2)+1,FIND("/",C2,FIND("/",C2)+1)-FIND("/",C2)-1))
```
Check: `=COUNT(tblSales[Order Date])` must equal the row count (9,993), because COUNT only counts real numbers or dates.
Add `ship_days`: `=[@[Ship Date]]-[@[Order Date]]`. **Expected:** between 0 and 7, never negative. Then format both date columns as `yyyy-mm-dd`.

## Step 5 · Number formats
* Sales and Profit: Number, 2 decimals (display only; the stored value is unchanged).
* Discount: keep as 0.2 (not 20) so formulas stay simple. Showing it as % is only formatting.
* Quantity: whole number.
* **Postal Code: Text.** Rebuild lost zeros with `=TEXT([@[Postal Code]],"00000")`. **Expected:** 449 codes get a leading zero (CT, MA, ME, NH, NJ, RI, VT).

## Step 6 · Negative and invalid values
```excel
=COUNTIF(tblSales[Sales],"<=0")                                    → 0
=COUNTIF(tblSales[Quantity],"<=0")                                 → 0
=COUNTIFS(tblSales[Discount],"<0")+COUNTIFS(tblSales[Discount],">1") → 0
=COUNTIF(tblSales[Profit],"<0")                                    → 1,870 (1,871 before removing the duplicate)
```
*Why:* sales, quantity and discount must be sensible. **Negative profit is not an error.** It is a loss-making sale, which is exactly what the analysis wants to find, so **do not delete it.**

## Step 7 · Outliers (IQR method)
```excel
Q1    =QUARTILE.INC(tblSales[Sales],1)
Q3    =QUARTILE.INC(tblSales[Sales],3)
IQR   =Q3-Q1
Low   =Q1-1.5*IQR
High  =Q3+1.5*IQR
Flag  =IF(OR([@Sales]<Low,[@Sales]>High),"Outlier","")
```
Repeat for Profit. **Expected on the raw data:** 1,167 Sales outliers and 1,881 Profit outliers.
**Decision: keep them.** The biggest sale (22,638.48) is a real, plausible row (6 units of a Cisco TelePresence system), so these are big-ticket items, not typing errors. Removing them would delete your best customers. In your notes, write *"outliers identified, verified as genuine, retained."*

## Step 8 · Validate
Make a PivotTable (Sum of Sales, Sum of Profit) and compare:

| | Raw file | After cleaning |
|---|---|---|
| Rows | 9,994 | 9,993 |
| Sum of Sales | 2,297,200.86 | **2,296,919.49** |
| Sum of Profit | 286,397.02 | **286,409.08** |

The change is exactly the one removed duplicate (sales 281.37, profit -12.06).

## Step 9 · Prepare for SQL and Power BI
1. Add `order_year` (`=YEAR([@[Order Date]])`), `order_month` (`=MONTH(...)`) and `ship_days`.
2. Rename headers to lowercase with underscores (`Order ID` → `order_id`, `Sub-Category` → `sub_category`).
3. **File > Save As > CSV UTF-8 (Comma delimited)** as `superstore_clean.csv`.

Your result should match `data/cleaned/superstore_clean.csv`: 9,993 rows and 24 columns.
