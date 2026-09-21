-- ============================================================
-- Dubai Real Estate Market Analysis — SQL Analysis Queries
-- Database: SQLite (dubai_real_estate.db)
-- Tables: fact_listings, dim_community, dim_metro, dim_date,
--         area_prices_monthly
-- ============================================================


-- ------------------------------------------------------------
-- 1. Top communities by price per sqft, ranked within each
--    listing type (off-plan, rental, secondary sale)
--    Uses a window function (RANK) + CTE to filter post-rank.
-- ------------------------------------------------------------
WITH ranked AS (
    SELECT
        community,
        listing_type,
        ROUND(AVG(price_per_sqft_usd), 0) AS avg_price_per_sqft,
        COUNT(*) AS n_listings,
        RANK() OVER (
            PARTITION BY listing_type
            ORDER BY AVG(price_per_sqft_usd) DESC
        ) AS price_rank
    FROM fact_listings
    GROUP BY community, listing_type
    HAVING COUNT(*) >= 20   -- exclude communities with too few listings to be meaningful
)
SELECT *
FROM ranked
WHERE price_rank <= 10
ORDER BY listing_type, price_rank;


-- ------------------------------------------------------------
-- 2. Price by metro-proximity band (all communities)
--    Uses a CASE statement to bucket metro_distance_min.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN metro_distance_min <= 5  THEN '0-5 min'
        WHEN metro_distance_min <= 10 THEN '6-10 min'
        WHEN metro_distance_min <= 15 THEN '11-15 min'
        WHEN metro_distance_min <= 20 THEN '16-20 min'
        ELSE '20+ min'
    END AS metro_proximity,
    listing_type,
    ROUND(AVG(price_per_sqft_usd), 0) AS avg_price_per_sqft,
    COUNT(*) AS n_listings
FROM fact_listings
GROUP BY metro_proximity, listing_type
ORDER BY listing_type,
    CASE metro_proximity
        WHEN '0-5 min'   THEN 1
        WHEN '6-10 min'  THEN 2
        WHEN '11-15 min' THEN 3
        WHEN '16-20 min' THEN 4
        ELSE 5
    END;


-- ------------------------------------------------------------
-- 3. Same proximity-band query, excluding six geographically
--    isolated ultra-luxury communities — controls for the
--    confound where luxury islands/villas skew "20+ min" high.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN metro_distance_min <= 5  THEN '0-5 min'
        WHEN metro_distance_min <= 10 THEN '6-10 min'
        WHEN metro_distance_min <= 15 THEN '11-15 min'
        WHEN metro_distance_min <= 20 THEN '16-20 min'
        ELSE '20+ min'
    END AS metro_proximity,
    listing_type,
    ROUND(AVG(price_per_sqft_usd), 0) AS avg_price_per_sqft,
    COUNT(*) AS n_listings
FROM fact_listings
WHERE community NOT IN (
    'Bulgari Resort', 'Palm Jumeirah', 'Emirates Hills',
    'World Islands', 'Jumeirah Bay Island', 'Pearl Jumeira'
)
GROUP BY metro_proximity, listing_type
ORDER BY listing_type,
    CASE metro_proximity
        WHEN '0-5 min'   THEN 1
        WHEN '6-10 min'  THEN 2
        WHEN '11-15 min' THEN 3
        WHEN '16-20 min' THEN 4
        ELSE 5
    END;


-- ------------------------------------------------------------
-- 4. Monthly price trend vs. mortgage rate (2020-2026)
--    Basis for the price-vs-mortgage-rate decoupling finding.
-- ------------------------------------------------------------
SELECT
    year_month,
    ROUND(AVG(secondary_price_per_sqft_usd), 0)        AS avg_secondary_price,
    ROUND(AVG(offplan_price_per_sqft_usd), 0)           AS avg_offplan_price,
    ROUND(AVG(rental_price_per_sqft_annual_usd), 0)     AS avg_rental_price,
    ROUND(AVG(avg_mortgage_rate_pct), 2)                AS avg_mortgage_rate
FROM area_prices_monthly
GROUP BY year_month
ORDER BY year_month;


-- ------------------------------------------------------------
-- 5. Data-quality check: confirm floor/total_floors nulls are
--    structural (villas), not missing/messy data.
-- ------------------------------------------------------------
SELECT property_type, COUNT(*) AS n
FROM secondary_sales
WHERE floor IS NULL
GROUP BY property_type;

SELECT property_type, COUNT(*) AS n
FROM secondary_sales
WHERE floor IS NOT NULL
GROUP BY property_type;


-- ------------------------------------------------------------
-- 6. Community/zone name consistency check — look for
--    near-duplicate spellings or whitespace issues.
-- ------------------------------------------------------------
SELECT DISTINCT community FROM fact_listings ORDER BY community;

SELECT DISTINCT zone FROM fact_listings ORDER BY zone;

SELECT COUNT(*) AS rows_with_whitespace_issue
FROM fact_listings
WHERE TRIM(community) != community;
