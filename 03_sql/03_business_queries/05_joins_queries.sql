-- =========================================================================
-- 🎯 PROJECT     : Indian Startup Funding Analysis (Relational Joining Phase)
-- 🧑‍💻 AUTHOR      : Abishek J
-- 📅 DATE        : May 2026
-- =========================================================================
-- 🚀 OBJECTIVE:
--    - Combining normalized tables using relational INNER JOINS.
--    - Mapping city tiers and tech segments to extract macro-level insights.
--
-- 📑 TABLES USED : startup_funding_clean, cities_info, industry_sectors
-- =========================================================================

-- INNER JOIN Examples
-- Query 8: Funding by city tier
SELECT 
    ci.tier,
    COUNT(*) AS deals,
    ROUND(SUM(sf.amount_crore_inr), 2) AS total_funding_cr,
    ROUND(AVG(sf.amount_crore_inr), 2) AS avg_deal
FROM startup_funding_clean sf
INNER JOIN cities_info ci ON sf.city_clean = ci.city_name
WHERE sf.amount_crore_inr IS NOT NULL
GROUP BY ci.tier;

-- Query 9: Tech vs Non-Tech funding
SELECT 
    CASE WHEN is_tech_related = TRUE THEN 'Tech' ELSE 'Non-Tech' END AS sector_type,
    COUNT(*) AS deals,
    ROUND(SUM(sf.amount_crore_inr), 2) AS total_funding_cr
FROM startup_funding_clean sf
INNER JOIN industry_sectors ins ON sf.industry_category = ins.industry_category
GROUP BY is_tech_related;

-- Subqueries
-- Query 10: Above-average deals
SELECT 
    startup_name,
    city_clean,
    amount_crore_inr
FROM startup_funding_clean
WHERE amount_crore_inr > (
    SELECT AVG(amount_crore_inr) 
    FROM startup_funding_clean 
    WHERE amount_crore_inr IS NOT NULL
)
ORDER BY amount_crore_inr DESC
LIMIT 20;

-- Query 11: Cities outperforming Mumbai
SELECT city_clean, COUNT(*) AS deals
FROM startup_funding_clean
GROUP BY city_clean
HAVING COUNT(*) > (
    SELECT COUNT(*) FROM startup_funding_clean WHERE city_clean = 'Mumbai'
)
ORDER BY deals DESC;
