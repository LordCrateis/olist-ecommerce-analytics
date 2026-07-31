# Olist E-Commerce Analytics

End-to-end data analytics project on the Brazilian E-Commerce Public Dataset by Olist (~100k orders, 2016–2018). Covers database design, data cleaning, SQL-based EDA, a Python analysis notebook, and a Power BI dashboard.

## Tech Stack

- **PostgreSQL** — schema design, data cleaning, EDA queries
- **Python** (polars, sqlalchemy) — analysis notebook
- **Power BI** — interactive dashboard

## Project Structure

```
olist-ecommerce-analytics/
├── sql/
│   ├── 01_schema.sql          # Table definitions (8 tables)
│   ├── 02_data_cleaning.sql   # Encoding fix + review dedup
│   └── 03_eda_queries.sql     # 7 business-question queries
├── notebooks/
│   └── olist_ecommerce_eda.ipynb
├── power_bi/
│   └── olist_dashboard.pbix
├── requirements.txt
└── data/                      # Not tracked — see Dataset section
```

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle). Loaded into PostgreSQL across 8 tables: customers, orders, products, sellers, order items, order payments, order reviews, and product category translation. Geolocation data was intentionally excluded (not needed for this analysis).

## Data Cleaning Notes

- The raw reviews CSV is not valid UTF-8 — required `LATIN1` encoding to load.
- The reviews CSV contains 814 duplicate `review_id` values, deduplicated via a staging table and `DISTINCT ON`.

## Key Findings

| Question | Finding |
|---|---|
| Revenue trend | Steady growth 2016 → 2018, peaking around Nov 2017 (holiday season) |
| Top categories | health_beauty, watches_gifts, and bed_bath_table lead by revenue |
| Delivery performance | ~90% of orders arrive on time or early (avg 10.4 days); late orders average 31.1 days |
| Payment methods | Credit card dominates (76,795 transactions, avg 3.5 installments) |
| Repeat customers | Only 3.12% of customers are repeat buyers — growth is acquisition-driven, not retention-driven |
| Seller concentration | 9 of the top 10 sellers by revenue are based in São Paulo (SP) |
| Delivery impact on satisfaction | On-time orders average a 4.30 review score vs. 2.57 for late orders |

## Recommendations

1. **Regional fulfillment hubs** — establish distribution nodes outside the São Paulo corridor to cut delivery times in underserved states.
2. **SLA & delay mitigation** — late delivery is the single biggest driver of poor reviews; real-time shipping notifications and stricter seller SLAs would help.
3. **Retention strategy** — with a 96.88% one-time-customer rate, targeted post-purchase promotions could meaningfully improve lifetime value.

## Dashboard

The Power BI dashboard (`power_bi/olist_dashboard.pbix`) has 4 pages:
- **Overview** — KPI summary (Total Revenue, Total Orders, Avg Review Score, Repeat Customer Rate)
- **Sales & Revenue** — monthly revenue trend, top categories, top sellers
- **Operations & Delivery** — on-time vs. late delivery split, review score by delivery status
- **Customers & Payments** — repeat vs. one-time customers, payment method breakdown

## How to Reproduce

1. Load the Kaggle CSVs into `data/raw/`
2. Run `sql/01_schema.sql`, then `sql/02_data_cleaning.sql`, then load remaining tables via `\copy`
3. Run `sql/03_eda_queries.sql` for the SQL-based analysis
4. `pip install -r requirements.txt`, then open `notebooks/olist_ecommerce_eda.ipynb` for the Python analysis
5. Open `power_bi/olist_dashboard.pbix` for the interactive dashboard