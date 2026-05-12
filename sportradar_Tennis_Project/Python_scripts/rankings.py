# ============================================================
# SPORTRADAR DOUBLES COMPETITOR RANKINGS ETL PIPELINE
# ============================================================

import urllib
import requests
from urllib3 import response
import pandas as pd
import logging
from sqlalchemy import create_engine
from datetime import datetime

API_KEY = "Ebk1zO37YlnWGoM92OQuAxYrnQPsBxKf9n2nOjMB"
BASE_URL = "https://api.sportradar.com/tennis/trial/v3/en"

url = f"{BASE_URL}/double_competitors_rankings.json"

headers = {
        "accept": "application/json",
        "x-api-key": API_KEY
    }

# ============================================================
# LOGGING CONFIGURATION
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

logging.info("===== PIPELINE STARTED =====")

try:
    logging.info("Fetching doubles rankings data")
    response = requests.get(
        url,
        headers=headers,
        timeout=30
    )
    response.raise_for_status()  # Raise an exception for HTTP errors

    if response.status_code == 200:
        data = response.json()
    elif response.status_code == 403:
        logging.error("❌ 403 Forbidden → Check API key / access level / quota")
        logging.error(response.text)
    else:
        logging.warning(f"⚠️ Error {response.status_code}")
        logging.warning(response.text)

except Exception as e:
    logging.error(f"API Fetch Failed: {e}")

if data is None:
    logging.error("No data fetched from API")
    exit()

# ============================================================
# PROCESS JSON DATA
# ============================================================

records = []

try:

    rankings = data.get("rankings", [])

    for ranking in rankings:

        # League Information
        league_name = ranking.get("name")
        gender = ranking.get("gender")
        week = ranking.get("week")
        year = ranking.get("year")
        type_id = ranking.get("type_id")

        competitor_rankings = ranking.get(
            "competitor_rankings",
            []
        )

        for comp_rank in competitor_rankings:

            competitor = comp_rank.get(
                "competitor",
                {}
            )

            records.append({

                # League Ranking Info
                "league_name": league_name,
                "gender": gender,
                "week": week,
                "year": year,
                "type_id": type_id,

                # Competitor Ranking Info
                "rank": comp_rank.get("rank"),
                "movement": comp_rank.get("movement"),
                "points": comp_rank.get("points"),
                "competitions_played": comp_rank.get(
                    "competitions_played"
                ),

                # Competitor Details
                "competitor_id": competitor.get("id"),
                "competitor_name": competitor.get("name"),
                "abbreviation": competitor.get("abbreviation"),
                "country": competitor.get("country"),
                "country_code": competitor.get("country_code")
            })

    logging.info("JSON Processing Successful")

except Exception as e:
    logging.error(f"JSON Processing Failed: {e}")
    exit()

# ============================================================
# CREATE DATAFRAME
# ============================================================

df = pd.DataFrame(records)

logging.info(f"Initial Shape: {df.shape}")

# ============================================================
# EMPTY DATAFRAME CHECK
# ============================================================

if df.empty:
    logging.error("No data fetched from API")
    exit()

# ============================================================
# DATA CLEANING
# ============================================================

try:

    # ------------------------------------------------
    # NULL VALUES
    # ------------------------------------------------

    logging.info("\nNull Values:")
    logging.info(df.isnull().sum())

    # ------------------------------------------------
    # DUPLICATES
    # ------------------------------------------------

    duplicate_count = df.duplicated().sum()

    logging.info(f"\nDuplicate Rows: {duplicate_count}")

    df = df.drop_duplicates()

    # ------------------------------------------------
    # DATATYPE CONVERSION
    # ------------------------------------------------

    numeric_cols = [
        "rank",
        "movement",
        "points",
        "competitions_played",
        "week",
        "year",
        "type_id"
    ]

    for col in numeric_cols:
        df[col] = pd.to_numeric(
            df[col],
            errors="coerce"
        )

    # ------------------------------------------------
    # STRING CLEANING
    # ------------------------------------------------

    string_cols = [
        "league_name",
        "gender",
        "competitor_id",
        "competitor_name",
        "abbreviation",
        "country",
        "country_code"
    ]

    for col in string_cols:
        df[col] = (
            df[col]
            .astype(str)
            .str.strip()
        )

    # ------------------------------------------------
    # HANDLE NULLS
    # ------------------------------------------------

    df["movement"] = df["movement"].fillna(0)

    # ------------------------------------------------
    # FINAL INFO
    # ------------------------------------------------

    logging.info("\nFinal Data Types:")
    logging.info(df.dtypes)

    logging.info(f"\nFinal Shape: {df.shape}")

except Exception as e:
    logging.error(f"Data Cleaning Failed: {e}")
    exit()

# ============================================================
# EXPORT TO CSV
# ============================================================

try:

    csv_file = "doubles_competitor_rankings.csv"

    df.to_csv(
        csv_file,
        index=False
    )

    logging.info(f"CSV Exported: {csv_file}")

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

    table_name = "doubles_competitor_rankings"

    df.to_sql(
        table_name,
        engine,
        if_exists="replace",
        index=False,
        chunksize=10000
    )

    logging.info(f"Data Loaded into SQL Table: {table_name}")

except Exception as e:
    logging.error(f"SQL Load Failed: {e}")

# ============================================================
# PIPELINE COMPLETED
# ============================================================

logging.info("===== PIPELINE COMPLETED =====")

