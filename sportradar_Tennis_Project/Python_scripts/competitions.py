# ============================================================
# SPORTRADAR TENNIS COMPETITIONS PIPELINE
# ============================================================


import urllib

import requests
import logging
from urllib3 import response
import pandas as pd
from urllib.parse import quote_plus
from sqlalchemy import create_engine

API_KEY = "Ebk1zO37YlnWGoM92OQuAxYrnQPsBxKf9n2nOjMB"
BASE_URL = "https://api.sportradar.com/tennis/trial/v3/en"

headers = {
        "accept": "application/json",
        "x-api-key": API_KEY
    }

# ============================================================
# LOGGING CONFIGURATION
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logging.info("===== COMPETITIONS PIPELINE STARTED =====")


def fetch_competitions():

    try:
        url = f"{BASE_URL}/competitions.json"
        response = requests.get(url, headers=headers, timeout=30)
        logging.info("Fetching competitions")
        response.raise_for_status()  # Raise an exception for HTTP errors
        if response.status_code == 200:
            return response.json()

        elif response.status_code == 403:
            logging.error("❌ 403 Forbidden → Check API key / access level / quota")
            logging.error(response.text)

        else:
            logging.warning(f"Unexpected Status Code: {response.status_code}")
            logging.warning(response.text)

    except Exception as e:
        logging.error("Exception:", e)

# ============================================================
# FETCH DATA
# ============================================================

competitions_data = fetch_competitions()
if competitions_data is None:

    logging.error("No data fetched from API")

    exit()


# ============================================================
# PROCESS JSON DATA
# ============================================================


try:
    competitions_list = []
    categories_dict = {}   # use dict to avoid duplicates

    for comp in competitions_data.get("competitions", []):
        
        # ---- CATEGORY EXTRACTION ----
        category = comp.get("category", {})
        category_id = category.get("id")

        if category_id:
            categories_dict[category_id] = {
                "category_id": category_id,
                "category_name": category.get("name"),
                "country_code": category.get("country_code")
            }

        # ---- COMPETITION EXTRACTION ----
        competitions_list.append({
            "competition_id": comp.get("id"),
            "competition_name": comp.get("name"),
            "gender": comp.get("gender"),
            "type": comp.get("type"),
            "level": comp.get("level"),
            "parent_id": comp.get("parent_id"),
            "category_id": category_id
        })

    # Convert to DataFrames
    df_categories = pd.DataFrame(categories_dict.values())
    df_competitions = pd.DataFrame(competitions_list)

    logging.info(
        f"Categories Shape: {df_categories.shape}"
    )
    logging.info(
        f"Competitions Shape: {df_competitions.shape}"
    )
except Exception as e:
    logging.error(f"JSON Processing Failed: {e}")
    exit()

# ============================================================
# EMPTY DATAFRAME CHECK
# ============================================================

if df_competitions.empty:

    logging.error("Competitions dataframe is empty")

    exit()

# ============================================================
# DATA CLEANING
# ============================================================

try:

    # ------------------------------------------------
    # NULL and DUPLICATE VALUES CHECK
    # ------------------------------------------------

    logging.info(
        f"Null Values in Categories:\n"
        f"{df_categories.isnull().sum()}"
    )

    logging.info(
        f"Duplicate Values in Categories: "
        f"{df_categories.duplicated().sum()}"
    )
    
    logging.info("\nSample Categories:")
    logging.info(df_categories.head())

    logging.info(
    f"Competitions Shape: "
    f"{df_competitions.shape}"
    )

    logging.info(
        f"Null Values in Competitions:\n"
        f"{df_competitions.isnull().sum()}"
    )

    logging.info(
        f"Duplicate Values in Competitions: "
        f"{df_competitions.duplicated().sum()}"
    )

    logging.info("\nSample Competitions:")
    logging.info(df_competitions.head())

    # ------------------------------------------------
    # REMOVE DUPLICATES
    # ------------------------------------------------
    df_categories = df_categories.drop_duplicates()
    df_competitions = df_competitions.drop_duplicates()

    # ------------------------------------------------
    # HANDLE NULLS
    # ------------------------------------------------
    df_competitions['gender'] = df_competitions['gender'].fillna('unknown')
    df_competitions['level'] = df_competitions['level'].fillna('not_defined')
    df_competitions['type'] = (
        df_competitions['type']
        .fillna('unknown')
    )

    logging.info("Null Values in competitions:", df_competitions.isnull().sum())

    
    # ------------------------------------------------
    # DATATYPE CONVERSION
    # ------------------------------------------------

    category_string_cols = [
        "category_id",
        "category_name",
        "country_code"
    ]

    for col in category_string_cols:

        df_categories[col] = (
            df_categories[col]
            .astype("string")
            .str.strip()
        )

    competition_string_cols = [
        "competition_id",
        "competition_name",
        "gender",
        "type",
        "level",
        "parent_id",
        "category_id"
    ]

    for col in competition_string_cols:

        df_competitions[col] = (
            df_competitions[col]
            .astype("string")
            .str.strip()
        )

    # ------------------------------------------------
    # FOREIGN KEY VALIDATION
    # ------------------------------------------------

    missing_categories = df_competitions[
        ~df_competitions['category_id'].isin(
            df_categories['category_id']
        )
    ]

    logging.info(
        f"Invalid Category Mapping Count: "
        f"{len(missing_categories)}"
    )

    # ------------------------------------------------
    # TOP LEVEL FLAG
    # ------------------------------------------------

    df_competitions['is_top_level'] = (
        df_competitions['parent_id'].isna()
    )

    # ------------------------------------------------
    # FINAL INFO
    # ------------------------------------------------

    logging.info("\nFinal Competition Data Types:")
    logging.info(df_competitions.dtypes)

    logging.info("\nFinal Category Data Types:")
    logging.info(df_categories.dtypes)

except Exception as e:

    logging.error(f"Data Cleaning Failed: {e}")

    exit()


# ============================================================
# EXPORT TO CSV
# ============================================================

try:

    df_competitions.to_csv(
        "competitions.csv",
        index=False
    )

    df_categories.to_csv(
        "categories.csv",
        index=False
    )

    logging.info("CSV Files Exported Successfully")

except Exception as e:

    logging.error(f"CSV Export Failed: {e}")

# ============================================================
# LOAD TO SQL SERVER
# ============================================================

try:
    params = urllib.parse.quote_plus(
        "DRIVER=ODBC Driver 18 for SQL Server;"
        "SERVER=ANIRUDH\\SQLEXPRESS;"
        "DATABASE=SportRadar_Tennis;"
        "Trusted_Connection=yes;"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )

    engine = create_engine(
        f"mssql+pyodbc:///?odbc_connect={params}",
        fast_executemany=True
    )

    # ------------------------------------------------
    # LOAD TABLES
    # ------------------------------------------------

    df_categories.to_sql(
        "categories",
        engine,
        if_exists="replace",
        index=False
    )

    df_competitions.to_sql(
        "competitions",
        engine,
        if_exists="replace",
        index=False
    )
    logging.info(
        "Data Loaded into SQL Server Successfully"
    )

except Exception as e:

    logging.error(f"SQL Load Failed: {e}")

# ============================================================
# PIPELINE COMPLETED
# ============================================================

logging.info(
    "===== COMPETITIONS PIPELINE COMPLETED ====="
)

