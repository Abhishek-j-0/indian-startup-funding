# Excel Skills Used in This Project

## Indian Startup Funding Analysis (2015 to 2020)

This is a quick reference of all Excel skills I used in this project. I prepared this file mainly for two reasons:

1. To list the skills clearly when updating my resume
2. To prepare for Excel-related interview questions

If you are a recruiter checking my project, this file will give you a quick overview of what I know in Excel. The full project work and detailed analysis is in the main Excel report file.

---

## Quick Summary

| Skill Category               | Total Skills Used |
|------------------------------|-------------------|
| Data Cleaning Techniques     | 8                 |
| Excel Formulas and Functions | 12                |
| Pivot Table Skills           | 9                 |
| Chart and Visualization      | 7                 |
| Dashboard Building           | 8                 |
| Keyboard Shortcuts           | 15                |
| **Total Skills**             | **59+**           |

---

## Data Cleaning Techniques I Used

These are the cleaning skills I applied while working with messy real world data.

| # | Skill                                                     | Where I Used It                                                           |
|---|-----------------------------------------------------------|---------------------------------------------------------------------------|
| 1 | Find and Replace (Ctrl + H)                               | Cleaning amount column, removing commas, fixing date formats              |
| 2 | Find and Replace with "Match entire cell contents" option | Replacing only exact matches like "Investor" without breaking other words |
| 3 | TRIM function                                             | Removing extra spaces from city and investor names                        |
| 4 | IFERROR function                                          | Wrapping formulas to avoid #N/A and #VALUE errors                         |
| 5 | Go To Special (F5 → Special → Blanks)                     | Finding all blank cells in Primary Investor column at once                |
| 6 | Ctrl + Enter trick                                        | Filling all selected blank cells with "Undisclosed" in one action         |
| 7 | Paste Special (Alt + E + S + V)                           | Converting formulas to values to make file faster                         |
| 8 | Convert to Excel Table (Ctrl + T)                         | Auto-applying filters, alternating row colors, structured references      |

---

## Excel Formulas and Functions I Used

These are the actual formulas I wrote in my project sheets.

### Basic Functions

| # | Function    | What I Used It For                                   |
|---|-------------|------------------------------------------------------|
| 1 | SUM         | Total funding amounts across deals                   |
| 2 | COUNT       | Counting deals in pivot tables                       |
| 3 | COUNTA      | Counting non-blank startup names for Total Deals KPI |
| 4 | AVERAGE     | Calculating average deal size by city                |
| 5 | MAX and MIN | Finding biggest and smallest deals                   |

### Text Functions

| # | Function | What I Used It For                                            |
|---|----------|---------------------------------------------------------------|
| 6 | YEAR     | Extracting year from date column for grouping                 |
| 7 | TEXT     | Formatting dates as text (like "Jan", "Feb")                  |
| 8 | SEARCH   | Finding keywords inside text (like "bang" inside "Bengaluru") |
| 9 | ISNUMBER | Checking if SEARCH found the keyword                          |

### Lookup and Conditional Functions

| #  | Function              | What I Used It For                                                  |
|----|-----------------------|----------------------------------------------------------------------|
| 10 | VLOOKUP               | Joining investor type from another sheet                             |
| 11 | XLOOKUP               | Better version of VLOOKUP, can search left side also                 |
| 12 | Nested IF with SEARCH | Categorizing 500+ industry values into 14 clean groups |

### Counting and Summing with Conditions

| #  | Function                | What I Used It For                                        |
|----|-------------------------|-----------------------------------------------------------|
| 13 | COUNTIF with wildcards  | Counting investor appearances using "*Sequoia*" pattern   |
| 14 | COUNTIFS                | Counting deals with multiple conditions (city + year)     |
| 15 | SUMIF and SUMIFS        | Summing funding amounts by industry, by city              |

### My Most Important Formula

The nested IF + SEARCH formula was the backbone of my data cleaning work. Here is a simplified example:

```excel
=IF(ISNUMBER(SEARCH("bang",F2)),"Bangalore",
IF(ISNUMBER(SEARCH("beng",F2)),"Bangalore",
IF(ISNUMBER(SEARCH("delhi",F2)),"Delhi-NCR",
"Other Cities")))
```

This single formula cleaned 3,000+ city names into 15 clean groups in 5 minutes. Saved me hours of manual work.

---

## Pivot Table Skills

Pivot tables were the heart of my analysis. I built 12+ pivot tables across different sheets.

| # | Pivot Skill                                | Where I Applied It                                    |
|---|--------------------------------------------|-------------------------------------------------------|
| 1 | Creating Pivot Tables from data            | All analysis sheets                                   |
| 2 | Dragging fields to Rows, Values, Filters   | Setting up each pivot                                 |
| 3 | Using Count vs Sum vs Average              | Different metrics in different pivots                 |
| 4 | Value Field Settings                       | Changing default Count to Sum, applying number formats|
| 5 | Sorting Pivot Tables (Largest to Smallest) | Showing top items first                               |
| 6 | Value Filters (Top 10, Greater Than)       | Filtering top 15 investors, hiding zero amounts       |
| 7 | Number formatting inside Pivot             | Adding 1000 separator and decimals                    |
| 8 | Manual Sort option                         | Moving "Undisclosed" and "Others" to bottom of pivots |
| 9 | Refreshing Pivot Tables                    | After data changes                                    |

---

## Chart and Visualization Skills

I built 3 main charts in my dashboard and used different types for different data.

| # | Chart Skill                   | Where I Used It                                                             |
|---|-------------------------------|-----------------------------------------------------------------------------|
| 1 | Line Chart with Markers       | Yearly funding trend (2015 to 2020)                                         |
| 2 | Horizontal Bar Chart          | Top 10 cities by funding (better than column because city names are long)   |
| 3 | Donut Chart                   | Industry distribution (modern alternative to pie chart)                     |
| 4 | Changing chart titles         | All charts customized with clear titles                                     |
| 5 | Adding Data Labels            | Showing values directly on chart points                                     | 
| 6 | Removing gridlines and legend | Cleaner look for dashboard                                                  |
| 7 | Chart Styles                  | Applied consistent blue theme                                               |

### Why I Chose Each Chart Type

- **Line chart for years:** Good for showing trends over time
- **Bar chart for cities:** Horizontal bars handle long city names better than vertical columns
- **Donut chart for industries:** Looks more modern than regular pie chart, also leaves space in middle

---

## Dashboard Building Skills

Building the final dashboard was the most exciting part. Here is what I used.

| # | Skill                                    | Purpose                                                   |
|---|------------------------------------------|-----------------------------------------------------------|
| 1 | Merge and Center                         | Creating big title banner and KPI card sections           |
| 2 | Cell formatting (Fill color, Font color) | Color coding 4 KPI cards (blue, green, orange, purple)    |
| 3 | Custom number formats                    | Showing "₹3.66 Lakh Cr" instead of plain number           |
| 4 | Removing gridlines (View tab)            | Clean dashboard background                                |
| 5 | Direct cell references across sheets     | KPI cards pulling values from analysis sheets             |
| 6 | Inserting Slicers                        | 3 interactive filter buttons (Year, City, Industry)       |
| 7 | Report Connections                       | Connecting one slicer to all pivot tables together        |
| 8 | Conditional Formatting (Data Bars)       | Visual bars inside cells showing comparison               |

---

## Important Keyboard Shortcuts I Learned

These shortcuts saved me a lot of time during the project.

### File and Save

| Shortcut | What It Does                      |
|----------|-----------------------------------|
| Ctrl + S | Save file (used this many times!) |
| Ctrl + Z | Undo last action                  |
| Ctrl + Y | Redo                              |

### Navigation

| Shortcut              | What It Does              |
|-----------------------|---------------------------|
| Ctrl + Home           | Go to cell A1 of sheet    |
| Ctrl + End            | Go to last cell with data |
| Ctrl + Arrow Keys     | Jump to edges of data     |
| Ctrl + A              | Select all data           |
| Ctrl + Page Up / Down | Switch between sheets     |

### Editing

| Shortcut         | What It Does                                |
|------------------|---------------------------------------------|
| Ctrl + C / V / X | Copy / Paste / Cut                          |
| Ctrl + F         | Find                                        |
| Ctrl + H         | Find and Replace (used a lot!)              |
| Ctrl + Enter     | Fill multiple cells with same value at once |
| F2               | Edit selected cell                          |
| Delete           | Clear cell content                          |

### Formatting

| Shortcut         | What It Does             |
|------------------|--------------------------|
| Ctrl + B         | Bold                     |
| Ctrl + I         | Italic                   |
| Ctrl + 1         | Open Format Cells dialog |
| Ctrl + Shift + L | Toggle filters on/off    |

### Special

| Shortcut            | What It Does                              |
|---------------------|-------------------------------------------|
| F5 → Special        | Go To Special (used for selecting blanks) |
| Alt + E + S + V     | Paste Special as Values                   |
| Windows + Shift + S | Take a screenshot                         |

---

## Software and Tools Used

- **Microsoft Excel 365** (Windows 11 laptop)
- **MySQL Workbench** (coming next for SQL phase)
- **Python + Jupyter Notebook** (coming next for Python phase)
- **Power BI Desktop** (coming next for Power BI phase)
- **Windows Snipping Tool** (Win + Shift + S) for screenshots
- **GitHub** for hosting the project files

---

## Topics I Want to Improve Next

I am honest about what I do not know well yet. These are topics I want to learn more about:

1. **Power Query** — For more advanced data transformation
2. **DAX measures in Power Pivot** — Beyond basic pivot tables
3. **Macros and VBA basics** — To automate repetitive tasks
4. **Array formulas** — Dynamic arrays in Excel 365
5. **What-If Analysis tools** — Goal Seek, Solver, Scenario Manager

I plan to learn these step by step. For now, I have built strong foundation in the most-used Excel features for data analyst jobs.

---

## How I Used These Skills in This Project

To give you a concrete picture, here is how the skills came together in the project:

### Stage 1: Data Cleaning (4 days work)
- Used Find and Replace, TRIM, IFERROR for basic cleaning
- Used nested IF + SEARCH to categorize 500+ messy industry values into 14 groups
- Used same technique to clean city names
- Used Go To Special + Ctrl + Enter to fill blanks with "Undisclosed"

### Stage 2: Analysis (2 days work)
- Built 12+ Pivot Tables across Sector, City, and Investor sheets
- Used COUNTIF with wildcards to count investor appearances
- Applied Value Filters to show only Top 15 items
- Used Number Formatting to make amounts readable

### Stage 3: Dashboard (1 day work)
- Created 4 colorful KPI cards using Merge and Center
- Built 3 charts (line, bar, donut) with custom titles
- Added 3 Slicers connected to all pivots using Report Connections
- Applied conditional formatting with Data Bars

Total project time: 7 days of focused work, around 7-8 hours per day.

---

## Common Interview Questions I Can Answer Now

Based on this project work, I am confident answering these questions:

**Q: What is the difference between VLOOKUP and XLOOKUP?**
A: XLOOKUP can search to the left, VLOOKUP cannot. XLOOKUP has simpler syntax without column index numbers. XLOOKUP also handles errors better. But old Excel versions only have VLOOKUP.

**Q: How do you handle messy text data in Excel?**
A: I use a combination of Find and Replace, TRIM for spaces, and nested IF with SEARCH function to categorize messy text into clean groups. ISNUMBER + SEARCH is more reliable than IFERROR + SEARCH.

**Q: What is a Pivot Table?**
A: A Pivot Table is a tool that summarizes large data without writing formulas. You drag fields to Rows, Columns, Values, or Filters to create instant cross-tab reports. Count, Sum, Average, and other functions can be applied to values.

**Q: How do Slicers work?**
A: Slicers are visual filter buttons. When connected to multiple Pivot Tables through Report Connections, clicking one slicer filters all connected pivots at the same time. This creates interactive dashboards.

**Q: What is the difference between SUM and SUMIFS?**
A: SUM adds all values in a range. SUMIFS adds only values that match one or more conditions. For example, SUMIFS can sum funding amount only where city is "Bangalore" and year is 2019.

**Q: How do you make a dashboard look professional?**
A: Remove gridlines for clean background, use consistent color theme, add KPI cards on top with big numbers, place charts logically, add slicers for interactivity, and include section headers to divide areas.

---

## Files in This Project Folder

```
02_excel/
├── README.md (main detailed report)
├── excel_skills_used.md (this file - quick skills reference)
├── startup_funding_analysis.xlsx (main Excel file)
└── screenshots/
    ├── 01_cleaned_data.png
    ├── 02_sector_analysis.png
    ├── 03_city_analysis.png
    ├── 04a_investor_lead.png
    ├── 04b_investor_active.png
    ├── 04c_investor_solo_stage.png
    └── 06_dashboard_full.png
    ├── 06a_dashboard_kpi_cards_lineChart.png
    ├── 06b_dashboard_barChart_slicer.png
    ├── 06c_dashboard_pieChart_insights.png
```

---

## My Contact Details

If you are a recruiter and want to discuss my work or share an opportunity:

- **Name:** Abishek J
- **Email:** abishekvja@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/abishek-j-2a32aa255
- **GitHub:** https://github.com/Abhishek-j-0
- **Medium:** https://medium.com/@abishekvja
- **Location:** open to Bangalore and Coimbatore and relocation


Thank you for reviewing my Excel skills documentation. The full project report and analysis are in the README.md file in this folder.

---

*Last Updated: May 2026*
*Project Status: Excel phase complete, SQL phase next*
