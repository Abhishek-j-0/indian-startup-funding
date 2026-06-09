# Excel Analysis Report

## Indian Startup Funding Project (2015 to 2020)

---

## About This Report

This report is the first part of my Indian Startup Funding Analysis project. Here I have used Microsoft Excel to clean the data, do analysis, and build a dashboard. I am writing this in simple words to explain what I did step by step, what problems I faced, and what I learned. After this Excel work, I will do same data analysis using SQL, Python and Power BI also.

I think this report will be useful for anyone who wants to understand my Excel skills, my way of thinking, and how I approach a real data project.

---

## About The Dataset

I downloaded the dataset from Kaggle. The link is in my main project README. The dataset has information about Indian startup funding from January 2015 to August 2020. It contains around 3000 plus rows of funding deals.

Each row in the dataset tells us:

- Date of funding
- Name of the startup
- Industry vertical
- Sub industry details  
- City where startup is located
- Investor names (sometimes one, sometimes many)
- Investment type or funding stage
- Amount in USD

Total dataset size is around 3,044 deals after cleaning. The biggest year for number of deals was 2015. The year 2020 had less data because dataset stopped at August 2020.

---

## Why I Started With Excel First

Many people directly jump to Python or SQL when they start data analytics. But I thought Excel is also very important for these reasons:

1. Most Indian companies still use Excel for daily reporting work
2. In screening calls, HR people ask Pivot Table and VLOOKUP type questions
3. For small data, Excel is faster than writing Python code
4. By scrolling through the data myself, I can spot bad values quickly
5. Excel teaches me the basics that I will need in all other tools later

So I decided to first finish the Excel part properly before moving to SQL, Python and Power BI.

---

## How The Raw Data Looked When I First Opened It

When I opened the CSV file for the first time, the data was very messy. Some big problems I noticed:

- The Amount column had values with commas inside, like "10,00,000"
- Many rows had "undisclosed" or blank values instead of numbers
- Date column was in mixed format. Some dates had slashes, some had dots
- City names were not consistent. Same city was written in different ways. For example, Bangalore was also written as Bengaluru, sometimes lowercase, sometimes with extra spaces
- Investor column had multiple investor names mixed with commas in one cell
- Industry column had over 500 different values, many of them very similar  
- Funding stage column also had inconsistent values, like "Seed" and "Seed Funding" written differently
- Some words like "Investor" and "Investors" were used as placeholder text instead of real investor names

This was real world messy data. Cleaning all this taught me more than any tutorial could.

---

## Sheet 1: Raw Data Sheet

I kept the original dataset in a sheet called "Raw Data" as backup. I did not touch this sheet. This is a good practice I want to keep in future also, because if I make mistake while cleaning, original data is safe.

I made a copy of this raw data into a new sheet called "Cleaned Data" and worked there.

---

## Sheet 2: Cleaned Data Sheet (Most Important Part)

This is where I spent the most time. Cleaning took me almost half of my total Excel work hours. But it was worth it.

### What I Did Step By Step

**1. Converted to Excel Table**

First thing I did was select all data and press Ctrl plus T to convert into Excel Table. This gave me filter arrows on every column, alternating row colors, and made my pivot tables work better later. I named the table for easy reference.

**2. Cleaning The Amount Column**

I used Find and Replace (Ctrl plus H) many times for this:

- Removed all commas from numbers
- Replaced "undisclosed" with blank
- Removed "N/A" values
- Used IFERROR formula to handle errors safely

After cleaning, I converted text values into proper numbers. Now I can use SUM, AVERAGE on this column without problems.

**3. Adding Amount Crore INR Column**

The original data had amounts in USD dollars. Since this is Indian startup data and Indian people understand Crore better than million, I added a new column called "Amount Crore INR".

I used this formula: take USD amount, multiply by the exchange rate 95.97 (which is current USD to INR rate), then divide by 10000000 to convert into Crore.

I wrapped the formula inside IFERROR so that blank rows do not give errors.

I am proud of this small thing because most freshers would hardcode exchange rate as 80 or 75. Using the actual rate of 95.97 shows attention to detail.

**4. Fixing The Date Column**

The dates were in mixed format. I did these things:

- Used Find and Replace to change dots to slashes  
- Selected the column and pressed Ctrl plus 1 to open Format Cells
- Applied proper date format (dd-mmm-yyyy)
- Created a separate Year column using YEAR formula
- Created a separate Month column using TEXT formula

These extra columns helped me later when I built pivot tables grouped by year and month.

**5. Cleaning The City Column (Big Problem!)**

This was the hardest column. Indian cities were written in many different ways:

- "Bangalore", "Bengaluru", "bangalore" — all same city
- "Delhi", "New Delhi", "Gurgaon", "Gurugram", "Noida", "Faridabad" — all part of Delhi-NCR region
- "Mumbai", "Bombay", "Navi Mumbai" — also same area
- Some cities were written in lowercase, some had extra spaces

I added a new column called "City Clean". I used nested IF with ISNUMBER and SEARCH function. The logic was simple: if the city text contains "bang" or "beng" then put "Bangalore". If it contains "delhi", "gurgaon", "gurugram", "noida", or "faridabad" then put "Delhi-NCR". Like this I made about 15 main city groups.

This reduced messy variations into 15 clean city groups. Now my pivot tables look much better.

**6. Cleaning The Industry Column (Another Big Problem!)**

The Industry column was even worse than the City column. It had over 500 unique values. Some were short like "FinTech" or "Ecommerce", but others were long descriptions like "360-degree view creating platform" or "Auto Rickshaw based Logistics".

I noticed something important after looking carefully. The newer data (2019-2020) had clean short industry names. But the older data (2015-2016) had long descriptions instead of proper industry categories. The Kaggle uploader had collected data over years and format kept changing.

To fix this, I added a new column called "Industry Category". I used the same nested IF technique with SEARCH function. I made about 14 main industry groups:

- E-Commerce
- FinTech
- Technology
- Food and Beverage
- Healthcare
- Education
- Logistics and Transport
- Travel and Hospitality
- Fashion and Lifestyle
- Media and Entertainment
- Agriculture
- Real Estate
- Energy and Environment
- HR and Recruitment
- Others (catch-all for anything else)

This was a turning point in my project. Before this, my pivot tables were showing 500 plus rows of meaningless industry names. After this, they showed only 14 clean groups that make business sense.

**7. Handling Investor Column**

The Investor column had multiple investor names separated by commas in single cells. For example, one cell might have "Sequoia Capital, Accel, Tiger Global, SAIF Partners".

I added two helper columns:

- "Primary Investor" — extracts only the first name from the comma list
- "Multiple Investors" — Yes if more than one investor, No if only one
- "Investor Count" — number of investors per deal

These columns let me analyze who leads deals (Primary Investor) and how many co-investors join each deal.

**8. Cleaning Funding Stage**

Original Funding Stage column had values like "Seed", "Seed Funding", "Seed Round", "seed" — all meaning same thing. I made a "Funding Stage Clean" column that standardized these into proper categories: Seed, Series A, Series B, Series C, Series D, Series E, Private Equity, Other.

**9. Replacing Blanks With "Undisclosed"**

After cleaning, I noticed many cells in Primary Investor and Investor columns were blank. These blanks were confusing my pivot tables. I used Go To Special (press F5) feature, selected Blanks, then typed "Undisclosed" and pressed Ctrl plus Enter. This filled all blank cells with "Undisclosed" at once. Very useful Excel trick.

---

## Sheet 3: Sector Analysis Sheet

After cleaning was done, I started analysis. First was Sector Analysis. I made two pivot tables side by side:

**Pivot 1: Top Industries by Number of Deals**

- Rows: Industry Category
- Values: Count of Startup Name
- Sorted: Largest to Smallest

**Pivot 2: Top Industries by Total Funding**

- Rows: Industry Category  
- Values: Sum of Amount Crore INR
- Sorted: Largest to Smallest
- Number format applied (with commas and 2 decimals)

I added bold titles above each pivot. Used proper headers like "Top 15 Industries" instead of leaving default "Row Labels" text.

I also noticed that "Others" category had 1,485 deals and ₹1,16,322 Crore. It was sitting at the top of pivots which was misleading. I moved "Others" to the bottom of both pivots manually (using right-click and Move to End) so that real top sectors like E-Commerce and FinTech show first. I added a note below explaining what "Others" contains for transparency.

### My Findings From Sector Analysis

- E-Commerce was the top sector by funding with ₹98,314 Cr
- Logistics and Transport came second with ₹47,788 Cr
- Technology came third with ₹36,718 Cr
- Technology had highest number of deals at 638 deals
- FinTech had 111 deals worth ₹34,281 Cr
- Education sector had moderate deals at 56 but reasonable funding

---

## Sheet 4: City Analysis Sheet

I built three pivot tables in this sheet:

**Pivot 1: Top Cities by Number of Deals**

Shows which cities have the most startups getting funded.

**Pivot 2: Top Cities by Total Funding**

Shows which cities attract the most money.

**Pivot 3: Average Deal Size by City**

This was the bonus pivot. I changed Sum to Average in Value Field Settings. It shows which cities get bigger cheques per deal.

### My Findings From City Analysis

- Delhi-NCR had highest number of deals at 903
- But Bangalore had highest total funding at ₹1,77,962 Crore (#1 by money!)
- Mumbai came third with ₹47,522 Cr
- USA-based Indian startups got biggest average deals at ₹963 Crore per deal
- Singapore-based startups also got large average deals
- Coimbatore was in the data with 5 deals worth ₹37 Cr (this excited me because I am looking for jobs in Coimbatore also!)
- Tier-2 cities like Indore, Bhopal, Amritsar appeared but in low numbers

**Bangalore being the funding capital was confirmed by my analysis.** It is truly India's Silicon Valley.

---

## Sheet 5: Investor Analysis Sheet (The Most Detailed One!)

This sheet has 4 different tables because I wanted to look at investors from multiple angles.

**Table 1: Top 15 Lead Investors by Number of Deals**

Pivot table using Primary Investor column. Shows who LEADS the most deals as primary investor.

**Table 2: Top 15 Lead Investors by Total Funding**

Same pivot but sorted by total amount instead of count. Different investors appear at top when sorted by money.

**Table 3: Top 20 Active Investors (Lead + Co-Investment)**

This one I built manually using COUNTIF with wildcards. The formula was simple but powerful:

`=COUNTIF(Investors Column, "*Sequoia*")`

The asterisks are wildcards. This counts how many times "Sequoia" appears anywhere in the Investors column, even if it is one name among many in same cell. I did this for 20 famous investor names.

I added blue data bars to make the count column visually attractive.

**Table 4: Solo Deals vs Syndicate Deals**

This is interesting. I used Multiple Investors column (Yes or No). The pivot shows:

- Solo Deal: 1,680 deals, ₹1,96,791 Cr, average ₹177.77 Cr
- Syndicate Deal: 1,364 deals, ₹1,69,277 Cr, average ₹175.24 Cr

Surprisingly, solo deals and syndicate deals had almost same average size! I expected syndicate deals to be much bigger because more investors usually fund bigger rounds. But the data showed otherwise. Maybe big single investors like Tiger Global and SoftBank write huge cheques alone in late stage deals, balancing out the syndicate effect.

This was an unexpected finding and shows why we should always check data instead of assuming.

**Table 5: Funding Stage Distribution**

Simple pivot showing breakdown by funding stage. Private Equity dominated with ₹2,61,220 Cr from 1,360 deals.

### My Findings From Investor Analysis

- Sequoia Capital appeared in 122 deals total (lead plus co-invest)
- Accel was second most active with 109 deals
- Tiger Global, IDG, Blume, Kalaari, Saif all had strong presence
- Indian Angel Network led 37 deals as primary investor (mostly seed stage)
- Ratan Tata himself led 29 deals personally (he is a famous angel investor)
- Most early stage deals had solo investors, bigger deals had syndicates

The big insight was that **same investor can be lead in one deal and co-investor in another**. So total participation count (Table 2) is always higher than lead count (Table 1). This is normal VC syndication behavior.

---

## Sheet 6: Dashboard Sheet (The Wow Factor!)

This was the final and most exciting sheet to build. I created a single-page interactive dashboard.

### What The Dashboard Has

**Top Banner:**
- Dark blue header with title "INDIAN STARTUP FUNDING DASHBOARD"
- Subtitle showing dataset details
- My name, email, and LinkedIn URL for personal branding

**4 KPI Cards:**

I made 4 colorful boxes showing key numbers:

1. TOTAL DEALS card (Blue theme): Shows 3,044 deals analyzed
2. TOTAL FUNDING card (Green theme): Shows ₹3.66 Lakh Crore
3. TOP SECTOR card (Orange theme): Shows E-Commerce
4. TOP CITY card (Purple theme): Shows Bangalore

For Card 1, I used COUNTA formula counting all startup names.
For Card 2, I used SUM formula with text concatenation.
For Card 3 and 4, I used direct cell references to top row of my sorted pivots in Sector Analysis and City Analysis sheets.

I learned an important lesson here. I first tried complex INDEX MATCH MAX formulas, but they kept showing "Grand Total" or returning errors. After thinking carefully, I realized my pivots are already sorted by amount, so the #1 value is always in a specific cell. Direct cell reference was the simpler and more reliable solution. Sometimes simple is better than complex.

**Charts:**

1. Line Chart - Yearly Funding Trend
- Shows funding amount for each year 2015 to 2020
- Used "Line with Markers" type so each year is a visible dot
- Customized with dark blue line, thicker width, bigger markers

2. Bar Chart - Top 10 Cities by Funding  
- Horizontal bar chart (better than column because city names are long)
- Sorted largest to smallest
- Green color theme

3. Donut Chart - Industry Distribution
- Modern looking pie chart with hole in middle
- Shows percentage labels
- Top 10 industries only (filtered out Others)

**3 Interactive Slicers:**

This is the MAGIC part. I added three slicer buttons:

- Year Slicer
- City Slicer
- Industry Slicer

Then I went to each slicer and used "Report Connections" to connect them to all three pivots that feed my charts.

Now when I click "2019" in the Year slicer, ALL THREE CHARTS update at the same time to show only 2019 data. This is real interactive dashboard behavior, like Power BI! When I showed this to my friend, they were impressed.

**Key Findings Box:**

I added a side panel with bullet points of my main discoveries. This makes the dashboard tell a story, not just show data.

**Footer:**

At bottom I added data source credit, tools used (Excel, SQL, Python, Power BI mentioned), date, and GitHub link.

---

## Main Insights From My Whole Analysis

After finishing all sheets, these are the biggest findings I want to highlight:

1. **Bangalore is the funding capital of India.** It captured ₹1,77,962 Crore funding, which is around 49% of total. This is more than Delhi-NCR, Mumbai and Chennai combined.

2. **Top 20 startups got 65 plus percent of total funding.** Classic Pareto pattern. Big names like Flipkart, Paytm, Ola, OYO, BYJU'S took most of the money. Thousands of small startups shared the remaining 35%.

3. **E-Commerce dominated by total funding.** ₹98,314 Crore went into e-commerce companies. This shows the post-2015 e-commerce boom in India.

4. **Series A had highest deal count, but Private Equity had highest total amount.** Investors do many small bets early, but write huge cheques in late-stage Private Equity rounds.

5. **Median funding is much lower than mean funding.** Mean was around ₹120 Crore, but median was only ₹5 Crore. This big gap shows data is right-skewed because of few mega deals pulling the average up. For honest analysis, we should report median value, not mean.

6. **Solo deals and Syndicate deals have similar average sizes.** This contradicted my initial expectation that syndicates would be bigger. The data taught me to question assumptions.

7. **2017 was a peak year for funding amount.** Total raised was highest in 2017. After that funding cooled down in 2018, then recovered in 2019.

---

## Problems I Faced And How I Solved Them

Not everything was smooth. Some real problems I had during this work:

**1. Excel got very slow with so many formulas**

When I added the nested IF formulas for Industry Category and City Clean, my file slowed down. The formulas were calculating on every change. I solved it by selecting the formula columns and using Paste Special (Alt + E + S + V) to convert formulas into values. After that, file was much faster.

**2. VLOOKUP gave #N/A errors many times**

The reason was extra spaces hidden in lookup values. TRIM function saved me. Now I always use TRIM before any lookup operation.

**3. Excel kept showing "We found a typo" popup for my long formula**

This was very annoying. Excel thought my nested IF formula had a typo and kept trying to "correct" it incorrectly. I learned to always click "No" when Excel offers to fix the formula. My formula was correct, Excel was wrong.

**4. Pivot Table was set to COUNT instead of SUM**

When I dragged Amount Crore INR to Values, Excel auto-set it to Count instead of Sum. Result was all the same numbers in Count and Sum columns. I had to manually go to Value Field Settings and change Count to Sum. After this experience, I always check Value Field Settings to verify the calculation.

**5. "Undisclosed" was showing as #1 lead investor**

My pivot was correctly counting Undisclosed entries (142 deals), but it looked weird at top of leaderboard. I learned about Manual Sort option in pivots. After enabling Manual Sort, I dragged "Undisclosed" to the bottom. It is still visible for transparency, but does not dominate the view.

**6. Slicers were not filtering all charts together**

After adding slicers, only one pivot was responding to the filter. I learned about "Report Connections" feature. After connecting each slicer to all pivots, the interactive dashboard worked properly.

**7. Chart title was hard to edit**

Initially I could not click the title to edit it. The Font Size box stayed grayed out. I learned the "two-click pattern" — first click selects the title as object, second click after a 1 second pause enters edit mode where I can actually type and format.

**8. Numbers showed without comma separators**

This was a small thing but important for professional look. I had to right-click each amount column in pivot, choose Number Format, then check "Use 1000 Separator" and set 2 decimal places.

These small problems looked frustrating at the time but actually they taught me how Excel really works internally.

---

## What I Learned From This Excel Work

Before this project, I only knew basic Excel like SUM, AVERAGE and simple charts. After completing this analysis, I learned many new things. Let me list them by category:

### Data Cleaning Skills

- Find and Replace with "Match entire cell contents" option
- Date formatting using Ctrl plus 1 shortcut
- TRIM function to remove extra spaces  
- IFERROR to handle error values
- Paste Special to convert formulas to values
- Go To Special (F5) to find blanks and fill them in bulk
- Ctrl plus Enter to fill multiple selected cells at once

### Formula And Function Skills

- YEAR and TEXT functions to extract date parts
- Nested IF with SEARCH function for text categorization (this was the biggest skill I built)
- ISNUMBER combined with SEARCH (more reliable than IFERROR with SEARCH)
- VLOOKUP basics for cross-sheet lookups
- COUNTIF and SUMIFS with wildcards (the asterisk star symbol)
- COUNTA for counting non-blank cells

### Analysis Skills

- Pivot Tables (this is must for every data analyst job)
- Slicers for making interactive filters
- Conditional Formatting using Data Bars (blue, green, orange themes)
- Different chart types and when to use each one
- Line chart for time-series data
- Bar chart for category comparison with long names
- Donut chart for showing parts of whole

### Dashboard Building Skills

- Merge and Center for headers and KPI cards
- Removing gridlines for cleaner look
- Using color themes (each KPI card has different color)
- Adding personal branding (my name, email, LinkedIn URL)
- Section headers to divide the dashboard
- Interactive slicers connected to multiple pivots
- Hiding helper pivots so dashboard looks clean

### General Skills

- Always keeping backup of original data
- Naming sheets properly so I can find them easily
- Adding notes and comments for transparency
- Saving file regularly using Ctrl plus S
- Taking multiple screenshots at proper zoom level for documentation

---

## Tools And Environment Used

- Microsoft Excel 365 on Windows laptop
- Screenshots taken using Windows Snipping Tool (Win + Shift + S)
- File saved as .xlsx format
- Backup copy maintained separately

The file size at end was around 2 MB which is reasonable for the amount of analysis done.

---

## What's Next In My Project

Excel part is now done. After this I will analyze the same data using:

**SQL (MySQL Workbench):** For writing queries, joins, CTEs and window functions. This will show I can work with databases.

**Python (Jupyter Notebook):** For deeper analysis using pandas, numpy, matplotlib and seaborn. Will create custom visualizations.

**Power BI:** For making one more professional interactive dashboard. Will use DAX measures and Power Query.

The full project will show that I can use all 4 tools that data analyst jobs require in India.

---

## Final Thoughts

This Excel part took me around 4 to 5 days of full focused work, around 7-8 hours per day. Total around 30 hours of effort.

Excel may look like a simple tool, but when we use it with pivot tables, slicers, conditional formatting, and proper formulas, it becomes very powerful. The interactive dashboard at the end especially gives me confidence. If someone gives me messy real-world data tomorrow at work, I now know I can clean it, analyze it, and make a presentable dashboard within a day.

The biggest learning is that **data analysis is 80% cleaning and 20% actual analysis.** Most of my time went in cleaning the Industry column, City column, and Investor column. Once data was clean, the analysis part was much faster.

I am thankful to my own dedication and patience to finish this. Looking forward to learning SQL next!

If anyone has feedback or suggestions, please connect with me on LinkedIn. The link is in my main project README.

Thank you for reading.

---

## Files And Folder Structure

```
indian-startup-funding/
├── 02_excel/
│   ├── startup_funding_analysis.xlsx (Main Excel file)
│   ├── Excel_Analysis_Report.md (This report)
│   └── screenshots/
│       ├── 01_cleaned_data.png
│       ├── 02_sector_analysis.png
│       ├── 03_city_analysis.png
│       ├── 04a_investor_lead.png
│       ├── 04b_investor_active.png
│       ├── 04c_investor_solo_stage.png
│       ├── 06_dashboard_full.png
│       └── 06_dashboard_slicer_demo.gif
```

---

**Project:** Indian Startup Funding Analysis (2015-2020)  
**Tool Used:** Microsoft Excel  
**Created by:** Abishek J  
**Email:** abishekvja@gmail.com  
**LinkedIn:** linkedin.com/in/abishek-j-2a32aa255  
**Date Completed:** May 2026  
**GitHub:** [Add your GitHub link here when you upload]  

---

*Next coming up: SQL analysis of the same dataset using MySQL.*
