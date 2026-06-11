"""
Indian Startup Funding - Data Load Script (Version 1)

PURPOSE: Initial data load with basic cleaning
SCOPE: Column names, date conversion, basic amount cleaning
OUTPUT TABLE: startup_funding

NOTE: For deep cleaning (URLs, encoding artifacts, brackets),
      use clean_data_advanced.py (v2) instead.
"""

"""
Load Indian Startup Funding data into MySQL.
This script demonstrates ETL pipeline skills.
"""

import pandas as pd
from sqlalchemy import create_engine
import warnings
warnings.filterwarnings('ignore')

# Replace with your MySQL password
MYSQL_PASSWORD = 'YOUR_PASSWORD_HERE'

# Connection string
engine = create_engine(
    f'mysql+pymysql://root:{MYSQL_PASSWORD}@localhost/startup_funding_db'
)

# Load CSV
print("📥 Loading CSV file...")

df = pd.read_csv(r'C:\Projects\indian-startup-funding\01_data\startup_funding.csv', encoding='utf-8')

print(f"  Loaded {len(df)} rows")

# Rename columns to match SQL schema
df.columns = [
    'sr_no', 'funding_date', 'startup_name', 'industry',
    'sub_vertical', 'city', 'investors_name',
    'investment_type', 'amount_usd', 'remarks'
]

# Load into MySQL
print("⬆️  Uploading to MySQL...")
df.to_sql('startup_funding', con=engine, if_exists='replace', index=False)
print(f"✅ {len(df)} rows loaded into 'startup_funding' table")

# Verify
result = pd.read_sql("SELECT COUNT(*) AS total FROM startup_funding", con=engine)
print(f"\n📊 Verification: {result['total'].iloc[0]} rows in database")
