
import requests
from urllib3 import response
import pandas as pd
import logging


API_KEY = "Ebk1zO37YlnWGoM92OQuAxYrnQPsBxKf9n2nOjMB"
BASE_URL = "https://api.sportradar.com/tennis/trial/v3/en"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

headers = {
    "accept": "application/json",
    "x-api-key": API_KEY
}

# =========================================================
# FETCH COMPETITIONS
# =========================================================

def fetch_competitions():

    url = f"{BASE_URL}/competitions.json"

    try:
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

    logging.info(
        "\nCompetitions Status:",
        response.status_code
    )


# =========================================================
# FETCH COMPLEXES
# =========================================================

def fetch_complexes():

    url = f"{BASE_URL}/complexes.json"

    response = requests.get(
        url,
        headers=headers
    )

    print(
        "\nComplexes Status:",
        response.status_code
    )

    if response.status_code == 200:

        return response.json()

    else:

        print("Error Fetching Complexes")

        return {}


# =========================================================
# FETCH RANKINGS
# =========================================================

def fetch_rankings():
    
    url = f"{BASE_URL}/rankings.json"

    response = requests.get(
        url,
        headers=headers
    )

    print(
        "\nRankings Status:",
        response.status_code
    )

    if response.status_code == 200:

        return response.json()

    else:

        print("Error Fetching Rankings")

        return {}