# 04 · Business Analysis: findings and recommendations

All figures come from `data/cleaned/superstore_clean.csv` (9,993 order lines, 5,009 orders, 2014 to 2017) via the SQL files. Currency is assumed to be USD (it is not stated in the data).

## Summary
Revenue is **$2.30M** with **$286K profit (12.5% margin)**, and growth is healthy: revenue rose 29.5% in 2016 and 20.4% in 2017. Profit growth is held back by **heavy discounting and a weak Furniture category**, not by a lack of demand.

## 1. Which products generate the most revenue?
The top five by revenue: Canon imageCLASS 2200 Advanced Copier ($61,600), Fellowes PB500 Binding Machine ($27,453), Cisco TelePresence System EX90 ($22,638), HON 5400 Series Task Chairs ($21,871) and GBC DocuBind TL300 ($19,823).
The top 10 together are only **10.6% of revenue**, so sales are spread widely and the business does not depend on a few products.
**But revenue is not profit:** of the top 10, Cisco TelePresence (-$1,811), GBC DocuBind P400 (-$1,878) and the Letter Opener (-$262) lose money, and the HON chairs break even at $0.

## 2. Which products and categories generate the highest profit?
* **Technology** earns $145,455 (50.8% of profit, 17.4% margin) and **Office Supplies** earns $122,491 (42.8%, 17.0%). **Furniture** earns only $18,463 (6.4% of profit) with a **2.5% margin**, even though it has more revenue than Office Supplies.
* Best sub-categories: Copiers $55,618 (37.2% margin), Phones $44,516, Accessories $41,937, Paper $34,054 (43.4% margin) and Binders $30,222.
* Top profit products: Canon imageCLASS 2200 Copier ($25,200), Fellowes PB500 ($7,753) and HP LaserJet 3310 Copier ($6,984).
* **Loss-making sub-categories: Tables (-$17,725), Bookcases (-$3,473) and Supplies (-$1,189).**

## 3. Which regions are performing poorly?
| Region | Revenue | Profit | Margin |
|---|---|---|---|
| West | $725,458 | $108,418 | 14.9% |
| East | $678,500 | $91,535 | 13.5% |
| South | $391,722 | $46,749 | 11.9% |
| **Central** | $501,240 | **$39,706** | **7.9%** |

**Central is the weakest on profit.** It has the third-highest revenue but the lowest margin and the lowest profit, and **Central Furniture loses money (-$2,871)**. Its average discount is 24.0% (West is 10.9%), and 27.7% of Central's order lines carry a 30%+ discount; those lines lost $52,392 in total.
By state, the biggest losses are **Texas (-$25,729)**, Ohio (-$16,959), Pennsylvania (-$15,560) and **Illinois (-$12,608)**. Texas and Illinois both sit in Central and both average 37% to 39% discounts.
By city, **Philadelphia, Houston, Chicago and Jacksonville are all in the top 10 by revenue but lose money.** South is the smallest region by revenue but its margin (11.9%) is decent, so it is a growth opportunity rather than a problem.

## 4. Which months have the highest and lowest sales?
* **Highest:** November 2017 ($118,448), December 2016 ($96,999) and September 2017 ($87,867).
* **Lowest:** February 2014 ($4,520), February 2015 ($11,951) and January 2014 ($14,237).
* Combining all years, **November ($352K), December ($325K) and September ($308K)** are the strongest calendar months, and **February ($60K) is the weakest**. September to December brings in **51.6% of yearly revenue.**

## 5. Are discounts associated with lower profit margins? Yes, strongly.
| Discount | Order lines | Margin |
|---|---|---|
| None | 4,798 | **29.5%** |
| Up to 20% | 3,803 | 11.9% |
| 21% to 40% | 459 | **-15.3%** |
| Over 40% | 933 | **-77.4%** |

Lines discounted above 20% are **13.9% of order lines and 15.8% of revenue ($362K), but together they lost $135,364.** As simple arithmetic (not a forecast), the profit total without those lines would be about $421,773 instead of $286,409. Some of those sales may not have happened without the discount, so the true effect is smaller.
Example: Tables sold with no discount earned +$13,276, while Tables discounted over 20% lost $30,698.
*This shows association, not proof of cause: product mix also differs between discount levels.*

## 6. Which customer segments are most valuable?
| Segment | Revenue | Profit | Margin | Revenue per customer | Revenue growth 2014 to 2017 |
|---|---|---|---|---|---|
| Consumer | $1,161,401 (51%) | $134,119 | 11.6% | $2,840 | +24.7% |
| Corporate | $706,146 | $91,979 | 13.0% | **$2,992** | **+88.3%** |
| Home Office | $429,372 | $60,311 | **14.1%** | $2,901 | +78.3% |

**Consumer is the biggest by volume but has the lowest margin.** Corporate has the highest spend per customer and the fastest revenue growth, but its profit fell in 2017 ($30,995 to $26,782) even as revenue rose, which is worth a closer look. Home Office has the best margin.

## 7. Recommendations
1. **Set a discount policy.** Require approval above 20% and review everything above 30%. Discounts above 20% are linked to losses on every level tested.
2. **Fix Furniture pricing.** Review Tables and Bookcases (their margins are negative) and renegotiate supplier costs or raise prices on the loss-making items.
3. **Target the Central region** (Texas and Illinois first) with lower discounts and a margin review.
4. **Review the 35 high-sales, low-profit products** (Query Q9), starting with Cubify CubeX 3D printers, the Lexmark MX611dhe printer and the Cisco TelePresence unit.
5. **Plan inventory and marketing for September to December**, and test promotions for the weak February period.
6. **Grow Corporate and Home Office accounts**, since they are growing fastest and are more profitable than Consumer. Investigate why Corporate profit fell in 2017.
7. **Push the high-margin lines:** Copiers, Accessories and Paper.

## Limitations (say these in interviews)
* This is a sample dataset, so findings are practice insights, not a real company's results.
* The data has no cost, marketing or inventory fields, so profit is taken as given.
* Discount effects are associations. Testing causes would need a controlled comparison.
* Four years of history is enough for trends, but not for reliable forecasting.
* 32 Product IDs link to more than one name; products are grouped by name.

## Resume / LinkedIn bullets (all backed by the numbers above)
* Cleaned and analyzed 9,993 retail order lines (about $2.3M revenue) using Excel, SQL and Power BI, and built an interactive dashboard of 6 KPIs.
* Found that order lines discounted above 20% (13.9% of lines) generated a combined loss of about $135K, and recommended a discount-approval policy.
* Identified Furniture (2.5% margin) and the Central region (7.9% margin) as the main profit gaps, and pinpointed loss-making sub-categories (Tables, Bookcases, Supplies).
