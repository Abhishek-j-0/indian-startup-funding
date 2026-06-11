# Key Insights from SQL Analysis

## Indian Startup Funding Project (2015-2020)

This document contains my key findings from the SQL phase of the project. All numbers below are verified from actual SQL query results.

---

## Important Methodology Note

All numbers in this document represent **disclosed funding only**. The dataset has 3,042 total deals but only 2,075 (68%) had disclosed amounts. The remaining 967 deals were marked "undisclosed" in the source data.

I chose to exclude NULLs from SUM calculations (standard SQL behavior) rather than treat them as zero. This means my SQL totals differ from my Excel phase totals, where IFERROR formulas treated empty cells as zero.

See main README for detailed methodology comparison.

---

## Insight #1: Total Disclosed Funding Was ₹4.45 Lakh Crore

Across 6 years (2015 to early 2020):

- **3,042 total deals** analyzed
- **2,075 deals** had disclosed amounts (68%)
- **967 deals** had undisclosed amounts (32%)
- **₹4,45,021 Cr** total disclosed funding
- **₹214 Cr** average deal size

The 32% undisclosed rate is significant. Indian investors often keep small early-stage rounds private, only announcing the headline. This affects how we should interpret market sizing.

---

## Insight #2: 2015 Was the Peak Funding Year

Year-by-year totals (verified):

| Year | Deals | Deals with Amount | Total Funding (Cr) |
|------|-------|-------------------|---------------------|
| 2015 | 933 | 655 | ₹1,62,014 |
| 2016 | 993 | 586 | ₹36,738 |
| 2017 | 687 | 456 | ₹1,00,090 |
| 2018 | 309 | 264 | ₹49,099 |
| 2019 | 111 | 105 | ₹93,100 |
| 2020 | 6 | 6 | ₹3,716 |

**2015 was the absolute peak** with ₹1,62,014 Cr in disclosed funding.

This is interesting because Indian startup funding is often associated with 2017-2018 boom years. But this dataset shows 2015 had the highest total disclosed funding, driven likely by mega deals in e-commerce.

**Note on 2020:** Only 6 deals in 2020 because the dataset ends in early 2020. This is NOT a real funding crash — it's a dataset limitation. I document this clearly to avoid misleading conclusions.

---

## Insight #3: The 2016 Funding Crash

Looking at year-over-year changes:

- **2015 to 2016:** Down 77% (₹1,62,014 → ₹36,738 Cr)
- **2016 to 2017:** Up 172% (₹36,738 → ₹1,00,090 Cr)
- **2017 to 2018:** Down 51% (₹1,00,090 → ₹49,099 Cr)
- **2018 to 2019:** Up 90% (₹49,099 → ₹93,100 Cr)

2016 saw a dramatic 77% drop in funding despite slightly more deal count (993 vs 933 in 2015).

**What likely happened:** Investors moved to smaller deals in 2016. Same number of bets, smaller checks. This is the classic "correction year" pattern after a hot funding cycle.

The recovery in 2017 was driven by larger deals, not more deals (only 687 deals but recovered to ₹1,00,090 Cr).

---

## Insight #4: Bangalore Is the Funding Capital

City-wise distribution shows extreme concentration:

- **Bangalore:** 855 deals, ₹1,97,155 Cr (the funding capital)
- The next cities (Delhi-NCR, Mumbai) come well behind
- Bangalore alone captures roughly 44% of total disclosed funding

For context: One city captures nearly half of an entire country's startup funding. This is the most concentrated startup ecosystem in any major economy.

---

## Insight #5: Top 10 Sectors Show E-Commerce Dominance

Top sectors by deal volume:

1. Others (catch-all category)
2. E-Commerce
3. Logistics & Transport
4. Technology
5. FinTech
6. Food & Beverage
7. Fashion & Lifestyle
8. Healthcare
9. Education
10. Travel & Hospitality

**E-Commerce led non-Others categories.** This makes business sense — Indian e-commerce boom (Flipkart, Snapdeal, Myntra, Nykaa) attracted massive funding in this period.

Note: "Others" being top is honest reporting. It contains industries that didn't fit my 14 standard categories. A junior analyst might hide this. I kept it visible to show transparency.

---

## Insight #6: Top 10 Lead Investors Reveal VC Concentration

Top investors by deal count (as primary investor):

1. Undisclosed Investors (many anonymous deals)
2. Accel Partners
3. Sequoia Capital
4. Indian Angel Network
5. Kalaari Capital
6. Ratan Tata (yes, personally)
7. SAIF Partners
8. Blume Ventures
9. Undisclosed Investor (variation)
10. Nexus Venture Partners

**Interesting findings:**

- Two "Undisclosed Investor" entries appear, suggesting different data entry styles
- Ratan Tata personally appears in top 10 — he's one of India's most active angel investors
- Indian Angel Network appears prominently, showing strength of angel ecosystem
- Top 4 VC firms (Accel, Sequoia, Kalaari, SAIF) dominate institutional funding

---

## Insight #7: VC Co-Investment Patterns Exist

Window function analysis revealed specific co-investment patterns:

When analyzing which investors frequently appear together in the same deals:
- Sequoia and Accel often co-invest
- Tiger Global appears alongside multiple Indian VCs
- Indian Angel Network commonly leads with co-investors joining later
- Ratan Tata often co-invests with institutional VCs

**Why this matters:**

Indian VC behavior favors syndication. Big firms rarely lead alone in big rounds — they bring in 2-3 co-investors to share risk. This is different from US VC patterns where solo leads are more common.

---

## Insight #8: 32% of Deals Don't Disclose Amounts

A surprising data quality finding:

- 3,042 total deals
- 967 had no disclosed amount (32%)
- 2,075 had disclosed amounts (68%)

**What this means for analysis:**

When you see headlines like "India raised $X billion in startups in 2015", that's based on disclosed amounts only. The real total is probably higher because nearly 1/3 of deals stayed private.

This is important context for any market sizing work.

---

## Insight #9: Excel vs SQL Numbers Differ — Here's Why

One of my most important learnings:

| Metric | Excel | SQL | Difference |
|--------|-------|-----|------------|
| Bangalore Total | ₹1,77,962 Cr | ₹1,97,155 Cr | +11% in SQL |
| Bangalore Deals with Amount | 596 | 597 | +1 deal |

**Causes:**

1. Excel formula `IFERROR(...,0)` treats failed conversions as 0
2. Python deep cleaning correctly marks failed amounts as NULL
3. SQL SUM excludes NULL, Excel SUM includes 0s
4. Slight USD-INR rate variation (95.9705 vs 95.97)

**My takeaway:** Different cleaning methodologies produce different results. The analyst's job is to understand WHY and document it clearly, not to hide discrepancies.

This experience taught me to never publish numbers without understanding their methodology.

---

## Insight #10: Real Data Has Real Problems

Throughout the project, I encountered specific data quality issues that aren't covered in tutorials:

**Issues found and handled:**

1. **URLs in startup names:** `WealthBucket https://www.wealthbucket.in/`
2. **Encoding artifacts:** `\xc2\xa0Nudgespot` (non-breaking space leftovers)
3. **Hashtags in text:** `Startup #DigitalIndia`
4. **Bracketed content:** `[Anonymous]` or `[Series A]`
5. **Mixed date formats:** 15/01/2015, 15.01.2015, 15-01-2015
6. **Multiple amount placeholders:** "N/A", "undisclosed", "unknown", "-"
7. **Domain extensions:** `.com`, `.in`, `.co` mixed in names
8. **Backslash artifacts:** `\\` characters surviving cleaning
9. **Parentheses content:** `1mg (Healthkartplus)`
10. **Multiple investors in one cell:** `Sequoia, Accel, Tiger Global, [Anonymous]`

**My approach:**

Built a 3-stage cleaning pipeline (Python regex + SQL standardization) to handle each issue systematically. The cleaning code is more lines than the analysis code. **That's normal for real data work.**

---

## Bonus Insight: Date Parsing Almost Killed My Project

A near-disaster I caught at the last minute:

After running my "advanced cleaning" Python script, I checked yearly trends and saw:

- 2015: Only 5 deals
- All other years: Showing weird numbers

**Investigation revealed:** 99.84% of my dates were NULL because `pd.to_datetime` failed on mixed formats.

If I had skipped verification, I would have:
- Published a Medium article with wrong yearly trends
- Posted on LinkedIn with incorrect numbers
- Sent recruiters to a GitHub showing broken data

**The fix:** Built `00_date_fix.sql` script using REGEXP + STR_TO_DATE to recover 99.9% of dates.

**The lesson:** Verification beats assumption. Every. Single. Time.

This experience will go into my Medium article as a real story about what can go wrong in data projects.

---

## Comparison: SQL vs Excel Findings

How do my SQL conclusions compare with my Excel phase findings?

### Aligned findings:
- Bangalore is the funding capital (both confirm)
- E-Commerce is a dominant sector (both confirm)
- VC syndication is common in India (both confirm)
- Indian Angel Network is highly active (both confirm)

### Different numbers (same direction):
- Total funding amounts differ due to NULL handling
- Yearly trends differ slightly due to date parsing differences
- Bangalore total differs (₹1,77,962 vs ₹1,97,155)

### New insights from SQL:
- Quantified the 77% crash from 2015 to 2016
- Identified the 32% undisclosed rate as significant
- Calculated specific YoY growth percentages
- Found co-investor patterns using window functions

**Conclusion:** Different tools reveal different things. SQL gave me deeper analytical capabilities Excel couldn't match for time-series analysis.

---

## What This Project Taught Me

Beyond technical skills, this project taught me:

1. **Patience with messy data is a skill.** Most tutorials use clean datasets. Real work doesn't.

2. **Documentation prevents disasters.** Heavy SQL comments saved me when debugging issues days later.

3. **Verification is non-negotiable.** Always check your data before drawing conclusions. The date parsing issue would have ruined my project credibility.

4. **Transparency beats perfection.** Showing methodological differences (Excel vs SQL) is more impressive than hiding them.

5. **SQL beats Excel for scale and reproducibility.** Anyone can re-run my SQL scripts and get the same results. Excel work is harder to reproduce.

6. **Comments and READMEs matter.** Future-me will thank past-me for documenting properly.

---

## What's Next

The SQL phase is complete. Phase 3 (Python) will:

- Visualize these insights using Matplotlib and Seaborn
- Run statistical tests on the patterns
- Calculate correlation between variables
- Build a Jupyter Notebook for interactive analysis

Phase 4 (Power BI) will:

- Turn these insights into an interactive dashboard
- Build drill-through pages for deeper exploration
- Create a mobile-friendly version
- Final portfolio piece

---

## Contact

**Abishek J**

- Email: abishekvja@gmail.com
- LinkedIn: [linkedin.com/in/abishek-j-2a32aa255](https://linkedin.com/in/abishek-j-2a32aa255)
- Location: Bangalore (open to coimbatore & chennai opportunities) & Relocation

If you're a recruiter and want to discuss any of these insights or my SQL skills, please reach out.

---

*All numbers verified from SQL query results. Document last updated: May 2026.*
