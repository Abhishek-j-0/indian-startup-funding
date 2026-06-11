-- =========================================================================
-- 🎯 PROJECT     : Indian Startup Funding Analysis (Data Modeling Phase)
-- 🧑‍💻 AUTHOR      : Abishek J
-- 📅 DATE        : May 2026
-- =========================================================================
-- 🚀 OBJECTIVE:
--    - Building clean relational lookup tables for advanced data modeling.
--    - Combining data from multiple tables using complex JOINS & Nested Queries.
--
-- 🛠️ TECHNIQUE  : Subqueries, Relational Mapping, and Lookups
-- =========================================================================

-- Create Lookup Tables
-- Table 1: City information
CREATE TABLE IF NOT EXISTS cities_info (
    city_name VARCHAR(100) PRIMARY KEY,
    state VARCHAR(100),
    tier ENUM('Tier 1', 'Tier 2', 'Tier 3'),
    region VARCHAR(50)
);

INSERT INTO cities_info VALUES
('Bangalore', 'Karnataka', 'Tier 1', 'South'),
('Delhi-NCR', 'Delhi', 'Tier 1', 'North'),
('Mumbai', 'Maharashtra', 'Tier 1', 'West'),
('Chennai', 'Tamil Nadu', 'Tier 1', 'South'),
('Hyderabad', 'Telangana', 'Tier 1', 'South'),
('Pune', 'Maharashtra', 'Tier 1', 'West'),
('Kolkata', 'West Bengal', 'Tier 1', 'East'),
('Ahmedabad', 'Gujarat', 'Tier 2', 'West'),
('Jaipur', 'Rajasthan', 'Tier 2', 'North'),
('Coimbatore', 'Tamil Nadu', 'Tier 2', 'South');

-- Table 2: Industry sectors
CREATE TABLE IF NOT EXISTS industry_sectors (
    industry_category VARCHAR(100) PRIMARY KEY,
    parent_sector VARCHAR(100),
    is_tech_related BOOLEAN
);

INSERT INTO industry_sectors VALUES
('E-Commerce', 'Consumer', TRUE),
('FinTech', 'Financial Services', TRUE),
('Technology', 'IT/Software', TRUE),
('Healthcare', 'Healthcare', FALSE),
('Education', 'Education', TRUE),
('Logistics & Transport', 'Logistics', TRUE);
-- ... more industries
