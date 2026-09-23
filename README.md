# Dubai Real Estate Market Analysis (2020–2026)

An end-to-end data analytics project examining ~87,000 Dubai property listings — secondary sales, rentals, and off-plan developments — to uncover pricing trends, investment opportunities, and the real drivers behind Dubai's real estate market.

**Tools used:** Python (Pandas) · SQL (SQLite) · Power BI · DAX

---

## 📊 Project Overview

Dubai's real estate market attracts global investors, but public analysis is often surface-level — a single price chart, no context, no investment framing. This project goes deeper: cleaning and modeling raw transaction data into a proper star schema, validating findings across both SQL and Power BI, and closing with an investor-focused summary that answers the question every buyer actually asks — *where should I put my money?*

**Dataset:** [Dubai Real Estate: Sales & Rentals (2020–2026)](https://www.kaggle.com/datasets/sergionefedov/dubai-real-estate-sales-and-rentals-20202026) — 87,000+ listings across secondary sales, rentals, and off-plan developments, plus monthly area price indices and Dubai Metro station data.

---

## 🧱 Data Architecture

Raw data arrived as five separate CSVs. Rather than working off flat files, I designed a **star schema**:

- **`fact_listings`** — 87,000 rows: secondary sales (50K), rentals (25K), off-plan (12K) unified into one fact table with a `listing_type` column
- **`dim_community`** — 84 Dubai communities with zone mapping
- **`dim_metro`** — 55 metro stations with coordinates and distance-to-Burj-Khalifa
- **`dim_date`** — date dimension for time-based analysis
- **`area_prices_monthly`** — pre-aggregated monthly price index with mortgage rate context (2020–2026)

Data was cleaned and modeled in Python, loaded into a SQLite database for SQL analysis, then imported into Power BI where the relationships were rebuilt as a proper star schema for DAX time-intelligence and cross-table measures.

**A note on missing data:** ~17,800 rows had null `floor`/`total_floors` values. Rather than assume this was messy data, I verified it — 100% of those nulls corresponded to villas, which structurally don't have floor numbers. They were left as-is rather than imputed, since filling them would have introduced false precision.

---

## 🔍 Key Findings

**1. Luxury pricing is consistent across every transaction type.**
Bulgari Resort ranks #1 in price/sqft across off-plan, rental, *and* resale — a durable luxury premium regardless of how the property is transacted.

**2. Off-plan activity signals market maturity.**
Jumeirah Bay Island ranks top-3 for rental and resale price but is absent from the off-plan top 10 — the island is fully built out, with essentially no new development land remaining.

**3. Metro proximity is a weak, confounded price driver.**
An initial pass suggested distant listings (20+ min from metro) were pricier — but this was a confound: Dubai's ultra-luxury island and villa communities are geographically isolated from metro lines. After excluding them, no clean "closer = pricier" relationship emerged. **Community identity and amenities outweigh transit access** in this market — validated with an interactive luxury-toggle filter in the dashboard.

**4. Price growth decoupled from mortgage rates (2020–2023).**
Secondary market prices rose ~82% even as mortgage rates climbed from ~2% to ~6.9% — likely driven by cash and foreign-investor demand rather than local financing costs. From 2024–2026, prices plateaued *even as rates eased*, suggesting the recent slowdown reflects market saturation, not rate sensitivity.

**5. The best rental yields come from affordable family communities — not prestige addresses.**
Sustainable City, Dubai South, and Damac Hills 2 deliver 9%+ rental yields, while Bulgari Resort (the priciest community by far) yields just 7.64%. **Buying for capital value and buying for rental income point to different neighborhoods entirely.**

---

## 📈 Dashboard Pages

**1. Market Overview** — KPIs, YoY price growth trend, top 10 priciest communities, and two geographic maps (metro stations + price-by-community bubble map).

**2. Market Segments** — Market composition by listing type, off-plan vs. resale pricing by property type, rental pricing by unit size, and top 15 communities by rental yield.

**3. Metro & Location Insights** — Price by metro-proximity band, average price by metro line, a community-level scatter plot, and an **interactive slicer** that toggles luxury-isolated communities on/off — letting the confounding effect appear and disappear live.

**4. Investor Summary** — A "sweet spot" scatter (price vs. rental yield), a ranked community comparison table, and a plain-English executive summary tying every finding into an investment narrative.

---

## 🖼️ Screenshots
<img width="871" height="555" alt="Screenshot 2026-09-21 202446" src="https://github.com/user-attachments/assets/8a0ee287-cb2d-488f-ba1f-e52961131e66" />
<img width="861" height="533" alt="Screenshot 2026-09-21 202545" src="https://github.com/user-attachments/assets/e89a9b59-8575-4e85-9a24-d4b6bf638f61" />
<img width="862" height="527" alt="Screenshot 2026-09-21 202659" src="https://github.com/user-attachments/assets/88936070-9e09-4895-995d-57d94f8fdf5a" />
<img width="858" height="539" alt="Screenshot 2026-09-21 202811" src="https://github.com/user-attachments/assets/f17541a8-457a-4041-9fc8-c067db3092fd" />

---

## 🛠️ Methodology

1. **Data cleaning (Python/Pandas)** — loaded 5 raw CSVs, verified null patterns, unified sales/rentals/off-plan into one fact table, checked 84 community names for inconsistencies (none found)
2. **SQL analysis (SQLite)** — window functions (`RANK() OVER`) for community price ranking, CTEs for filtered ranking queries, `CASE` statements for proximity banding
3. **Power BI modeling** — star schema with 5 relationships, 6+ DAX measures including time-intelligence (`DATEADD`) and cross-filtered ratios (rental yield = avg rental price ÷ avg sale price)
4. **Validation** — every major finding was checked in both SQL and Power BI independently before being included

---

## 📁 Repository Structure

```
├── data/
│   ├── raw/                    # Original Kaggle CSVs
│   └── processed/              # Cleaned fact + dimension tables
├── notebooks/
│   └── dubai_real_estate.ipynb # Cleaning, star schema construction, matplotlib validation
├── sql/
│   └── analysis_queries.sql    # All SQL queries used for validation
├── dashboard/
│   └── Dubai_Real_Estate_Analysis.pbix
├── findings.md                 # Full findings log with methodology notes
└── README.md


---

## 👤 About

Built by **Sufiyan** — MCA student and aspiring data analyst based in Chennai, currently open to data analyst roles and relocation to Dubai.

- GitHub: [sufsaura](https://github.com/sufsaura)
- LinkedIn: [abu-sufiyan-8a233](https://linkedin.com/in/abu-sufiyan0521)
