"""
Cleans the Superstore dataset. Mirrors the Excel steps in docs/01_excel_data_cleaning.md.
Run:  python scripts/clean_data.py
Input : data/raw/Sample - Superstore.csv   (original, untouched)
Output: data/cleaned/superstore_clean.csv  + data/cleaned/cleaning_log.txt
"""
import pandas as pd

RAW = "data/raw/Sample - Superstore.csv"
OUT = "data/cleaned/superstore_clean.csv"
LOG = "data/cleaned/cleaning_log.txt"
log = []

df = pd.read_csv(RAW, encoding="latin1")           # file is not UTF-8
log.append(f"Rows loaded: {len(df)} | Columns: {df.shape[1]}")

# 1. Missing values ---------------------------------------------------------
log.append(f"Missing cells: {int(df.isna().sum().sum())}")

# 2. Text hygiene: trim edges and collapse double spaces (Excel: TRIM) -------
for c in df.select_dtypes(include=["object", "string"]).columns:
    before = df[c].copy()
    df[c] = df[c].str.strip().str.replace(r"\s+", " ", regex=True)
    changed = int((before != df[c]).sum())
    if changed:
        log.append(f"Text fixed in '{c}': {changed} cells (extra spaces)")

# 3. Dates -> real dates (source format is M/D/YYYY text) --------------------
df["Order Date"] = pd.to_datetime(df["Order Date"], format="%m/%d/%Y")
df["Ship Date"] = pd.to_datetime(df["Ship Date"], format="%m/%d/%Y")
log.append(f"Order dates: {df['Order Date'].min().date()} to {df['Order Date'].max().date()}")
log.append(f"Rows where Ship Date < Order Date: {int((df['Ship Date'] < df['Order Date']).sum())}")

# 4. Postal codes are text; leading zeros were lost in the source ------------
short = int((df["Postal Code"] < 10000).sum())
df["Postal Code"] = df["Postal Code"].astype(str).str.zfill(5)
log.append(f"Postal codes padded back to 5 digits: {short} rows (CT, MA, ME, NH, NJ, RI, VT)")

# 5. Invalid values (checked, NOT removed) -----------------------------------
log.append(f"Sales <= 0: {int((df['Sales'] <= 0).sum())} | Quantity <= 0: {int((df['Quantity'] <= 0).sum())} "
           f"| Discount outside 0-1: {int(((df['Discount'] < 0) | (df['Discount'] > 1)).sum())}")
log.append(f"Negative Profit rows (genuine losses, kept): {int((df['Profit'] < 0).sum())}")

# 6. Duplicates: identical in everything except Row ID -----------------------
key = [c for c in df.columns if c != "Row ID"]
dups = int(df.duplicated(key).sum())
df = df.drop_duplicates(key, keep="first")
log.append(f"Duplicate rows removed (all fields identical except Row ID): {dups}")

# 7. Derived columns (calculated by us, NOT in the source) -------------------
df["order_year"] = df["Order Date"].dt.year
df["order_month"] = df["Order Date"].dt.month
df["ship_days"] = (df["Ship Date"] - df["Order Date"]).dt.days

# 8. SQL-friendly names ------------------------------------------------------
df.columns = [c.lower().replace("-", "_").replace(" ", "_") for c in df.columns]
df["order_date"] = df["order_date"].dt.strftime("%Y-%m-%d")
df["ship_date"] = df["ship_date"].dt.strftime("%Y-%m-%d")
df.to_csv(OUT, index=False)
log.append(f"Final rows: {len(df)} | Final columns: {df.shape[1]} -> {OUT}")
open(LOG, "w").write("\n".join(log) + "\n")
print("\n".join(log))
