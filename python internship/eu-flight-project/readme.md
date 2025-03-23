# EU Flight Project

This project implements a high-performance flight monitoring system for European flights. It includes:

- **A robust MySQL database schema** for airports, airlines, flights, and real-time status logging.
- **Sample data scripts** to test and demonstrate the system.
- **A Python data ingestion module** that fetches live API data, processes it, and updates the database.
- **Comprehensive documentation** detailing the architecture and design decisions.

## Setup

1. Import the database schema by running `db/db_schema.sql` and then insert sample data with `db/sample_data.sql`.
2. Configure the project by updating credentials in `src/config.py`.
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
