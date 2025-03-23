import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "port":3306,
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
}

API_KEY = os.getenv("Shivachary87@")
API_ENDPOINT = os.getenv("API_ENDPOINT", "https://opensky-network.org/api/states/all")

