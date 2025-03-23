USE EU_Flight_Project;

-- Insert sample airports (German and other European airports).
INSERT INTO Airports (name, IATA_code, ICAO_code, country, city, latitude, longitude) VALUES
('Berlin Brandenburg Airport', 'BER', 'EDDB', 'Germany', 'Berlin', 52.3661, 13.5033),
('Frankfurt Airport', 'FRA', 'EDDF', 'Germany', 'Frankfurt', 50.0333, 8.5706),
('Munich Airport', 'MUC', 'EDDM', 'Germany', 'Munich', 48.3538, 11.7861),
('Hamburg Airport', 'HAM', 'EDDH', 'Germany', 'Hamburg', 53.6304, 9.9882),
('Düsseldorf Airport', 'DUS', 'EDDL', 'Germany', 'Düsseldorf', 51.2895, 6.7668),
('Paris Charles de Gaulle', 'CDG', 'LFPG', 'France', 'Paris', 49.0097, 2.5479),
('Amsterdam Schiphol', 'AMS', 'EHAM', 'Netherlands', 'Amsterdam', 52.3086, 4.7639);

-- Insert sample airlines.
INSERT INTO Airlines (name, IATA_code, ICAO_code) VALUES
('Lufthansa', 'LH', 'DLH'),
('Air France', 'AF', 'AFR'),
('KLM Royal Dutch Airlines', 'KL', 'KLM');

-- Insert sample flights with varied statuses and additional samples.
INSERT INTO Flights (flight_number, airline_id, departure_airport_id, arrival_airport_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, status, delay_minutes) VALUES
('LH100', 1, 1, 2, '2025-04-01 08:00:00', '2025-04-01 08:00:00', '2025-04-01 10:00:00', '2025-04-01 10:00:00', 'Scheduled', 0),
('LH101', 1, 2, 3, '2025-04-01 09:00:00', '2025-04-01 09:45:00', '2025-04-01 11:00:00', '2025-04-01 11:45:00', 'Delayed', 45),
('LH102', 1, 3, 4, '2025-04-01 07:00:00', '2025-04-01 07:00:00', '2025-04-01 09:00:00', '2025-04-01 11:15:00', 'Delayed', 135),
('LH103', 1, 4, 5, '2025-04-01 10:00:00', '2025-04-01 10:05:00', '2025-04-01 12:00:00', '2025-04-01 12:00:00', 'Departed', 5),
('LH104', 1, 5, 1, '2025-04-01 12:00:00', NULL, '2025-04-01 14:00:00', NULL, 'Scheduled', 0),
('AF200', 2, 6, 1, '2025-04-02 06:00:00', '2025-04-02 06:05:00', '2025-04-02 08:00:00', '2025-04-02 08:10:00', 'Departed', 10),
('AF201', 2, 1, 6, '2025-04-02 09:00:00', '2025-04-02 09:30:00', '2025-04-02 11:00:00', '2025-04-02 11:35:00', 'Delayed', 35),
('KL300', 3, 7, 2, '2025-04-03 14:00:00', '2025-04-03 14:00:00', '2025-04-03 16:00:00', '2025-04-03 18:30:00', 'Delayed', 150),
('KL301', 3, 2, 7, '2025-04-03 17:00:00', '2025-04-03 17:05:00', '2025-04-03 19:00:00', '2025-04-03 19:00:00', 'Landed', 0),
('LH105', 1, 1, 3, '2025-04-04 11:00:00', '2025-04-04 11:15:00', '2025-04-04 13:00:00', '2025-04-04 13:15:00', 'Delayed', 15),
('LH106', 1, 3, 5, '2025-04-04 15:00:00', '2025-04-04 15:00:00', '2025-04-04 17:00:00', '2025-04-04 17:00:00', 'Scheduled', 0);
