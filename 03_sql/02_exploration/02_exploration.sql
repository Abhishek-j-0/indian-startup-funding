-- ============================================================
-- PROJECT: Indian Startup Funding Analysis (SQL Phase)
-- AUTHOR: Abishek J
-- DATE: May 2026
-- 
-- PURPOSE: Explore the cleaned dataset to understand patterns,
--          distributions, and data quality before running
--          business queries.
-- 
-- SOURCE TABLE: startup_funding_clean
-- ============================================================


-- ============================================================
-- IMPORTANT NOTE: EXCEL vs SQL NUMBER DIFFERENCES
-- ============================================================
-- During this SQL phase, some totals differ from the Excel phase 
-- analysis. This is expected and documented for transparency.
-- 
-- Example: Bangalore Funding Total
--   Excel Phase: ₹1,77,962 Cr (596 deals with amounts, treats NULL as 0)
--   SQL Phase:   ₹1,97,155 Cr (597 deals with amounts, excludes NULLs)
-- 
-- WHY THE DIFFERENCE?
-- 1. Excel used IFERROR formula treating empty cells as 0
-- 2. Python deep-cleaning correctly identified undisclosed amounts as NULL
-- 3. SQL SUM excludes NULL values, giving disclosed-funding total
-- 4. Tiny USD-INR rate variation (Excel: 95.9705, Python: 95.97)
-- 
-- WHICH IS RIGHT?
-- Both are valid. Excel total = market sizing estimate.
-- SQL total = verified disclosed funding only.
-- I use SQL numbers for this phase as the source of truth.
-- ============================================================

USE startup_funding_db;

-- ============================================================
-- SECTION 1: DATASET OVERVIEW
-- Purpose: Get the big picture of our cleaned dataset
-- ============================================================

SELECT 
    COUNT(*) AS total_deals,
    COUNT(DISTINCT startup_name) AS unique_startups,
    COUNT(DISTINCT primary_investor) AS unique_investors,
    COUNT(DISTINCT city_clean) AS unique_cities,
    COUNT(DISTINCT industry_category) AS unique_industries,
    MIN(funding_date) AS earliest_deal,
    MAX(funding_date) AS latest_deal,
    ROUND(SUM(amount_crore_inr), 2) AS total_disclosed_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean;

-- ============================================================
-- SECTION 2: DATA COMPLETENESS CHECK
-- Purpose: Identify which columns have missing data and how much
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN amount_crore_inr IS NULL THEN 1 ELSE 0 END) AS missing_amounts,
    SUM(CASE WHEN city_clean = 'Unknown' THEN 1 ELSE 0 END) AS unknown_cities,
    SUM(CASE WHEN industry_category = 'Others' THEN 1 ELSE 0 END) AS uncategorized_industries,
    SUM(CASE WHEN funding_date IS NULL THEN 1 ELSE 0 END) AS missing_dates,
    ROUND(SUM(CASE WHEN amount_crore_inr IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS missing_amount_percent
FROM startup_funding_clean;

-- ============================================================
-- SECTION 3: DEAL SIZE DISTRIBUTION
-- Purpose: Understand the shape of deal sizes
-- Expected: Heavily skewed - most deals are small
-- ============================================================

SELECT 
    deal_size_category,
    COUNT(*) AS deal_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY deal_size_category
ORDER BY 
    CASE deal_size_category
        WHEN 'Micro (<1 Cr)' THEN 1
        WHEN 'Small (1-10 Cr)' THEN 2
        WHEN 'Medium (10-100 Cr)' THEN 3
        WHEN 'Large (100-1000 Cr)' THEN 4
        WHEN 'Mega (>1000 Cr)' THEN 5
        ELSE 6
    END;

-- ============================================================
-- SECTION 4: YEAR-WISE DEAL DISTRIBUTION
-- Purpose: See how data is distributed across years 2015-2020
-- ============================================================

SELECT 
    funding_year,
    COUNT(*) AS total_deals,
    COUNT(amount_crore_inr) AS deals_with_amount,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
WHERE funding_year IS NOT NULL
GROUP BY funding_year
ORDER BY funding_year;

-- ============================================================
-- SECTION 5: STATISTICAL SUMMARY OF DEAL SIZES
-- Purpose: Min, max, mean, standard deviation
-- ============================================================

SELECT 
    COUNT(amount_crore_inr) AS deals_with_amount,
    ROUND(MIN(amount_crore_inr), 2) AS smallest_deal_cr,
    ROUND(MAX(amount_crore_inr), 2) AS largest_deal_cr,
    ROUND(AVG(amount_crore_inr), 2) AS mean_deal_cr,
    ROUND(STDDEV(amount_crore_inr), 2) AS std_deviation
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL;

-- ============================================================
-- SECTION 6: TOP 15 CITIES BY NUMBER OF DEALS
-- Purpose: Geographic distribution of startup activity
-- ============================================================

SELECT 
    city_clean,
    COUNT(*) AS total_deals,
    COUNT(amount_crore_inr) AS deals_with_amount,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
GROUP BY city_clean
ORDER BY total_deals DESC
LIMIT 15;

-- =========================================================================
-- SECTION 7: TOP 10 CITIES BY MAXIMUM TOTAL FUNDING
-- Purpose: Identify geographic hubs driving the highest capital concentration
-- =========================================================================

SELECT 
    city_clean,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    COUNT(*) AS total_deals
FROM startup_funding_clean
GROUP BY city_clean
ORDER BY total_funding_cr DESC
LIMIT 10;

-- ============================================================
-- SECTION 8: INDUSTRY DISTRIBUTION
-- Purpose: Which sectors attract the most funding
-- ============================================================

SELECT 
    industry_category,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(SUM(amount_crore_inr) * 100.0 / SUM(SUM(amount_crore_inr)) OVER (), 2) AS funding_share_percent
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY industry_category
ORDER BY total_funding_cr DESC;

-- ============================================================
-- SECTION 9: FUNDING STAGE BREAKDOWN
-- Purpose: Distribution of deals across funding stages
-- ============================================================

SELECT 
    funding_stage_clean,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
GROUP BY funding_stage_clean
ORDER BY total_deals DESC;

-- ============================================================
-- SECTION 10: SOLO vs SYNDICATE INVESTOR PATTERNS
-- Purpose: Compare deals with single vs multiple investors
-- ============================================================

SELECT 
    multiple_investors,
    COUNT(*) AS total_deals,
    ROUND(AVG(investor_count), 2) AS avg_investors_per_deal,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
GROUP BY multiple_investors;

-- ============================================================
-- SECTION 11: TOP 20 MEGA DEALS
-- Purpose: Identify the largest funding rounds in the dataset
-- ============================================================

SELECT 
    startup_name,
    city_clean,
    industry_category,
    funding_stage_clean,
    primary_investor,
    ROUND(amount_crore_inr, 2) AS amount_cr,
    funding_year
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
ORDER BY amount_crore_inr DESC
LIMIT 20;

-- ============================================================
-- SECTION 12: BANGALORE SANITY CHECK (Compare with Excel Phase)
-- Purpose: Cross-reference SQL results with Excel analysis
-- 
-- Excel Phase Result: 855 deals, ₹1,77,962 Cr (596 deals had amounts)
-- SQL Phase Result:   855 deals, ₹1,97,155 Cr (597 deals have amounts)
-- 
-- The 1-deal difference and amount variance is due to different
-- cleaning methodologies (manual Excel vs automated Python).
-- ============================================================

SELECT 
    'Bangalore Summary' AS metric,
    COUNT(*) AS total_deals,
    COUNT(amount_crore_inr) AS deals_with_amount,
    COUNT(*) - COUNT(amount_crore_inr) AS deals_with_null_amount,
    ROUND(SUM(amount_crore_inr), 2) AS total_disclosed_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
WHERE city_clean = 'Bangalore';

-- ============================================================
-- END OF EXPLORATION
-- 
-- Next File: 03_basic_queries.sql 
-- Purpose: Answer specific business questions identified
--          during this exploration phase
-- ============================================================
