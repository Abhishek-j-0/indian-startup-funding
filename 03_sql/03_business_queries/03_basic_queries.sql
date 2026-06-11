-- =========================================================================
-- 🎯 PROJECT     : Indian Startup Funding Analysis (Business Exploration Phase)
-- 🧑‍💻 AUTHOR      : Abishek J
-- 📅 DATE        : May 2026
-- =========================================================================
-- 🚀 OBJECTIVE:
--    - Answering real business questions using analytical SQL queries.
--    - Extracting high-value data insights on top startups, cities, & trends.
--
-- 📑 SOURCE TABLE: startup_funding_clean (Post-ETL & Standardized Dataset)
-- =========================================================================

-- Top Performers Analysis
-- Query 1: Top 10 startups by total funding
USE startup_funding_db;

SELECT 
    startup_name,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    COUNT(*) AS funding_rounds
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY startup_name
ORDER BY total_funding_cr DESC
LIMIT 10;

-- Query 2: Top 10 cities by total funding
SELECT 
    city_clean,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY city_clean
ORDER BY total_funding_cr DESC
LIMIT 10;

-- Query 3: Top 10 industries
SELECT 
    industry_category,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY industry_category
ORDER BY total_funding_cr DESC;

-- Time-Based Analysis
-- Query 4: Yearly funding trend
SELECT 
    funding_year,
    COUNT(*) AS deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size
FROM startup_funding_clean
WHERE funding_year IS NOT NULL
GROUP BY funding_year
ORDER BY funding_year;

-- Query 5: Quarterly trends
SELECT 
    funding_year,
    funding_quarter,
    COUNT(*) AS deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
WHERE funding_year IS NOT NULL
GROUP BY funding_year, funding_quarter
ORDER BY funding_year, funding_quarter;

-- Investor Analysis
-- Query 6: Top 15 lead investors
SELECT 
    primary_investor,
    COUNT(*) AS deals_led,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
WHERE primary_investor != 'Undisclosed'
GROUP BY primary_investor
ORDER BY deals_led DESC
LIMIT 15;

-- Query 7: Solo vs Syndicate deals
SELECT 
    multiple_investors,
    COUNT(*) AS deals,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY multiple_investors;
