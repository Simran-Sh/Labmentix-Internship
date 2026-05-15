import requests
import pyodbc
import logging
import urllib.parse
import pandas as pd
from urllib3 import response
from sqlalchemy import text
from sqlalchemy import create_engine

# =====================================================
# CONFIGURATION
# =====================================================

API_KEY = "Ebk1zO37YlnWGoM92OQuAxYrnQPsBxKf9n2nOjMB"
BASE_URL = "https://api.sportradar.com/tennis/trial/v3/en"

headers = {
        "accept": "application/json",
        "x-api-key": API_KEY
    }

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def fetch_complexes():

    try:
        url = f"{BASE_URL}/complexes.json"
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()  # Raise an exception for HTTP errors
        if response.status_code == 200:
            return response.json()

        elif response.status_code == 403:
            logging.error("❌ 403 Forbidden → Check API key / access level / quota")
            logging.error(response.text)

        else:
            logging.warning(f"⚠️ Error {response.status_code}")
            logging.warning(response.text)

    except Exception as e:
        logging.error("Exception:", e)

complexes_data = fetch_complexes()

# =====================================================
# NORMALIZE DATA
# =====================================================

try:
    records = []

    complexes = complexes_data.get("complexes", [])

    for complex_item in complexes:

        complex_id = complex_item.get("id")
        complex_name = complex_item.get("name")

        venues = complex_item.get("venues", [])

        for venue in venues:

            records.append({
                "complex_id": complex_id,
                "complex_name": complex_name,

                "venue_id": venue.get("id"),
                "venue_name": venue.get("name"),
                "capacity": venue.get("capacity"),
                "city_name": venue.get("city_name"),
                "country_code": venue.get("country_code"),
                "country_name": venue.get("country_name"),
                "map_coordinates": venue.get("map_coordinates"),
                "timezone": venue.get("timezone"),

                "changed": venue.get("changed"),
                "reduced_capacity": venue.get("reduced_capacity"),
                "reduced_capacity_max": venue.get("reduced_capacity_max")
            })

except Exception as e:
    logging.error("Exception during data normalization:", e)

# =====================================================
# CREATE DATAFRAME
# =====================================================

try: 
        
    df = pd.DataFrame(records)

    print("Initial Shape:", df.shape)

    # =====================================================
    # DATA CLEANING
    # =====================================================

    # ---------------------------
    # CHECK NULLS
    # ---------------------------

    logging.info("\nNull Values:")
    logging.info(df.isnull().sum())

    # ---------------------------
    # REMOVE DUPLICATES
    # ---------------------------

    duplicate_count = df.duplicated().sum()
    print("\nDuplicate Rows:", duplicate_count)

    df = df.drop_duplicates()

    # ---------------------------
    # DATATYPE CONVERSION
    # ---------------------------

    df["capacity"] = pd.to_numeric(df["capacity"], errors="coerce")
    df["reduced_capacity_max"] = pd.to_numeric(
        df["reduced_capacity_max"],
        errors="coerce"
    )

    # Boolean cleanup
    bool_cols = ["changed", "reduced_capacity"]

    for col in bool_cols:
        df[col] = df[col].astype("boolean").fillna(False)

    # String cleanup
    string_cols = [
        "complex_id",
        "complex_name",
        "venue_id",
        "venue_name",
        "city_name",
        "country_code",
        "country_name",
        "map_coordinates",
        "timezone"
    ]

    for col in string_cols:
        df[col] = df[col].astype(str).str.strip()

except Exception as e:
    logging.error("Exception during DataFrame creation and cleaning:", e)

# ---------------------------
# FINAL INFO
# ---------------------------
try: 
    print("\nFinal Data Types:")
    print(df.dtypes)

    print("\nFinal Shape:", df.shape)

    # =====================================================
    # EXPORT TO CSV
    # =====================================================

    csv_file = "tennis_complexes.csv"
    df.to_csv(csv_file, index=False)
    print(f"\nCSV Exported: {csv_file}")

except Exception as e:
    logging.error("Exception during final info and CSV export:", e)

# =====================================================
# LOAD TO SQL SERVER (SSMS)
# =====================================================

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

    # Test Connection
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT @@SERVERNAME AS server_name, DB_NAME() AS database_name")
        )
        print(result.fetchone())

    table_name = "tennis_complexes"

    df.to_sql(
        table_name,
        engine,
        if_exists="replace",
        index=False,
        chunksize=10000
    )

    print(f"\nData Loaded into SQL Table: {table_name}")

except Exception as e:
    logging.error("Exception during SQL Server load:", e)