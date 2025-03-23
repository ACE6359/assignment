
---

### **File: docs/architecture.md**

```markdown
# Architecture Document

## Overview

The EU Flight Project is designed for robust, real-time monitoring of European flights. Key features include:

- **Database Layer:** A normalized, highly-indexed MySQL schema for storing airport, airline, flight, and historical flight status data.
- **Data Ingestion Layer:** A Python-based module using best practices in error handling, logging, and database connectivity to fetch and update live flight data.
- **Future Scalability:** Modular design allows for easy extension to a RESTful API, asynchronous data ingestion, and real-time event processing.

## Database Design

- **Airports:** Stores unique airport identifiers, names, and geolocations.
- **Airlines:** Contains airline metadata.
- **Flights:** Captures flight details with automated triggers for logging status changes.
- **Flight_Status_Log:** Maintains historical flight status updates.
- **Delayed_Flights View:** Provides instant access to flights delayed by more than 2 hours.

## Data Ingestion & Processing

- Uses Python’s `requests` and `mysql-connector-python` for reliable API communication.
- Implements upsert logic to ensure data integrity.
- Comprehensive logging and error handling facilitate maintainability and debugging.
