
DROP DATABASE IF EXISTS RestaurantBookingDemo;

CREATE DATABASE RestaurantBookingDemo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE RestaurantBookingDemo;


CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    CHECK (capacity > 0)
) ENGINE=InnoDB;

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(25) NOT NULL,
    email_address VARCHAR(255) NOT NULL
) ENGINE=InnoDB;



CREATE TABLE staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    CHECK (CHAR_LENGTH(role) > 0)
) ENGINE=InnoDB;


CREATE TABLE dining_tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    table_number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    UNIQUE (restaurant_id, table_number),
    CHECK (capacity > 0)
) ENGINE=InnoDB;




CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    table_id INT NOT NULL,
    booking_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    party_size INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'confirmed',
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (table_id) REFERENCES dining_tables(id),
    CHECK (party_size > 0),
    CHECK (status IN ('confirmed', 'seated', 'completed', 'cancelled'))
) ENGINE=InnoDB;








--FAKE DATA



INSERT INTO restaurants (name, address, capacity) VALUES
('Harbour Kitchen', 'Havnevej 12, 6400 Sonderborg', 60);

INSERT INTO customers (first_name, last_name, phone_number, email_address) VALUES
('Emma', 'Nielsen', '+45 0000 0001', 'emma.nielsen@example.com'),
('Oliver', 'Hansen', '+45 0000 0002', 'oliver.hansen@example.com'),
('Sofia', 'Jensen', '+45 0000 0003', 'sofia.jensen@example.com'),
('Noah', 'Petersen', '+45 0000 0004', 'noah.petersen@example.com');

INSERT INTO staff (restaurant_id, name, role) VALUES
(1, 'Anna Larsen', 'Manager'),
(1, 'Mikkel Holm', 'Waiter'),
(1, 'Freja Madsen', 'Chef');

INSERT INTO dining_tables (restaurant_id, table_number, capacity) VALUES
(1, 'T01', 2), (1, 'T02', 4), (1, 'T03', 6), (1, 'T04', 4), (1, 'T05', 2);

INSERT INTO bookings
(customer_id, table_id, booking_date, reservation_time, party_size, status) VALUES
(1, 2, '2026-10-15', '18:00:00', 3, 'confirmed'),
(2, 2, '2026-10-15', '20:00:00', 4, 'confirmed'),
(3, 1, '2026-10-15', '18:30:00', 2, 'confirmed'),
(1, 3, '2026-10-18', '19:00:00', 5, 'confirmed'),
(4, 4, '2026-10-15', '19:00:00', 4, 'cancelled'),
(1, 1, '2026-10-01', '17:30:00', 2, 'completed');

























-- Query 1:
SELECT id AS table_id, table_number, capacity
FROM dining_tables
WHERE restaurant_id = 1
ORDER BY table_number;

-- Querz 2:
SELECT b.id, b.booking_date, b.reservation_time,
       t.table_number, b.party_size, b.status
FROM bookings AS b
JOIN dining_tables AS t ON b.table_id = t.id
WHERE b.customer_id = 1
ORDER BY b.booking_date, b.reservation_time, b.id;

-- Query 3: 
SELECT b.id, b.booking_date, b.reservation_time,
       c.first_name, c.last_name, c.phone_number,
       b.party_size, b.status
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
WHERE b.table_id = 2 AND b.booking_date = '2026-10-15'
ORDER BY b.reservation_time, b.id;
