# SQL Analysis: Indian Startup Funding (2015-2020)

> Phase 2 of my multi-tool data analytics project. Same dataset as Excel phase, analyzed using MySQL with Python integration.

---

## About This Phase

This is the SQL phase of my Indian Startup Funding analysis. After completing the Excel phase, I rebuilt the entire analysis using MySQL and Python to demonstrate database skills.

The goal was simple: take the same messy data and process it through a proper ETL pipeline, then answer business questions using SQL queries from basic SELECT to advanced Window Functions.

This phase taught me more than any SQL tutorial. Real data has real problems and SQL forces you to be systematic.

---

## Quick Stats from This Phase

- **Total deals analyzed:** 3,042
- **Deals with disclosed amounts:** 2,075 (68%)
- **Total disclosed funding:** ₹4,45,021 Cr (₹4.45 Lakh Crore)
- **Average deal size:** ₹214 Cr
- **Time period:** January 2015 to early 2020
- **Tools used:** MySQL Workbench, Python, Pandas, SQLAlchemy

---

## What's in This Folder

```
03_sql/
├── README.md (this file)
├── sql_skills_used.md (Documentation of SQL skills demonstrated)
├── key_insights.md (Top 10 findings from this phase)
├── load_data_to_mysql.py (Python: Initial CSV load)
├── clean_data_advanced.py (Python: Deep cleaning with regex)
├── 00_date_fix.sql (SQL: Date parsing repair)
├── 01_data_cleaning.sql (SQL: Standardization of cities, industries, stages)
├── 02_exploration.sql (SQL: Data exploration queries)
├── 03_basic_queries.sql (SQL: Basic queries)
├── 04_create_lookup_tables.sql (SQL: JOINS & Nested queries)
├── 05_joins_queries.sql (SQL: JOINS queries)
├── 06_window_functions.sql (SQL: Advanced Analytical queries)
└── screenshots/ (MySQL Workbench screenshots)
```

---

## The 3-Stage ETL Pipeline I Built

Real data is messy. To handle it properly, I built a 3-stage cleaning pipeline.

### Stage 1: Initial Load (Python)
- File: `load_data_to_mysql.py`
- Loads raw CSV into MySQL
- Cleans column names
- Basic date conversion
- Creates: `startup_funding` table (3,044 rows)

### Stage 2: Deep Cleaning (Python with Regex)
- File: `clean_data_advanced.py`
- Removes URLs from text (like `https://www.wealthbucket.in/`)
- Removes encoding artifacts (`\xc2\xa0` characters)
- Removes hashtags from names (`#DigitalIndia`)
- Removes content inside brackets like `[Anonymous]`
- Removes domain extensions (`.com`, `.in`)
- Handles inconsistent amount formats
- Extracts primary investor from comma-separated lists
- Creates: `startup_funding_v2` table (3,042 rows after removing blank names)

### Stage 3: Standardization (SQL)
- File: `01_data_cleaning.sql`
- Categorizes 500+ messy industry values into 14 clean categories
- Standardizes city names (Bangalore/Bengaluru → "Bangalore")
- Cleans funding stages (Seed/Seed Funding → "Seed")
- Creates: `startup_funding_clean` table (final analysis table)

### Stage 4 (Bonus): Date Repair (SQL)
- File: `00_date_fix.sql`
- Fixed 3,037 date parsing failures from Stage 2
- Used REGEXP and STR_TO_DATE to handle multiple date formats
- Recovered 99.9% of dates (3 remained corrupted)

---

## Important Note: Excel vs SQL Number Differences

During this SQL phase, I noticed some totals differ from my Excel phase analysis. **This is expected and documented for transparency.**

### Example: Bangalore Funding Total

| Phase |     Total    | Deals | Deals with Amount |
|-------|--------------|-------|-------------------|
| Excel | ₹1,77,962 Cr | 855   | 596               |
| SQL   | ₹1,97,155 Cr | 855   | 597               |

### Why the Difference?

1. **NULL handling:** Excel formula used `IFERROR` which treated empty cells as 0. Python deep-cleaning correctly identified undisclosed amounts as NULL. SQL's SUM excludes NULLs.

2. **Amount parsing:** Python's regex-based amount cleaning preserved digit precision that manual Excel cleaning may have truncated.

3. **USD-INR rate:** Tiny variation (Excel used 95.9705, Python used 95.97). Minor impact.

### Which Is Correct?

Both are valid for different purposes:

- **Excel total** = Useful for market sizing (includes estimates)
- **SQL total** = Useful for accurate analysis (verified disclosed amounts only)

For this SQL phase, I use the SQL numbers as source of truth. This represents disclosed funding rather than estimated totals.

This experience taught me that **different cleaning methodologies give different numbers, and the analyst's job is to understand WHY and document clearly**.

---

## Year-Wise Funding Trend

After fixing the date parsing issues (see `00_date_fix.sql`), here are the verified year-by-year totals:

| Year  | Total Deals | Deals with Amount | Total Funding (Cr)  |
|-------|-------------|-------------------|---------------------|
| 2015  | 933         | 655               | ₹1,62,014.56        |
| 2016  | 993         | 586               | ₹36,738.17          |
| 2017  | 687         | 456               | ₹1,00,090.09        |
| 2018  | 309         | 264               | ₹49,099.39          |
| 2019  | 111         | 105               | ₹93,099.72          |
| 2020* | 6           | 6                 | ₹3,716.03           |

**Important:** *2020 data is incomplete because the Kaggle dataset ends in early 2020. This is NOT a real funding crash — it's a dataset limitation. I document this clearly to avoid misleading conclusions.*

### Pattern Observed
- 2015 was the peak year for total disclosed funding
- 2016 saw a dramatic 77% drop in funding (despite more deal count)
- 2017 recovered to near-2015 levels
- 2019 showed strong recovery before the dataset ends

---

## Top 10 Sectors by Total Funding

Verified from SQL analysis:

1. Others (catch-all - documented for transparency)
2. E-Commerce
3. Logistics & Transport
4. Technology
5. FinTech
6. Food & Beverage
7. Fashion & Lifestyle
8. Healthcare
9. Education
10. Travel & Hospitality

The "Others" category contains industry values that didn't match my 14 standard categories. I kept this visible to recruiters as honest documentation rather than hiding it.

---

## Top 10 Lead Investors

By deal count where they were the primary investor:

1. Undisclosed Investors
2. Accel Partners
3. Sequoia Capital
4. Indian Angel Network
5. Kalaari Capital
6. Ratan Tata (yes, personally — he's an active angel)
7. SAIF Partners
8. Blume Ventures
9. Undisclosed Investor (different spelling)
10. Nexus Venture Partners

Indian VC ecosystem is highly active with both institutional firms and individual angels making significant investments.

---

## SQL Skills Demonstrated in This Phase

See `sql_skills_used.md` for the complete list. Highlights:

- All SQL fundamentals (SELECT, WHERE, GROUP BY, ORDER BY, HAVING)
- All JOIN types (INNER, LEFT, RIGHT, SELF)
- Subqueries (correlated and non-correlated)
- Common Table Expressions (CTEs)
- Window Functions (LAG, LEAD, RANK, DENSE_RANK, ROW_NUMBER, SUM OVER, NTILE)
- Aggregate functions with conditional logic
- String functions (TRIM, LOWER, LIKE, REGEXP, REPLACE, SUBSTRING_INDEX)
- Date functions (STR_TO_DATE, YEAR, MONTH, QUARTER, DATE_FORMAT)
- Conditional logic (CASE WHEN with 14+ industry categories)
- CREATE TABLE AS SELECT for derived tables
- Database design (3 tables: raw, cleaned, standardized)
- Python + SQL integration via SQLAlchemy

---

## Problems I Faced and Solved

### Problem 1: 99.84% of Dates Were NULL

After running my Python cleaning script, I checked yearly trends and saw weird results. Only 5 deals in 2015 with ₹32 Cr total — clearly wrong.

**Root cause:** Python's `pd.to_datetime` failed on mixed date formats (15/01/2020, 15-01-2020, 15.01.2020). Most dates became NaT (NULL).

**Solution:** Built `00_date_fix.sql` script that:
1. Standardizes all date separators to slashes first
2. Uses REGEXP to filter only properly formatted dates
3. Uses STR_TO_DATE with `%d/%m/%Y` format
4. Updates year/month/quarter columns

**Result:** Recovered 99.9% of dates (3,039 of 3,042).

This experience taught me: **always verify your cleaning worked** before drawing conclusions. The bug nearly made me publish a Medium article with completely wrong yearly trends.

### Problem 2: MySQL Strict Mode Crashed COALESCE

My first date fix attempt used COALESCE with multiple STR_TO_DATE formats. MySQL's strict mode rejected failed parses instead of trying the next format, crashing the whole query.

**Solution:** Standardize date strings first, then use REGEXP to filter only valid formats before parsing. Much safer approach.

### Problem 3: Bangalore Total Differs from Excel

Initial confusion when SQL showed ₹1,97,155 Cr vs Excel's ₹1,77,962 Cr.

**Investigation:**
- Same deal count (855)
- Different NULL handling between Excel IFERROR (treats as 0) and SQL SUM (excludes NULL)
- Python preserved digit precision Excel may have truncated

**Decision:** Document both numbers honestly. Use SQL for SQL phase, Excel for Excel phase. Don't pretend they match when they don't.

### Problem 4: 500+ Messy Industry Values

The industry_vertical column had values ranging from "FinTech" to "360-degree view creating platform". Required nested CASE WHEN with 14 categories.

**Solution:** Built systematic CASE WHEN with LIKE patterns for each category. Catches keyword variations (e.g., "ecommerce", "e-commerce", "e commerce" all → "E-Commerce").

**Result:** 500+ values → 14 clean categories + "Others" catch-all.

### Problem 5: Hidden Special Characters

Some dates kept showing `\xc2\xa010/7/2015` even after Python cleaning. These are non-breaking space characters that survived multiple cleaning passes.

**Decision:** Left 3 such dates as NULL. Not worth complex fix for 0.1% of data.

---

## Key Lessons from This Phase

1. **Verification beats assumption.** If I hadn't checked yearly totals, I would have published wrong numbers. Always verify before reporting.

2. **Document differences instead of hiding them.** The Excel vs SQL number gap could have been embarrassing. Instead, it became excellent portfolio content showing analyst maturity.

3. **Real data is messy.** No dataset is clean. The cleaning pipeline is more important than the analysis itself.

4. **Build incrementally with backups.** Three tables (raw, cleaned, standardized) meant I could always go back and re-clean without losing work.

5. **SQL beats Excel at scale.** What took hours in Excel formulas runs in seconds in SQL. Window functions especially feel like magic.

6. **Comments save time later.** Heavy comments in SQL files helped me debug issues days later. Future me thanks past me.

---

## How to Use This Project

### To Run the SQL Queries:

1. Install MySQL Workbench
2. Create database: `CREATE DATABASE startup_funding_db;`
3. Install Python libraries: `pip install pandas mysql-connector-python sqlalchemy pymysql`
4. Update password in `load_data_to_mysql.py`
5. Run scripts in this order:
   - `load_data_to_mysql.py` (loads raw data)
   - `clean_data_advanced.py` (deep cleaning)
   - `01_data_cleaning.sql` (SQL standardization)
   - `00_date_fix.sql` (date repair)
   - `02_exploration.sql` (verify everything)

### To Read the Analysis:

- Start with this README for overview
- Read `key_insights.md` for top findings
- Check `sql_skills_used.md` for skills documentation
- Browse SQL files to see actual queries

---

## What's Next

This SQL phase completes Phase 2 of the project. Coming next:

- **Phase 3:** Python EDA with Pandas, Matplotlib, Seaborn for advanced visualizations
- **Phase 4:** Power BI dashboard with DAX measures and interactive filtering

---

## About the Author

**Abishek J** — Aspiring Data Analyst transitioning from Java development.

- LinkedIn: [linkedin.com/in/abishek-j-2a32aa255](https://linkedin.com/in/abishek-j-2a32aa255)
- Email: abishekvja@gmail.com
- Location: Bangalore (Open to Bangalore and Coimbatore roles) & Relocation

---

## Acknowledgments

Built independently as part of self-directed learning. The project is real, the bugs were real, the lessons were real. Every number in this README has been verified against actual SQL query results.

If you find this work useful, please star the parent repository.

If you're a recruiter — I'm actively looking for Junior Data Analyst opportunities. Let's connect.
