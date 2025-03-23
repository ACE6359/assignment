-- MySQL Database Schema for EU Flight Project

-- Create database if it doesn't exist and switch to it.
CREATE DATABASE IF NOT EXISTS EU_Flight_Project;
USE EU_Flight_Project;

-- Table: Airports
CREATE TABLE IF NOT EXISTS Airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    IATA_code CHAR(3) UNIQUE NOT NULL,
    ICAO_code CHAR(4) UNIQUE NOT NULL,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    INDEX idx_iata (IATA_code),
    INDEX idx_icao (ICAO_code)
);

-- Table: Airlines
CREATE TABLE IF NOT EXISTS Airlines (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    IATA_code CHAR(2) UNIQUE NOT NULL,
    ICAO_code CHAR(3) UNIQUE NOT NULL
);

-- Table: Flights
CREATE TABLE IF NOT EXISTS Flights (
    flight_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    airline_id INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    scheduled_departure DATETIME NOT NULL,
    actual_departure DATETIME DEFAULT NULL,
    scheduled_arrival DATETIME NOT NULL,
    actual_arrival DATETIME DEFAULT NULL,
    status ENUM('Scheduled', 'Departed', 'Delayed', 'Cancelled', 'Landed') DEFAULT 'Scheduled',
    delay_minutes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id) ON DELETE CASCADE,
    FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id) ON DELETE CASCADE,
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports(airport_id) ON DELETE CASCADE,
    INDEX idx_flight_number (flight_number),
    INDEX idx_status (status)
);

-- Table: Flight_Status_Log
CREATE TABLE IF NOT EXISTS Flight_Status_Log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flight_id BIGINT NOT NULL,
    status ENUM('Scheduled', 'Departed', 'Delayed', 'Cancelled', 'Landed') NOT NULL,
    delay_minutes INT DEFAULT 0,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id) ON DELETE CASCADE,
    INDEX idx_flight (flight_id),
    INDEX idx_log_status (status)
);

-- Create view for flights delayed more than 2 hours.
CREATE OR REPLACE VIEW Delayed_Flights AS
SELECT 
    flight_id, flight_number, airline_id, departure_airport_id, arrival_airport_id, 
    scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, 
    status, delay_minutes 
FROM Flights 
WHERE status = 'Delayed' AND delay_minutes > 120;

-- Trigger: Log flight status changes.
DELIMITER //
CREATE TRIGGER after_flight_update
AFTER UPDATE ON Flights
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status OR NEW.delay_minutes <> OLD.delay_minutes THEN
        INSERT INTO Flight_Status_Log (flight_id, status, delay_minutes)
        VALUES (NEW.flight_id, NEW.status, NEW.delay_minutes);
    END IF;
END//
DELIMITER ;
