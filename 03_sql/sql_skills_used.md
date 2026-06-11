# SQL Skills Used in This Project

## Indian Startup Funding Analysis — SQL Phase

This document lists all SQL skills demonstrated in this project. Useful for:

1. Resume building (copy-paste skills section)
2. Interview preparation (concrete examples to discuss)
3. Recruiter quick-scan (what I can actually do)

The full project work and queries are in the main SQL folder. This file is just a skills summary.

---

## Quick Summary

| Skill Category | Number of Skills |
|----------------|------------------|
| Database Setup & Design | 4 |
| Data Loading & ETL | 6 |
| Data Cleaning | 9 |
| Basic Queries | 8 |
| JOINs and Subqueries | 6 |
| Window Functions | 7 |
| Date and String Functions | 10 |
| **Total** | **50+** |

---

## Database Setup and Design

| # | Skill | Where I Used It |
|---|-------|-----------------|
| 1 | CREATE DATABASE | Setting up `startup_funding_db` |
| 2 | CREATE TABLE | Defined initial schema for raw data |
| 3 | CREATE TABLE AS SELECT | Built derived tables from queries |
| 4 | DROP TABLE IF EXISTS | Safe re-runs of scripts |

---

## Data Loading and ETL Pipeline

I built a 3-stage cleaning pipeline using Python + SQL. This is real ETL work.

| # | Skill | What I Did |
|---|-------|------------|
| 1 | Python pandas integration | Loaded CSV into DataFrame |
| 2 | SQLAlchemy connection | Connected Python to MySQL |
| 3 | DataFrame.to_sql() | Wrote DataFrame to MySQL table |
| 4 | Chunked data loading | Used chunksize=500 for safety |
| 5 | Error handling with try/except | Caught database connection errors |
| 6 | Multi-stage pipeline design | Separated raw, cleaned, standardized tables |

---

## Data Cleaning Skills

| # | Skill | What I Cleaned |
|---|-------|----------------|
| 1 | TRIM() | Removed leading/trailing whitespace |
| 2 | LOWER() and UPPER() | Normalized case for matching |
| 3 | REPLACE() | Replaced unwanted characters |
| 4 | REGEXP pattern matching | Filtered valid date formats |
| 5 | CASE WHEN logic | Categorized 500+ industries into 14 groups |
| 6 | LIKE pattern matching | Found variations of city names |
| 7 | NULL handling | Identified and managed missing data |
| 8 | UPDATE with JOIN | Fixed dates by joining raw and clean tables |
| 9 | SET SQL_SAFE_UPDATES | Managed MySQL safe-update mode |

---

## Basic Query Skills

| # | Skill | What I Queried |
|---|-------|----------------|
| 1 | SELECT with column lists | Retrieved specific columns |
| 2 | WHERE filters | Filtered by city, year, amount |
| 3 | GROUP BY | Aggregated by industry, city, year |
| 4 | HAVING | Filtered grouped results |
| 5 | ORDER BY | Sorted ascending and descending |
| 6 | LIMIT | Limited results to top N |
| 7 | DISTINCT | Counted unique values |
| 8 | UNION | Combined result sets |

---

## Aggregate Functions

| # | Function | Where I Used It |
|---|----------|-----------------|
| 1 | COUNT(*) | Total deals per city/year/sector |
| 2 | COUNT(column) | Excluding NULLs (e.g., deals with amount) |
| 3 | SUM() | Total funding by various dimensions |
| 4 | AVG() | Average deal size |
| 5 | MIN() / MAX() | Smallest and largest deals |
| 6 | ROUND() | Formatted numbers to 2 decimals |
| 7 | STDDEV() | Standard deviation of deal sizes |

---

## JOINs and Subqueries

| # | Skill | Example Use |
|---|-------|-------------|
| 1 | INNER JOIN | Joined raw and clean tables for date fix |
| 2 | LEFT JOIN | Found unmatched records |
| 3 | Self JOIN | Compared deals within same dataset |
| 4 | Correlated subquery | Found deals above average |
| 5 | Non-correlated subquery | Used in WHERE clauses |
| 6 | UPDATE with JOIN | Fixed data across multiple tables |

---

## Window Functions (Advanced!)

These are the "pro-level" SQL skills that distinguish junior from senior analysts.

| # | Window Function | What I Built |
|---|----------------|--------------|
| 1 | LAG() | Year-over-year growth calculation |
| 2 | LEAD() | Comparing with next period |
| 3 | RANK() | Ranking deals within categories |
| 4 | DENSE_RANK() | Top-N analysis without gaps |
| 5 | ROW_NUMBER() | Unique sequential numbering |
| 6 | SUM() OVER() | Cumulative running totals |
| 7 | AVG() OVER() | Moving averages |

### Window Function Examples I Implemented:

**Year-over-year growth using LAG:**
```sql
WITH yearly_funding AS (
    SELECT funding_year, SUM(amount_crore_inr) AS yearly_total
    FROM startup_funding_clean
    GROUP BY funding_year
)
SELECT 
    funding_year, yearly_total,
    LAG(yearly_total) OVER (ORDER BY funding_year) AS previous_year
FROM yearly_funding;
```

**Top 3 startups per city using DENSE_RANK:**
```sql
SELECT * FROM (
    SELECT 
        city_clean, startup_name, amount_crore_inr,
        DENSE_RANK() OVER (
            PARTITION BY city_clean 
            ORDER BY amount_crore_inr DESC
        ) AS rank_in_city
    FROM startup_funding_clean
) ranked
WHERE rank_in_city <= 3;
```

---

## Common Table Expressions (CTEs)

| # | CTE Type | What I Built |
|---|----------|--------------|
| 1 | Single CTE with WITH | Quarterly funding summary |
| 2 | Multiple CTEs | Multi-step analysis |
| 3 | CTE + Window function | YoY growth calculations |
| 4 | CTE + JOIN | Complex investor analysis |

---

## Date and String Functions

| # | Function | Purpose |
|---|----------|---------|
| 1 | STR_TO_DATE() | Parsed messy date strings |
| 2 | DATE_FORMAT() | Formatted dates for display |
| 3 | YEAR() / MONTH() / QUARTER() | Extracted date parts |
| 4 | DATE_ADD() / DATE_SUB() | Date arithmetic |
| 5 | SUBSTRING_INDEX() | Split investor strings by comma |
| 6 | LENGTH() | Calculated string lengths |
| 7 | LOCATE() | Found character positions |
| 8 | CONCAT() | Combined strings |
| 9 | REPLACE() | Replaced unwanted characters |
| 10 | REGEXP | Pattern-matched valid formats |

---

## Conditional Logic with CASE WHEN

I built complex CASE WHEN statements throughout the project.

### Industry Categorization (14 categories):
```sql
CASE 
    WHEN LOWER(industry_vertical) LIKE '%ecommerce%' THEN 'E-Commerce'
    WHEN LOWER(industry_vertical) LIKE '%fintech%' THEN 'FinTech'
    WHEN LOWER(industry_vertical) LIKE '%food%' THEN 'Food & Beverage'
    -- ... 11 more conditions
    ELSE 'Others'
END AS industry_category
```

### City Standardization (15+ city groups):
```sql
CASE
    WHEN LOWER(city) LIKE '%bang%' OR LOWER(city) LIKE '%beng%' THEN 'Bangalore'
    WHEN LOWER(city) LIKE '%delhi%' OR LOWER(city) LIKE '%gurgaon%' THEN 'Delhi-NCR'
    -- ... more conditions
END AS city_clean
```

### Deal Size Categorization:
```sql
CASE
    WHEN amount_crore_inr < 1 THEN 'Micro (<1 Cr)'
    WHEN amount_crore_inr < 10 THEN 'Small (1-10 Cr)'
    WHEN amount_crore_inr < 100 THEN 'Medium (10-100 Cr)'
    WHEN amount_crore_inr < 1000 THEN 'Large (100-1000 Cr)'
    ELSE 'Mega (>1000 Cr)'
END AS deal_size_category
```

---

## Tools and Environment

| Tool | Version | Purpose |
|------|---------|---------|
| MySQL Workbench | Latest | Database management and query writing |
| MySQL Server | 8.0+ | Database engine |
| Python | 3.11+ | Data loading and cleaning |
| pandas | Latest | DataFrame manipulation |
| SQLAlchemy | Latest | Python-MySQL connection |
| pymysql | Latest | MySQL driver for SQLAlchemy |
| VS Code | Latest | Code editing |
| GitHub | N/A | Version control and showcase |

---

## Common Interview Questions I Can Answer

Based on this project, I'm confident answering:

### Question 1: What is a Window Function?
A window function performs calculations across a set of rows related to the current row. Unlike GROUP BY which collapses rows, window functions keep all rows visible but add calculations like running totals, rankings, or comparisons. Examples: LAG, RANK, SUM OVER.

### Question 2: Difference between RANK, DENSE_RANK, ROW_NUMBER?
- ROW_NUMBER: Unique sequential numbers (1, 2, 3, 4, 5)
- RANK: Same rank for ties, gaps after (1, 2, 2, 4, 5)
- DENSE_RANK: Same rank for ties, no gaps (1, 2, 2, 3, 4)

### Question 3: When to use CTE vs Subquery?
CTEs are preferred when:
- The same subquery is used multiple times
- The logic is complex and needs documentation
- Readability matters
- You need recursive queries

Subqueries are preferred when:
- The logic is simple and used once
- You're filtering with EXISTS or IN

### Question 4: How do you handle messy data in SQL?
I use a multi-stage approach:
1. Keep raw data untouched (backup)
2. Build cleaned table with TRIM, LOWER, REPLACE
3. Standardize categories using CASE WHEN with LIKE patterns
4. Use REGEXP for format validation
5. Document NULL handling decisions clearly

### Question 5: What does COALESCE do?
COALESCE returns the first non-NULL value from a list of expressions. Useful for handling missing data with fallbacks.

### Question 6: Difference between WHERE and HAVING?
- WHERE filters rows before aggregation
- HAVING filters groups after aggregation
- WHERE cannot use aggregate functions
- HAVING is used with GROUP BY

### Question 7: What is the difference between TRUNCATE, DELETE, and DROP?
- DROP: Removes the entire table structure and data
- TRUNCATE: Removes all rows, keeps structure
- DELETE: Removes rows based on WHERE condition

### Question 8: How do you optimize slow queries?
- Add appropriate indexes on JOIN and WHERE columns
- Use EXPLAIN to see query execution plan
- Avoid SELECT * (specify columns)
- Use LIMIT when testing
- Filter early in subqueries
- Choose proper JOIN types

---

## Project Files Showing These Skills

| File | Skills Demonstrated |
|------|---------------------|
| `load_data_to_mysql.py` | Python+SQL integration, basic ETL |
| `clean_data_advanced.py` | Advanced regex cleaning, NULL handling |
| `00_date_fix.sql` | STR_TO_DATE, REGEXP, UPDATE with JOIN |
| `01_data_cleaning.sql` | CASE WHEN, CREATE TABLE AS SELECT |
| `02_exploration.sql` | Window functions, CTEs, aggregations |

---

## What I Want to Learn Next

I'm honest about what I don't know well yet:

1. **Stored procedures and functions** - Reusable SQL code blocks
2. **Triggers** - Automatic actions on data changes
3. **Indexing strategies** - Performance optimization
4. **Query optimization** - Reading EXPLAIN output
5. **Database design patterns** - Star schema, normalization
6. **PL/SQL or T-SQL** - Vendor-specific features
7. **NoSQL basics** - MongoDB, Redis fundamentals

I plan to learn these in future projects.

---

## Contact

**Abishek J**

- Email: abishekvja@gmail.com
- LinkedIn: [linkedin.com/in/abishek-j-2a32aa255](https://linkedin.com/in/abishek-j-2a32aa255)
- GitHub: [github.com/yourusername](https://github.com/Abhishek-j-0)
- Location: Coimbatore (open to Bangalore) & Relocation

If you're a recruiter and want to discuss my SQL skills or share an opportunity, please reach out.

---

*Last updated: May 2026*
*Project: Indian Startup Funding Analysis - SQL Phase*
