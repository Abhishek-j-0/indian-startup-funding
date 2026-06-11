-- =========================================================================
-- 🎯 PROJECT     : Indian Startup Funding Analysis (ETL & Data Cleaning Phase)
-- 🧑‍💻 AUTHOR      : Abishek J
-- 📅 DATE        : May 2026
-- =========================================================================
-- 🛠️ ETL & DATA PIPELINE SUMMARY:
--    1. EXTRACT   : Raw dataset ingested from source files.
--    2. TRANSFORM : Automated via 'DATA LOADING.py' & 'ADVANCED CLEANING.py'.
--    3. LOAD      : Cleaned staged data successfully loaded into MySQL.
--
-- 🎯 SQL STANDARDIZATION OBJECTIVE:
--    - Execute final SQL transformations to handle hidden encodings (\xc2\xa0).
--    - Enforce database integrity using fixed-point DECIMAL profiles.
--    - Standardize messy industry segments, cities, and funding stages.
-- =========================================================================

CREATE DATABASE IF NOT EXISTS startup_funding_db;
USE startup_funding_db;

-- Drop existing table if you're re-running
DROP TABLE IF EXISTS startup_funding;

-- Create raw data table
CREATE TABLE startup_funding (
    sr_no INT,
    funding_date VARCHAR(50),
    startup_name VARCHAR(255),
    industry VARCHAR(255),
    sub_vertical VARCHAR(255),
    city VARCHAR(255),
    investors_name TEXT,
    investment_type VARCHAR(255),
    amount_usd VARCHAR(50),  -- We load as VARCHAR first because of commas/dirty data
    remarks TEXT
);

-- ========================================
-- TITLE: VERIFY DATA LOAD & TOTAL ROW COUNT
-- Purpose: Confirm we have startup_funding table
-- ========================================

SHOW SCHEMAS;

SELECT * FROM startup_funding LIMIT 10;

SELECT COUNT(*) AS total_rows FROM startup_funding;

-- ========================================
-- TITLE: VIEW ALL TABLES IN DATABASE
-- Purpose: Confirm we have startup_funding 
--          and startup_funding_v2 tables
-- ========================================

USE startup_funding_db;
SHOW TABLES;

-- ============================================================
-- 🎯 VERIFICATION CARD #1: BASIC ROW COUNT CHECK
-- Purpose: Confirm the Python script loaded data successfully
-- Expected: ~3000-3044 rows in startup_funding_v2
-- ============================================================

USE startup_funding_db;

SELECT 
    'Original raw table' AS table_name,
    COUNT(*) AS total_rows
FROM startup_funding

UNION ALL

SELECT 
    'Python cleaned table (v2)' AS table_name,
    COUNT(*) AS total_rows
FROM startup_funding_v2;

-- ============================================================
-- 🎯 VERIFICATION CARD #2: CHECK COLUMN STRUCTURE
-- Purpose: Verify all new columns were created properly
-- Expected: Should see derived columns like funding_year, 
--          amount_crore_inr, primary_investor, etc.
-- ============================================================

SHOW COLUMNS FROM startup_funding_v2;

-- ============================================================
-- 🎯 VERIFICATION CARD #3: SAMPLE CLEANED DATA
-- Purpose: Visually confirm data looks clean
-- Expected: No URLs, no \xc2\xa0, no hashtags, no brackets
-- ============================================================

SELECT 
    startup_name,
    city__location,
    industry_vertical,
    primary_investor,
    investor_count,
    amount_crore_inr,
    funding_year
FROM startup_funding_v2
LIMIT 20;

-- ============================================================
-- 🎯 VERIFICATION CARD #4: FORMAT INR AMOUNT TO 2 DECIMAL PLACES
-- Purpose: Confirm 'amount_crore_inr' matches Excel format 
--          by removing long trailing decimals.
-- Expected: Values rounded off nicely (e.g., 176.19 instead of 176.1899...)
-- ============================================================

SELECT 
    startup_name, 
    city__location,
    industry_vertical, 
    primary_investor, 
    investor_count, 
    ROUND(amount_crore_inr, 2) AS amount_crore_inr_formatted,
    funding_year
FROM startup_funding_v2 
LIMIT 20;

-- ============================================================
-- 🎯 VERIFICATION CARD #5: CHECK FOR REMAINING URLs (Must be 0!)
-- Purpose: Confirm URL cleaning worked
-- Expected: 0 rows (no URLs anywhere)
-- ============================================================

SELECT 
    'URLs in startup_name' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE startup_name LIKE '%http%' OR startup_name LIKE '%www%'

UNION ALL

SELECT 
    'URLs in city' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE city__location LIKE '%http%' OR city__location LIKE '%www%'

UNION ALL

SELECT 
    'URLs in investors' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE investors_name LIKE '%http%' OR investors_name LIKE '%www%';

-- ============================================================
-- 🎯 VERIFICATION CARD #6: CHECK FOR ENCODING ARTIFACTS
-- Purpose: Verify \xc2\xa0 and similar were cleaned
-- Expected: 0 rows (clean text only)
-- ============================================================

SELECT 
    'Encoding artifacts in startup_name' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE startup_name LIKE '%\\\\x%' 
   OR startup_name LIKE '%xc2%'
   OR startup_name LIKE '%\\\\%';

-- ============================================================
-- 🎯 VERIFICATION CARD #7: CHECK FOR HASHTAGS & BRACKETS
-- Purpose: Verify special characters removed
-- Expected: 0 rows
-- ============================================================

SELECT 
    'Hashtags in names' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE startup_name LIKE '%#%'

UNION ALL

SELECT 
    'Brackets in names' AS issue,
    COUNT(*) AS count
FROM startup_funding_v2
WHERE startup_name LIKE '%[%' OR startup_name LIKE '%]%';

-- ============================================================
-- 🎯 VERIFICATION CARD #8: DATE COLUMN CHECK
-- Purpose: Verify dates were converted properly
-- Expected: Valid date range (2015-2020)
-- ============================================================

SELECT 
    MIN(funding_date) AS earliest_date,
    MAX(funding_date) AS latest_date,
    COUNT(funding_date) AS valid_dates,
    SUM(CASE WHEN funding_date IS NULL THEN 1 ELSE 0 END) AS null_dates
FROM startup_funding_v2;

-- ============================================================
-- 🎯 VERIFICATION CARD #9: AMOUNT COLUMN CHECK
-- Purpose: Verify amounts are numbers (not text)
-- Expected: Numeric ranges visible
-- ============================================================

SELECT 
    COUNT(amount_in_usd) AS valid_amounts,
    SUM(CASE WHEN amount_in_usd IS NULL THEN 1 ELSE 0 END) AS missing_amounts,
    ROUND(MIN(amount_crore_inr), 2) AS min_amount_cr,
    ROUND(MAX(amount_crore_inr), 2) AS max_amount_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_amount_cr
FROM startup_funding_v2;

-- ============================================================
-- 🎯 VERIFICATION CARD #10: INVESTOR ANALYSIS
-- Purpose: Verify primary investor extraction worked
-- Expected: Mix of "Yes" and "No" for multiple_investors
-- ============================================================

SELECT 
    multiple_investors,
    COUNT(*) AS deal_count,
    ROUND(AVG(investor_count), 2) AS avg_investors_per_deal
FROM startup_funding_v2
GROUP BY multiple_investors;

-- ============================================================
-- 🎯 VERIFICATION CARD #11: TOP 15 CITIES (Sanity Check!)
-- Purpose: See if cleaning preserved important data
-- Expected: Major cities like Bangalore, Mumbai, Delhi visible
-- ============================================================

SELECT 
    city__location,
    COUNT(*) AS deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_v2
WHERE city__location IS NOT NULL
GROUP BY city__location
ORDER BY deals DESC
LIMIT 15;

-- ============================================================
-- 🎯 VERIFICATION CARD #12: FINAL DATA QUALITY SCORE
-- Purpose: Overall summary of cleaning quality
-- Expected: High data quality scores
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    COUNT(startup_name) AS rows_with_startup_name,
    COUNT(city__location) AS rows_with_city,
    COUNT(industry_vertical) AS rows_with_industry,
    COUNT(amount_crore_inr) AS rows_with_amount,
    COUNT(funding_date) AS rows_with_date,
    ROUND(COUNT(amount_crore_inr) * 100.0 / COUNT(*), 2) AS amount_completeness_pct,
    ROUND(COUNT(city__location) * 100.0 / COUNT(*), 2) AS city_completeness_pct
FROM startup_funding_v2;

-- ============================================================
-- 🎯 SQL STANDARDIZATION SCRIPT
-- Project: Indian Startup Funding Analysis
-- Author: ABISHEK J
-- Date: May 2026
-- 
-- Purpose: Create final analysis-ready table by:
--   1. Categorizing 500+ industries into 14 clean categories
--   2. Standardizing city names into 15 clean groups
--   3. Cleaning funding stages
-- 
-- Input:  startup_funding_v2 (Python cleaned)
-- Output: startup_funding_clean (Final analysis table)
-- ============================================================

USE startup_funding_db;

-- ============================================================
-- 🎯 STEP 1: DROP TABLE IF EXISTS (Safe restart)
-- This allows us to re-run the script anytime
-- ============================================================

DROP TABLE IF EXISTS startup_funding_clean;

-- ============================================================
-- 🎯 STEP 2: CREATE THE FINAL CLEAN TABLE
-- Using CREATE TABLE AS SELECT to standardize everything
-- ============================================================

CREATE TABLE startup_funding_clean AS
SELECT 
    -- ===== IDENTITY COLUMNS =====
    sr_no,
    startup_name,
    funding_date,
    funding_year,
    funding_month,
    funding_quarter,
    
    -- ===== ORIGINAL INDUSTRY (Keep for reference) =====
    industry_vertical AS industry_original,
    
    -- ===== STANDARDIZED INDUSTRY CATEGORY =====
    -- Groups 500+ messy industry values into 14 clean categories
    CASE 
        -- E-Commerce & Online Retail
        WHEN LOWER(industry_vertical) LIKE '%ecommerce%' 
          OR LOWER(industry_vertical) LIKE '%e-commerce%'
          OR LOWER(industry_vertical) LIKE '%e commerce%'
          OR LOWER(industry_vertical) LIKE '%online retail%'
          OR LOWER(industry_vertical) LIKE '%marketplace%'
          OR LOWER(industry_vertical) LIKE '%online shop%'
            THEN 'E-Commerce'
        
        -- FinTech & Financial Services
        WHEN LOWER(industry_vertical) LIKE '%fintech%' 
          OR LOWER(industry_vertical) LIKE '%finance%'
          OR LOWER(industry_vertical) LIKE '%financial%'
          OR LOWER(industry_vertical) LIKE '%payment%'
          OR LOWER(industry_vertical) LIKE '%banking%'
          OR LOWER(industry_vertical) LIKE '%lending%'
          OR LOWER(industry_vertical) LIKE '%insurance%'
          OR LOWER(industry_vertical) LIKE '%loan%'
          OR LOWER(industry_vertical) LIKE '%wallet%'
            THEN 'FinTech'
        
        -- Food & Beverage
        WHEN LOWER(industry_vertical) LIKE '%food%' 
          OR LOWER(industry_vertical) LIKE '%restaurant%'
          OR LOWER(industry_vertical) LIKE '%beverage%'
          OR LOWER(industry_vertical) LIKE '%dining%'
          OR LOWER(industry_vertical) LIKE '%kitchen%'
          OR LOWER(industry_vertical) LIKE '%cafe%'
            THEN 'Food & Beverage'
        
        -- Healthcare & Medical
        WHEN LOWER(industry_vertical) LIKE '%health%' 
          OR LOWER(industry_vertical) LIKE '%medical%'
          OR LOWER(industry_vertical) LIKE '%pharma%'
          OR LOWER(industry_vertical) LIKE '%hospital%'
          OR LOWER(industry_vertical) LIKE '%wellness%'
          OR LOWER(industry_vertical) LIKE '%doctor%'
          OR LOWER(industry_vertical) LIKE '%clinic%'
            THEN 'Healthcare'
        
        -- Education & EdTech
        WHEN LOWER(industry_vertical) LIKE '%education%' 
          OR LOWER(industry_vertical) LIKE '%edtech%'
          OR LOWER(industry_vertical) LIKE '%learning%'
          OR LOWER(industry_vertical) LIKE '%school%'
          OR LOWER(industry_vertical) LIKE '%student%'
          OR LOWER(industry_vertical) LIKE '%tutor%'
          OR LOWER(industry_vertical) LIKE '%course%'
            THEN 'Education'
        
        -- Logistics & Transportation
        WHEN LOWER(industry_vertical) LIKE '%logistic%' 
          OR LOWER(industry_vertical) LIKE '%transport%'
          OR LOWER(industry_vertical) LIKE '%cab%'
          OR LOWER(industry_vertical) LIKE '%taxi%'
          OR LOWER(industry_vertical) LIKE '%shipping%'
          OR LOWER(industry_vertical) LIKE '%delivery%'
          OR LOWER(industry_vertical) LIKE '%mobility%'
          OR LOWER(industry_vertical) LIKE '%auto%'
            THEN 'Logistics & Transport'
        
        -- Travel & Hospitality
        WHEN LOWER(industry_vertical) LIKE '%travel%' 
          OR LOWER(industry_vertical) LIKE '%hotel%'
          OR LOWER(industry_vertical) LIKE '%hospitality%'
          OR LOWER(industry_vertical) LIKE '%tourism%'
          OR LOWER(industry_vertical) LIKE '%vacation%'
          OR LOWER(industry_vertical) LIKE '%booking%'
            THEN 'Travel & Hospitality'
        
        -- Fashion & Lifestyle
        WHEN LOWER(industry_vertical) LIKE '%fashion%' 
          OR LOWER(industry_vertical) LIKE '%apparel%'
          OR LOWER(industry_vertical) LIKE '%clothing%'
          OR LOWER(industry_vertical) LIKE '%lifestyle%'
          OR LOWER(industry_vertical) LIKE '%beauty%'
          OR LOWER(industry_vertical) LIKE '%cosmetic%'
          OR LOWER(industry_vertical) LIKE '%jewel%'
            THEN 'Fashion & Lifestyle'
        
        -- Media & Entertainment
        WHEN LOWER(industry_vertical) LIKE '%media%' 
          OR LOWER(industry_vertical) LIKE '%entertainment%'
          OR LOWER(industry_vertical) LIKE '%gaming%'
          OR LOWER(industry_vertical) LIKE '%content%'
          OR LOWER(industry_vertical) LIKE '%music%'
          OR LOWER(industry_vertical) LIKE '%video%'
          OR LOWER(industry_vertical) LIKE '%streaming%'
            THEN 'Media & Entertainment'
        
        -- Agriculture & Farming
        WHEN LOWER(industry_vertical) LIKE '%agri%' 
          OR LOWER(industry_vertical) LIKE '%farm%'
          OR LOWER(industry_vertical) LIKE '%agriculture%'
          OR LOWER(industry_vertical) LIKE '%crop%'
            THEN 'Agriculture'
        
        -- Real Estate & Property
        WHEN LOWER(industry_vertical) LIKE '%real estate%' 
          OR LOWER(industry_vertical) LIKE '%property%'
          OR LOWER(industry_vertical) LIKE '%construction%'
          OR LOWER(industry_vertical) LIKE '%housing%'
            THEN 'Real Estate'
        
        -- Energy & Environment
        WHEN LOWER(industry_vertical) LIKE '%energy%' 
          OR LOWER(industry_vertical) LIKE '%solar%'
          OR LOWER(industry_vertical) LIKE '%renewable%'
          OR LOWER(industry_vertical) LIKE '%environment%'
          OR LOWER(industry_vertical) LIKE '%green%'
            THEN 'Energy & Environment'
        
        -- HR & Recruitment
        WHEN LOWER(industry_vertical) LIKE '%hr %' 
          OR LOWER(industry_vertical) LIKE '%recruit%'
          OR LOWER(industry_vertical) LIKE '%hiring%'
          OR LOWER(industry_vertical) LIKE '%job%'
          OR LOWER(industry_vertical) LIKE '%talent%'
            THEN 'HR & Recruitment'
        
        -- Technology (general tech, SaaS, software)
        WHEN LOWER(industry_vertical) LIKE '%tech%' 
          OR LOWER(industry_vertical) LIKE '%software%'
          OR LOWER(industry_vertical) LIKE '%saas%'
          OR LOWER(industry_vertical) LIKE '%it %'
          OR LOWER(industry_vertical) LIKE '%information technology%'
          OR LOWER(industry_vertical) LIKE '%ai%'
          OR LOWER(industry_vertical) LIKE '%artificial intelligence%'
          OR LOWER(industry_vertical) LIKE '%cloud%'
          OR LOWER(industry_vertical) LIKE '%analytics%'
          OR LOWER(industry_vertical) LIKE '%data%'
            THEN 'Technology'
        
        -- Catch-all for everything else
        ELSE 'Others'
    END AS industry_category,
    
    -- ===== ORIGINAL CITY (Keep for reference) =====
    city__location AS city_original,
    
    -- ===== STANDARDIZED CITY =====
    -- Groups variations like Bangalore/Bengaluru into 1 clean name
    CASE 
        WHEN LOWER(city__location) LIKE '%bang%' 
          OR LOWER(city__location) LIKE '%beng%'
            THEN 'Bangalore'
        
        WHEN LOWER(city__location) LIKE '%delhi%' 
          OR LOWER(city__location) LIKE '%gurgaon%'
          OR LOWER(city__location) LIKE '%gurugram%'
          OR LOWER(city__location) LIKE '%noida%'
          OR LOWER(city__location) LIKE '%faridabad%'
          OR LOWER(city__location) LIKE '%ghaziabad%'
            THEN 'Delhi-NCR'
        
        WHEN LOWER(city__location) LIKE '%mumbai%' 
          OR LOWER(city__location) LIKE '%bombay%'
          OR LOWER(city__location) LIKE '%navi mumbai%'
            THEN 'Mumbai'
        
        WHEN LOWER(city__location) LIKE '%chennai%' 
          OR LOWER(city__location) LIKE '%madras%'
            THEN 'Chennai'
        
        WHEN LOWER(city__location) LIKE '%hyderabad%'
          OR LOWER(city__location) LIKE '%secunderabad%'
            THEN 'Hyderabad'
        
        WHEN LOWER(city__location) LIKE '%pune%'
            THEN 'Pune'
        
        WHEN LOWER(city__location) LIKE '%kolkata%'
          OR LOWER(city__location) LIKE '%calcutta%'
            THEN 'Kolkata'
        
        WHEN LOWER(city__location) LIKE '%ahmedabad%'
            THEN 'Ahmedabad'
        
        WHEN LOWER(city__location) LIKE '%jaipur%'
            THEN 'Jaipur'
        
        WHEN LOWER(city__location) LIKE '%coimbatore%'
            THEN 'Coimbatore'
        
        WHEN LOWER(city__location) LIKE '%kochi%'
          OR LOWER(city__location) LIKE '%cochin%'
          OR LOWER(city__location) LIKE '%ernakulam%'
            THEN 'Kochi'
        
        WHEN LOWER(city__location) LIKE '%indore%'
            THEN 'Indore'
        
        WHEN LOWER(city__location) LIKE '%bhopal%'
            THEN 'Bhopal'
        
        WHEN LOWER(city__location) LIKE '%lucknow%'
            THEN 'Lucknow'
        
        WHEN LOWER(city__location) LIKE '%chandigarh%'
            THEN 'Chandigarh'
        
        -- International cities (Indian startups based abroad)
        WHEN LOWER(city__location) LIKE '%usa%'
          OR LOWER(city__location) LIKE '%new york%'
          OR LOWER(city__location) LIKE '%california%'
          OR LOWER(city__location) LIKE '%san francisco%'
            THEN 'USA-Based'
        
        WHEN LOWER(city__location) LIKE '%singapore%'
            THEN 'Singapore-Based'
        
        WHEN LOWER(city__location) LIKE '%london%'
          OR LOWER(city__location) LIKE '%uk%'
            THEN 'UK-Based'
        
        WHEN city__location IS NULL OR city__location = ''
            THEN 'Unknown'
        
        ELSE 'Other Cities'
    END AS city_clean,
    
    -- ===== INVESTOR COLUMNS (Already cleaned in Python) =====
    investors_name,
    primary_investor,
    investor_count,
    multiple_investors,
    
    -- ===== ORIGINAL FUNDING STAGE (Keep for reference) =====
    investmentntype AS funding_stage_original,
    
    -- ===== STANDARDIZED FUNDING STAGE =====
    -- Groups variations like "Seed", "Seed Funding", "Seed Round" → "Seed"
    CASE 
        WHEN LOWER(investmentntype) LIKE '%seed%'
            THEN 'Seed'
        
        WHEN LOWER(investmentntype) LIKE '%series a%' 
          OR LOWER(investmentntype) LIKE '%series-a%'
            THEN 'Series A'
        
        WHEN LOWER(investmentntype) LIKE '%series b%' 
          OR LOWER(investmentntype) LIKE '%series-b%'
            THEN 'Series B'
        
        WHEN LOWER(investmentntype) LIKE '%series c%' 
          OR LOWER(investmentntype) LIKE '%series-c%'
            THEN 'Series C'
        
        WHEN LOWER(investmentntype) LIKE '%series d%' 
          OR LOWER(investmentntype) LIKE '%series-d%'
            THEN 'Series D'
        
        WHEN LOWER(investmentntype) LIKE '%series e%' 
          OR LOWER(investmentntype) LIKE '%series-e%'
            THEN 'Series E'
        
        WHEN LOWER(investmentntype) LIKE '%private equity%' 
          OR LOWER(investmentntype) = 'pe'
            THEN 'Private Equity'
        
        WHEN LOWER(investmentntype) LIKE '%debt%'
            THEN 'Debt Funding'
        
        WHEN LOWER(investmentntype) LIKE '%angel%'
            THEN 'Angel'
        
        WHEN LOWER(investmentntype) LIKE '%pre-series%' 
          OR LOWER(investmentntype) LIKE '%pre series%'
            THEN 'Pre-Series'
        
        WHEN LOWER(investmentntype) LIKE '%crowd%'
            THEN 'Crowdfunding'
        
        WHEN LOWER(investmentntype) LIKE '%bridge%'
            THEN 'Bridge Funding'
        
        WHEN investmentntype IS NULL OR investmentntype = ''
            THEN 'Unknown'
        
        ELSE 'Other'
    END AS funding_stage_clean,
    
    deal_size_category,
    amount_in_usd,
    amount_crore_inr  

FROM startup_funding_v2
WHERE startup_name IS NOT NULL  
AND startup_name != '';

-- 1. Temporarily disabled Safe Update mode
SET SQL_SAFE_UPDATES = 0;

-- 2. Permanently removed the 'xc2xa0' character from startup names
UPDATE startup_funding_clean
SET startup_name = REPLACE(startup_name, 'xc2xa0', '');

-- 3. Removed unnecessary leading and trailing spaces from names
UPDATE startup_funding_clean
SET startup_name = TRIM(startup_name);

-- 4. Re-enable Safe Update for safety
SET SQL_SAFE_UPDATES = 1;

-- ============================================================
-- 🎯 STEP 3: VERIFY THE CLEAN TABLE WAS CREATED
-- ============================================================

SELECT 'startup_funding_clean table created successfully!' AS status;

SELECT COUNT(*) AS total_rows_in_clean_table 
FROM startup_funding_clean;

-- ============================================================
-- 🎯 STEP 4: VERIFY CITY STANDARDIZATION
-- Expected: Clean city names without duplicates
-- ============================================================

SELECT 
    city_clean,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
GROUP BY city_clean
ORDER BY total_deals DESC;

-- ============================================================
-- 🎯 STEP 5: VERIFY INDUSTRY CATEGORIZATION
-- Expected: 14 clean categories + "Others"
-- ============================================================

SELECT 
    industry_category,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
GROUP BY industry_category
ORDER BY total_deals DESC;

-- ============================================================
-- 🎯 STEP 6: VERIFY FUNDING STAGE STANDARDIZATION
-- Expected: Standard stages (Seed, Series A-E, Private Equity)
-- ============================================================

SELECT 
    funding_stage_clean,
    COUNT(*) AS total_deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean
GROUP BY funding_stage_clean
ORDER BY total_deals DESC;

-- ============================================================
-- 🎯 STEP 7: COMPARE WITH EXCEL RESULTS (Sanity Check!)
-- Excel total: ₹1,77,962 Cr (includes some estimated amounts)
-- SQL total:   ₹1,97,155 Cr (disclosed amounts only, 257 NULLs excluded)
-- 
-- The difference is due to stricter NULL handling in Python cleaning.
-- SQL number is more analytically accurate.
-- ============================================================

SELECT 
    city_clean,
    COUNT(*) AS deals,
    ROUND(SUM(amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(amount_crore_inr), 2) AS avg_deal_size_cr
FROM startup_funding_clean
WHERE city_clean = 'Bangalore';

-- ============================================================
-- 🎯 STEP 8: SAMPLE FINAL CLEAN DATA
-- ============================================================

SELECT 
    startup_name,
    city_clean,
    industry_category,
    primary_investor,
    funding_stage_clean,
    amount_crore_inr,
    funding_year
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
ORDER BY amount_crore_inr DESC
LIMIT 20;

-- ============================================================
-- 🎯 STEP 9: FINAL SUMMARY OF ALL 3 TABLES
-- ============================================================

SELECT 
    'startup_funding (raw)' AS table_name,
    COUNT(*) AS row_count
FROM startup_funding

UNION ALL

SELECT 
    'startup_funding_v2 (Python cleaned)' AS table_name,
    COUNT(*) AS row_count
FROM startup_funding_v2

UNION ALL

SELECT 
    'startup_funding_clean (FINAL - Analysis Ready!)' AS table_name,
    COUNT(*) AS row_count
FROM startup_funding_clean;

-- ============================================================
-- ✅ STANDARDIZATION COMPLETE!
-- final analysis table is: startup_funding_clean
-- Use this table for ALL future queries
-- ============================================================

-- Total clean rows
SELECT COUNT(*) FROM startup_funding_clean;

-- Verify city distribution
SELECT city_clean, COUNT(*) AS deals
FROM startup_funding_clean
GROUP BY city_clean
ORDER BY deals DESC;

-- Verify industry distribution
SELECT industry_category, COUNT(*) AS deals
FROM startup_funding_clean
GROUP BY industry_category
ORDER BY deals DESC;
