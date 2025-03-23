import os
import requests
import logging
import mysql.connector
from dotenv import load_dotenv
from mysql.connector import Error
from requests.auth import HTTPBasicAuth

# Load environment variables
load_dotenv()

# API Configuration
API_USERNAME = os.getenv("OPEN_SKY_USER")
API_PASSWORD = os.getenv("OPEN_SKY_PASS")
API_ENDPOINT = "https://opensky-network.org/api/states/all"

# Database Configuration
DB_CONFIG = {
    'host': os.getenv("DB_HOST"),
    'user': os.getenv("DB_USER"),
    'password': os.getenv("DB_PASSWORD"),
    'database': os.getenv("DB_NAME"),
    'port': os.getenv("DB_PORT", 3306)
}

# Logging Configuration
log_dir = "../logs"
os.makedirs(log_dir, exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(f"{log_dir}/project.log"),
        logging.StreamHandler()
    ]
)

def fetch_api_data():
    """
    Fetches flight data from OpenSky API.
    Returns:
        dict: JSON response from the API.
    """
    try:
        response = requests.get(API_ENDPOINT, auth=HTTPBasicAuth(API_USERNAME, API_PASSWORD), timeout=10)
        response.raise_for_status()
        logging.info("API data fetched successfully.")
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching API data: {e}")
        return {}

def update_or_insert_flight(cursor, flight):
    """
    Performs an upsert on the Flights table.
    Args:
        cursor: MySQL cursor.
        flight (dict): Flight data dictionary.
    """
    flight_number = flight.get('flight_number')
    airline_code = flight.get('airline_code')
    dep_iata = flight.get('departure_iata')
    arr_iata = flight.get('arrival_iata')
    scheduled_departure = flight.get('scheduled_departure')
    actual_departure = flight.get('actual_departure')
    scheduled_arrival = flight.get('scheduled_arrival')
    actual_arrival = flight.get('actual_arrival')
    status = flight.get('status')
    delay_minutes = flight.get('delay_minutes', 0)

    cursor.execute("SELECT airline_id FROM Airlines WHERE IATA_code = %s", (airline_code,))
    airline_row = cursor.fetchone()
    if not airline_row:
        logging.warning(f"Airline with IATA code {airline_code} not found for flight {flight_number}.")
        return
    airline_id = airline_row[0]

    cursor.execute("SELECT airport_id FROM Airports WHERE IATA_code = %s", (dep_iata,))
    dep_row = cursor.fetchone()
    if not dep_row:
        logging.warning(f"Departure airport with IATA code {dep_iata} not found for flight {flight_number}.")
        return
    departure_airport_id = dep_row[0]

    cursor.execute("SELECT airport_id FROM Airports WHERE IATA_code = %s", (arr_iata,))
    arr_row = cursor.fetchone()
    if not arr_row:
        logging.warning(f"Arrival airport with IATA code {arr_iata} not found for flight {flight_number}.")
        return
    arrival_airport_id = arr_row[0]

    upsert_sql = """
    INSERT INTO Flights (
        flight_number, airline_id, departure_airport_id, arrival_airport_id,
        scheduled_departure, actual_departure, scheduled_arrival, actual_arrival,
        status, delay_minutes
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE
        actual_departure = VALUES(actual_departure),
        scheduled_arrival = VALUES(scheduled_arrival),
        actual_arrival = VALUES(actual_arrival),
        status = VALUES(status),
        delay_minutes = VALUES(delay_minutes),
        updated_at = CURRENT_TIMESTAMP;
    """
    cursor.execute(upsert_sql, (
        flight_number, airline_id, departure_airport_id, arrival_airport_id,
        scheduled_departure, actual_departure, scheduled_arrival, actual_arrival,
        status, delay_minutes
    ))
    logging.info(f"Flight {flight_number} upserted successfully.")

def update_database(api_data):
    """
    Connects to the MySQL database and updates flight records.
    Args:
        api_data (dict): JSON data from the API.
    """
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()
        flights = api_data.get('flights', [])
        for flight in flights:
            update_or_insert_flight(cursor, flight)
        connection.commit()
        logging.info("Database updated successfully.")
    except Error as e:
        logging.error(f"MySQL Error: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            logging.info("Database connection closed.")

def main():
    api_data = fetch_api_data()
    if api_data:
        update_database(api_data)

if __name__ == '__main__':
    main()