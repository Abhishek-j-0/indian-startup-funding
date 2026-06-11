-- =========================================================================
-- 🎯 PROJECT     : Indian Startup Funding Analysis (Advanced Analytics Phase)
-- 🧑‍💻 AUTHOR      : Abishek J
-- 📅 DATE        : May 2026
-- =========================================================================
-- 🚀 OBJECTIVE:
--    - Executing Advanced Analytical Queries using Complex Window Functions.
--    - Utilizing Multi-layered CTEs for Year-over-Year (YoY) Growth & Rankings.
--
-- 🛠️ TECHNIQUE  : LAG(), ROW_NUMBER(), NTILE(), and Complex Aggregations
-- =========================================================================

-- Window Functions
-- Query 12: Year-over-year growth using LAG
USE startup_funding_db;

WITH yearly_funding AS (
    SELECT 
        funding_year,
        ROUND(SUM(amount_crore_inr), 2) AS yearly_total
    FROM startup_funding_clean
    WHERE funding_year IS NOT NULL
    GROUP BY funding_year
)
SELECT 
    funding_year,
    yearly_total,
    LAG(yearly_total) OVER (ORDER BY funding_year) AS previous_year,
    ROUND(yearly_total - LAG(yearly_total) OVER (ORDER BY funding_year), 2) AS yoy_change,
    ROUND(
        (yearly_total - LAG(yearly_total) OVER (ORDER BY funding_year)) / 
        LAG(yearly_total) OVER (ORDER BY funding_year) * 100, 2
    ) AS yoy_growth_percent
FROM yearly_funding
ORDER BY funding_year;

-- Query 13: Top 3 startups in each city (DENSE_RANK)
SELECT * FROM (
    SELECT 
        city_clean,
        startup_name,
        ROUND(SUM(amount_crore_inr), 2) AS total_funding,
        DENSE_RANK() OVER (
            PARTITION BY city_clean 
            ORDER BY SUM(amount_crore_inr) DESC
        ) AS rank_in_city
    FROM startup_funding_clean
    WHERE amount_crore_inr IS NOT NULL
    GROUP BY city_clean, startup_name
) ranked
WHERE rank_in_city <= 3
ORDER BY city_clean, rank_in_city;

-- Query 14: Cumulative funding over time (SUM OVER)
SELECT 
    funding_date,
    startup_name,
    amount_crore_inr,
    SUM(amount_crore_inr) OVER (ORDER BY funding_date) AS cumulative_funding
FROM startup_funding_clean
WHERE amount_crore_inr IS NOT NULL
ORDER BY funding_date
LIMIT 100;

-- Query 15: 3-month moving average (AVG OVER)
WITH monthly_funding AS (
    SELECT 
        DATE_FORMAT(funding_date, '%Y-%m') AS month,
        SUM(amount_crore_inr) AS monthly_total
    FROM startup_funding_clean
    WHERE funding_date IS NOT NULL
    GROUP BY DATE_FORMAT(funding_date, '%Y-%m')
)
SELECT 
    month,
    monthly_total,
    ROUND(
        AVG(monthly_total) OVER (
            ORDER BY month 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS three_month_avg
FROM monthly_funding;

-- Complex CTEs
-- Query 16: Find startups that raised in multiple rounds
WITH multi_round_startups AS (
    SELECT 
        startup_name,
        COUNT(*) AS funding_rounds,
        ROUND(SUM(amount_crore_inr), 2) AS total_raised
    FROM startup_funding_clean
    WHERE amount_crore_inr IS NOT NULL
    GROUP BY startup_name
    HAVING COUNT(*) >= 3
)
SELECT 
    mrs.startup_name,
    mrs.funding_rounds,
    mrs.total_raised,
    sf.city_clean,
    sf.industry_category
FROM multi_round_startups mrs
INNER JOIN startup_funding_clean sf ON mrs.startup_name = sf.startup_name
GROUP BY mrs.startup_name, mrs.funding_rounds, mrs.total_raised, sf.city_clean, sf.industry_category
ORDER BY mrs.funding_rounds DESC, mrs.total_raised DESC
LIMIT 20;

-- Query 17: Investor co-investment networks
WITH investor_pairs AS (
    SELECT 
        sf1.primary_investor AS investor_a,
        sf2.primary_investor AS investor_b,
        COUNT(*) AS co_investments
    FROM startup_funding_clean sf1
    INNER JOIN startup_funding_clean sf2 
        ON sf1.startup_name = sf2.startup_name 
        AND sf1.primary_investor < sf2.primary_investor
    GROUP BY sf1.primary_investor, sf2.primary_investor
    HAVING COUNT(*) >= 2
)
SELECT * FROM investor_pairs ORDER BY co_investments DESC LIMIT 15;

-- Advanced Analytics
-- Query 18: Quarterly market share by city
WITH quarterly_city_funding AS (
    SELECT 
        funding_year,
        funding_quarter,
        city_clean,
        SUM(amount_crore_inr) AS city_funding,
        SUM(SUM(amount_crore_inr)) OVER (PARTITION BY funding_year, funding_quarter) AS quarter_total
    FROM startup_funding_clean
    WHERE amount_crore_inr IS NOT NULL
    GROUP BY funding_year, funding_quarter, city_clean
)
SELECT 
    funding_year,
    funding_quarter,
    city_clean,
    ROUND(city_funding, 2) AS city_funding,
    ROUND(city_funding * 100.0 / quarter_total, 2) AS market_share_percent
FROM quarterly_city_funding
WHERE city_clean IN ('Bangalore', 'Delhi-NCR', 'Mumbai')
ORDER BY funding_year, funding_quarter, market_share_percent DESC;

-- Query 19: Percentile analysis
WITH quartile_staged AS (
    SELECT 
        amount_crore_inr,
        NTILE(4) OVER (ORDER BY amount_crore_inr) AS quartile
    FROM startup_funding_clean
    WHERE amount_crore_inr IS NOT NULL
)
SELECT 
    quartile,
    COUNT(*) AS deals,
    ROUND(MIN(amount_crore_inr), 2) AS min_amount,
    ROUND(AVG(amount_crore_inr), 2) AS avg_amount,
    ROUND(MAX(amount_crore_inr), 2) AS max_amount
FROM quartile_staged
GROUP BY quartile
ORDER BY quartile;

-- Query 20: Investor specialization
WITH investor_industries_staged AS (
    SELECT 
        primary_investor,
        industry_category,
        COUNT(*) AS deals_in_industry
    FROM startup_funding_clean
    WHERE primary_investor != 'Undisclosed'
    GROUP BY primary_investor, industry_category
),
investor_industries_final AS (
    SELECT 
        primary_investor,
        industry_category,
        deals_in_industry,
        ROW_NUMBER() OVER (PARTITION BY primary_investor ORDER BY deals_in_industry DESC) AS ranking_num
    FROM investor_industries_staged
)
SELECT 
    primary_investor,
    industry_category AS specialization,
    deals_in_industry
FROM investor_industries_final
WHERE ranking_num = 1
ORDER BY deals_in_industry DESC
LIMIT 20;
