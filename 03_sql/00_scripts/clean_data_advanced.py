"""
Indian Startup Funding - Advanced Data Cleaning (Version 2)

PURPOSE: Production-grade data cleaning
SCOPE: Handles URLs, encoding artifacts, brackets, hashtags,
       inconsistent dates, blank values, investor extraction
OUTPUT TABLE: startup_funding_v2

NOTE: This is the recommended cleaning script.
      v1 (load_data_to_mysql.py) is kept for reference only.
"""

"""
Indian Startup Funding - ADVANCED Data Cleaning
Handles: URLs, encoding issues, brackets, hashtags, 
         inconsistent dates, blank values, multiple investors

Author: ABISHEK J
Date: May 2026
"""

import pandas as pd
import numpy as np
import re
import mysql.connector
from sqlalchemy import create_engine, text

# ============================================
# CONFIGURATION
# ============================================

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = 'YOUR_PASSWORD_HERE'  # Replace with your MySQL password
MYSQL_DATABASE = 'startup_funding_db'

CSV_FILE_PATH = r'C:\Projects\indian-startup-funding\01_data\startup_funding.csv'
TABLE_NAME = 'startup_funding_v2'  # New table name
USD_TO_INR_RATE = 95.97

print("=" * 70)
print("INDIAN STARTUP FUNDING - ADVANCED DATA CLEANING")
print("=" * 70)
print()

# ============================================
# STEP 1: LOAD CSV
# ============================================

print("Step 1: Loading CSV file...")
try:
    df = pd.read_csv(CSV_FILE_PATH, encoding='utf-8')
    print(f"✓ Loaded {len(df)} rows")
except UnicodeDecodeError:
    df = pd.read_csv(CSV_FILE_PATH, encoding='latin-1')
    print(f"✓ Loaded {len(df)} rows (with latin-1 encoding)")
print()

# ============================================
# STEP 2: CLEAN COLUMN NAMES
# ============================================

print("Step 2: Cleaning column names...")
df.columns = [col.strip().lower().replace(' ', '_').replace('/', '_') 
              for col in df.columns]
print(f"✓ Column names cleaned")
print()

# ============================================
# STEP 3: ADVANCED TEXT CLEANING FUNCTION
# ============================================

def deep_clean_text(text):
    """
    Comprehensive text cleaning function.
    Handles: encoding issues, URLs, hashtags, brackets, special chars
    """
    if pd.isna(text) or text is None:
        return None
    
    # Convert to string
    text = str(text)
    
    # Remove encoding artifacts (\xc2\xa0 and similar)
    text = text.encode('ascii', 'ignore').decode('ascii')
    
    # Remove URLs (http://, https://, www.)
    text = re.sub(r'http\S+|www\.\S+', '', text)
    
    # Remove hashtags
    text = re.sub(r'#\w+', '', text)
    
    # Remove email addresses
    text = re.sub(r'\S+@\S+', '', text)
    
    # Remove text in square brackets [like this]
    text = re.sub(r'\[.*?\]', '', text)
    
    # Remove text in parentheses (like this)
    text = re.sub(r'\(.*?\)', '', text)
    
    # Remove backslashes
    text = text.replace('\\', '')
    
    # Remove domain extensions
    text = re.sub(r'\.(com|co|in|org|net|io|edu|gov)\S*', '', text, flags=re.IGNORECASE)
    
    # Remove special characters but keep spaces, commas, hyphens
    text = re.sub(r'[^\w\s,\-&\.]', '', text)
    
    # Remove multiple spaces
    text = re.sub(r'\s+', ' ', text)
    
    # Remove leading/trailing whitespace
    text = text.strip()
    
    # Remove leading/trailing commas, hyphens
    text = text.strip(',-')
    text = text.strip()
    
    # Return None if empty after cleaning
    if text == '' or text.lower() in ['nan', 'na', 'n/a', 'none', 'null', 'undisclosed', 'unknown']:
        return None
    
    return text

print("Step 3: Defined deep cleaning function ✓")
print()

# ============================================
# STEP 4: CLEAN ALL TEXT COLUMNS
# ============================================

print("Step 4: Deep cleaning all text columns...")

text_columns = ['startup_name', 'industry_vertical', 'subvertical', 
                'city__location', 'investors_name', 'investmentn_type']

for col in text_columns:
    if col in df.columns:
        print(f"  Cleaning {col}...")
        df[col] = df[col].apply(deep_clean_text)

print(f"✓ All text columns cleaned")
print()

# ============================================
# STEP 5: CLEAN DATE COLUMN (Handle multiple formats)
# ============================================

print("Step 5: Cleaning date column...")

# Rename date column for clarity
date_col = 'date_dd_mm_yyyy' if 'date_dd_mm_yyyy' in df.columns else df.columns[1]
df.rename(columns={date_col: 'funding_date'}, inplace=True)

def clean_date(date_str):
    """Handle inconsistent date formats."""
    if pd.isna(date_str):
        return None
    
    date_str = str(date_str).strip()
    
    # Fix dots to slashes
    date_str = date_str.replace('.', '/')
    
    # Fix double slashes
    date_str = re.sub(r'/+', '/', date_str)
    
    # Remove any non-date characters
    date_str = re.sub(r'[^\d/]', '', date_str)
    
    # Try parsing
    try:
        return pd.to_datetime(date_str, dayfirst=True, errors='coerce')
    except:
        return None

df['funding_date'] = df['funding_date'].apply(clean_date)
print(f"✓ Date column cleaned")
print(f"✓ Valid dates: {df['funding_date'].notna().sum()}")
print(f"✓ Invalid dates: {df['funding_date'].isna().sum()}")
print()

# ============================================
# STEP 6: CLEAN AMOUNT COLUMN
# ============================================

print("Step 6: Cleaning amount column...")

amount_col = 'amount_in_usd' if 'amount_in_usd' in df.columns else 'amount'

def clean_amount(amount_str):
    """Clean amount values - handle commas, N/A, undisclosed, etc."""
    if pd.isna(amount_str):
        return None
    
    amount_str = str(amount_str).strip().lower()
    
    # Mark these as None (missing values)
    invalid_values = ['nan', 'na', 'n/a', 'undisclosed', 'unknown', 
                      'none', 'null', '', '-']
    
    if amount_str in invalid_values:
        return None
    
    # Remove commas
    amount_str = amount_str.replace(',', '')
    
    # Remove $ signs and other currency symbols
    amount_str = re.sub(r'[\$₹£€]', '', amount_str)
    
    # Remove letters
    amount_str = re.sub(r'[a-z]', '', amount_str, flags=re.IGNORECASE)
    
    # Remove anything that isn't a digit or dot
    amount_str = re.sub(r'[^\d.]', '', amount_str)
    
    # Convert to float
    try:
        return float(amount_str)
    except:
        return None

df[amount_col] = df[amount_col].apply(clean_amount)
print(f"✓ Amount column cleaned")
print(f"✓ Valid amounts: {df[amount_col].notna().sum()}")
print(f"✓ Missing amounts: {df[amount_col].isna().sum()}")
print()

# ============================================
# STEP 7: ADD DERIVED COLUMNS
# ============================================

print("Step 7: Adding derived columns...")

# Calculate INR Crore amount
df['amount_crore_inr'] = (df[amount_col] * USD_TO_INR_RATE) / 10000000

# Extract Year and Month
df['funding_year'] = df['funding_date'].dt.year
df['funding_month'] = df['funding_date'].dt.month
df['funding_quarter'] = df['funding_date'].dt.quarter

# Add a "deal_size_category" 
def categorize_deal_size(amount):
    if pd.isna(amount):
        return 'Unknown'
    elif amount < 1:
        return 'Micro (<1 Cr)'
    elif amount < 10:
        return 'Small (1-10 Cr)'
    elif amount < 100:
        return 'Medium (10-100 Cr)'
    elif amount < 1000:
        return 'Large (100-1000 Cr)'
    else:
        return 'Mega (>1000 Cr)'

df['deal_size_category'] = df['amount_crore_inr'].apply(categorize_deal_size)

print(f"✓ Derived columns added: amount_crore_inr, funding_year, funding_month, funding_quarter, deal_size_category")
print()

# ============================================
# STEP 8: HANDLE INVESTORS COLUMN
# ============================================

print("Step 8: Processing investors column...")

def get_primary_investor(investors_str):
    """Extract first investor from comma-separated list."""
    if pd.isna(investors_str) or investors_str is None:
        return 'Undisclosed'
    
    # Split by comma and take first
    first = str(investors_str).split(',')[0].strip()
    
    if first == '' or first.lower() in ['undisclosed', 'unknown', 'na']:
        return 'Undisclosed'
    
    return first

def count_investors(investors_str):
    """Count number of investors."""
    if pd.isna(investors_str) or investors_str is None:
        return 0
    
    investors = str(investors_str).split(',')
    investors = [inv.strip() for inv in investors if inv.strip()]
    return len(investors)

df['primary_investor'] = df['investors_name'].apply(get_primary_investor)
df['investor_count'] = df['investors_name'].apply(count_investors)
df['multiple_investors'] = df['investor_count'].apply(lambda x: 'Yes' if x > 1 else 'No' if x == 1 else 'Unknown')

print(f"✓ Investor columns processed")
print(f"✓ Solo deals: {(df['multiple_investors'] == 'No').sum()}")
print(f"✓ Syndicate deals: {(df['multiple_investors'] == 'Yes').sum()}")
print(f"✓ Unknown: {(df['multiple_investors'] == 'Unknown').sum()}")
print()

# ============================================
# STEP 9: REMOVE BAD ROWS
# ============================================

print("Step 9: Removing bad rows...")
original_count = len(df)

# Remove rows with no startup name
df = df[df['startup_name'].notna() & (df['startup_name'] != '')]

removed = original_count - len(df)
print(f"✓ Removed {removed} rows without startup name")
print(f"✓ Final row count: {len(df)}")
print()

# ============================================
# STEP 10: REPLACE REMAINING NaN WITH NONE
# ============================================

print("Step 10: Final cleanup...")
df = df.replace({np.nan: None})
print(f"✓ NaN values replaced with NULL")
print()

# ============================================
# STEP 11: LOAD INTO MYSQL
# ============================================

print("Step 11: Loading into MySQL...")
try:
    engine = create_engine(
        f'mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}/{MYSQL_DATABASE}'
    )
    
    df.to_sql(
        name=TABLE_NAME,
        con=engine,
        if_exists='replace',
        index=False,
        chunksize=500
    )
    
    print(f"✓ Loaded {len(df)} rows into '{TABLE_NAME}' table")
    print()
except Exception as e:
    print(f"✗ ERROR: {e}")
    exit()

# ============================================
# STEP 12: VERIFY
# ============================================

print("Step 12: Verifying load...")
with engine.connect() as conn:
    # I have passed the f-string query inside the text() function
    result = conn.execute(text(f"SELECT COUNT(*) FROM {TABLE_NAME}")).fetchone()
    print(f"✓ Total rows in MySQL: {result[0]}")
    
    print("\n✓ Sample cleaned data:")
    sample = pd.read_sql(f"SELECT startup_name, city__location, industry_vertical, amount_crore_inr FROM {TABLE_NAME} LIMIT 5", engine)
    print(sample.to_string(index=False))


print()
print("=" * 70)
print("✓ ADVANCED CLEANING COMPLETED!")
print("=" * 70)
print()
print(f"Original CSV rows: ~3044")
print(f"Final clean rows: {len(df)}")
print()
print("Next: Run SQL standardization script for city/industry categorization")
