# Sales Performance & Revenue Analysis Dashboard

An end-to-end analysis of a retail sales dataset using **Excel, SQL and Power BI**: data cleaning, KPI queries, an interactive dashboard and business recommendations.

**Author:** Amal Anil · [GitHub](https://github.com/AmalAnil04) · [LinkedIn](https://www.linkedin.com/in/amal-anil-8a1183267)

## Objective
Turn raw sales data into insights about revenue, profit, products, regions, customers and discounts, and recommend actions to grow profit.

## Dataset
[Superstore Dataset (Final)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) on Kaggle: 9,994 order lines, 21 columns, 2014 to 2017, United States. It is a public **sample dataset** for practice, not a real company's data. Check the licence on Kaggle before reuse. Full column guide: [`docs/00_dataset_guide.md`](docs/00_dataset_guide.md).

## Tools
| Tool | Used for |
|---|---|
| Excel | Cleaning, validation, outlier checks ([guide](docs/01_excel_data_cleaning.md)) |
| SQL | KPIs and analysis, 10 required queries plus extras ([results](docs/02_sql_walkthrough.md)) |
| Power BI | Interactive dashboard and DAX ([build guide](docs/03_powerbi_dashboard_guide.md)) |
| Python (optional) | `scripts/clean_data.py` repeats the cleaning steps |

## Key numbers
| Revenue | Profit | Margin | Orders | Units sold | Avg order value |
|---|---|---|---|---|---|
| $2,296,919 | $286,409 | 12.47% | 5,009 | 37,871 | $458.56 |

Year-over-year revenue growth: 2015 -2.8%, 2016 +29.5%, 2017 +20.4%. Currency is assumed to be USD (not stated in the data).

## Key findings
1. **Discounts above 20% destroy profit.** Margin is 29.5% with no discount, 11.9% up to 20%, -15.3% for 21% to 40%, and -77.4% above 40%.
2. **Furniture is the profit gap.** It is 32% of revenue but only 2.5% margin. Tables (-$17.7K) and Bookcases (-$3.5K) lose money.
3. **Central is the weakest region** (7.9% margin), driven by Texas and Illinois and an average discount of 24%.
4. **Technology and Office Supplies earn 94% of profit.** Copiers, Phones, Accessories and Paper lead.
5. **September to December brings 51.6% of revenue.** February is the weakest month.
6. **Corporate and Home Office are growing faster** (+88% and +78% since 2014) than Consumer (+25%).

Full analysis and recommendations: [`docs/04_business_analysis.md`](docs/04_business_analysis.md).

## Charts
The charts below were drawn with Python from the cleaned data to cross-check the numbers. They are not Power BI screenshots.

![Monthly trend](images/monthly_trend.png)
![Category](images/category.png)
![Region](images/region.png)
![Discount](images/discount_margin.png)

## Dashboard preview (web replica)
An interactive HTML replica of the dashboard, built from the cleaned data: [`preview/dashboard_preview.html`](preview/dashboard_preview.html).
GitHub shows HTML files as code, so to view it live enable **Settings → Pages → Deploy from a branch → main / (root)** and open
`https://AmalAnil04.github.io/<repo-name>/preview/dashboard_preview.html`. This is a preview, not a Power BI file.

## Power BI dashboard
> **TODO (add your screenshot):** build the dashboard with the [guide](docs/03_powerbi_dashboard_guide.md), save it to `powerbi/Sales_Dashboard.pbix` and add a screenshot as `images/dashboard.png`, then replace this note with `![Dashboard](images/dashboard.png)`.
DAX measures are in [`powerbi/measures.dax`](powerbi/measures.dax).

## Repository structure
```
├── README.md
├── data/
│   ├── raw/Sample - Superstore.csv      original file (untouched)
│   └── cleaned/superstore_clean.csv     9,993 rows, 24 columns (+ cleaning_log.txt)
├── scripts/clean_data.py
├── sql/                                 00 create+load, 01 analysis, 02 extra insights
├── powerbi/measures.dax                 add your .pbix here
├── preview/dashboard_preview.html       interactive web preview of the dashboard
├── docs/                                dataset, Excel, SQL, Power BI, business analysis
└── images/
```

## How to reproduce
1. `python scripts/clean_data.py` (needs `pandas`), or follow the Excel guide by hand.
2. Load `data/cleaned/superstore_clean.csv` into a SQL database using `sql/00_create_table_and_load.sql`, then run `sql/01_...` and `sql/02_...`.
3. Build the dashboard from the Power BI guide.

## Limitations
Sample data, no cost fields, discount effects are associations rather than proven causes, and 32 product IDs map to more than one product name (grouped by name).
