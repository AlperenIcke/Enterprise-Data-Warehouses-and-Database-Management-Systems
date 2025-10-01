
CREATE DATABASE IF NOT EXISTS TelecomDB;
USE TelecomDB;

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    join_date DATE NOT NULL
);

-- 2. ServiceTypes Table
CREATE TABLE ServiceTypes (
    service_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE, 
    description TEXT
);

-- 3. Plans Table
CREATE TABLE Plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    monthly_cost DECIMAL(10, 2) NOT NULL,
    data_allowance_gb INT,
    voice_minutes INT,
    service_type_id INT,
    FOREIGN KEY (service_type_id) REFERENCES ServiceTypes(service_type_id)
);

-- 4. Devices Table
CREATE TABLE Devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer VARCHAR(50),
    model VARCHAR(100) NOT NULL
);

-- 5. Invoices Table
CREATE TABLE Invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Paid', 'Unpaid', 'Overdue') NOT NULL DEFAULT 'Unpaid',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE SET NULL
);

-- 6. Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50), 
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id) ON DELETE CASCADE
);

-- 7. CallRecords Table
CREATE TABLE CallRecords (
    call_id INT AUTO_INCREMENT PRIMARY KEY,
    caller_customer_id INT,
    receiver_phone_number VARCHAR(20),
    call_date DATETIME NOT NULL,
    duration_seconds INT,
    FOREIGN KEY (caller_customer_id) REFERENCES Customers(customer_id)
);

-- 8. DataUsage Table
CREATE TABLE DataUsage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    usage_date DATE NOT NULL,
    data_used_mb DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 9. Employees Table
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(100),
    hire_date DATE
);

-- 10. SupportTickets Table
CREATE TABLE SupportTickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    date_created DATETIME NOT NULL,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 11. CellTowers Table
CREATE TABLE CellTowers (
    tower_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255) NOT NULL,
    activation_date DATE,
    technology VARCHAR(20) 
);

-- Junction Tables for Many-to-Many Relationships 
-- CustomerPlans Table
CREATE TABLE CustomerPlans (
    customer_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    plan_id INT,
    subscription_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id)
);

-- CustomerDevices Table
CREATE TABLE CustomerDevices (
    customer_device_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    device_id INT,
    purchase_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

-- InvoiceDetails Table
CREATE TABLE InvoiceDetails (
    invoice_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    service_type_id INT,
    charge_description VARCHAR(255),
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (service_type_id) REFERENCES ServiceTypes(service_type_id)
);

-- TicketAssignments Table
CREATE TABLE TicketAssignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    employee_id INT,
    assigned_at DATETIME,
    FOREIGN KEY (ticket_id) REFERENCES SupportTickets(ticket_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


-- Performance Indexes
CREATE INDEX idx_customer_email ON Customers(email);
CREATE INDEX idx_call_date ON CallRecords(call_date);

-- Main Tables Inserts
INSERT INTO Customers (first_name, last_name, email, phone_number, address, join_date) VALUES
('Klaus', 'Schmidt', 'klaus.schmidt@email.de', '+49 176 12345678', 'Munich', '2022-03-15'),
('Fatma', 'Yılmaz', 'f.yilmaz@email.com', '+49 152 23456789', 'Cologne', '2023-08-21'),
('Lukas', 'Jankowski', 'lukas.j@email.pl', '+49 174 34567890', 'Frankfurt', '2021-11-05'),
('Chiamaka', 'Adebayo', 'c.adebayo@email.ng', '+49 163 45678901', 'Hamburg', '2024-01-30'),
('Sophie', 'Dubois', 'sophie.dubois@email.fr', '+49 176 56789012', 'Stuttgart', '2022-07-11'),
('Emir', 'Çelik', 'emir.celik@email.com.tr', '+49 157 67890123', 'Düsseldorf', '2023-09-01'),
('Maria', 'Rossi', 'maria.r@email.it', '+49 179 78901234', 'Leipzig', '2020-05-18'),
('David', 'Chen', 'david.chen@email.cn', '+49 151 89012345', 'Hanover', '2024-02-14'),
('Anna', 'Müller', 'anna.muller@email.de', '+49 176 90123456', 'Nuremberg', '2021-01-25'),
('Alejandro', 'García', 'a.garcia@email.es', '+49 162 01234567', 'Bremen', '2023-12-07');

INSERT INTO ServiceTypes (type_name, description) VALUES
('Mobile Plans', 'Standard voice and data services for smartphones and tablets.'),
('Fiber Broadband', 'High-speed fiber optic internet for residential customers.'),
('Business Solutions', 'Dedicated internet access and enterprise network solutions for companies.'),
('IPTV Services', 'Television services delivered over an internet protocol network.'),
('VoIP Telephony', 'Voice over IP services for home and business landline replacements.'),
('Cloud Storage', 'Secure online storage solutions for personal or business data backup.'),
('IoT Connectivity', 'Data plans and network access for Internet of Things devices.'),
('Cybersecurity Suite', 'Antivirus, firewall, and VPN services for protecting customer devices.'),
('Smart Home Packages', 'Bundled services for connecting and managing smart home devices.'),
('Prepaid SIM Cards', 'Pay-as-you-go mobile services without a long-term contract.');

INSERT INTO Plans (plan_name, monthly_cost, data_allowance_gb, voice_minutes, service_type_id) VALUES
('Basic Mobile', 9.99, 5, 200, 1),
('Unlimited Mobile Max', 39.99, 50, 1000, 1),
('Fiber 100', 29.99, 40, 1000, 2),
('Fiber 500 Gigabit', 49.99, 60, 2000, 2),
('Business Pro 1G', 79.99, 80, 2000, 3),
('Home TV & Stream', 14.99, 30, 1000, 4),
('Cloud Backup 1TB', 7.99, 20, 1000, 6),
('IoT Starter', 4.99, 10, 500, 7),
('Family Secure Pack', 12.99, 15, 1000, 8),
('Prepaid Freedom', 15.00, 20, 1000, 10);

INSERT INTO Devices (manufacturer, model) VALUES
('Apple', 'iPhone 15 Pro'),
('Samsung', 'Galaxy S24 Ultra'),
('Google', 'Pixel 8'),
('Xiaomi', '13T Pro'),
('OnePlus', '11'),
('Apple', 'iPad Air (M2)'),
('Samsung', 'Galaxy Tab S9'),
('Netgear', 'Nighthawk M6 Pro (Mobile Hotspot)'),
('AVM', 'FRITZ!Box 7590 AX (Router)'),
('Apple', 'iPhone 14');

INSERT INTO Invoices (customer_id, invoice_date, due_date, total_amount, status) VALUES
(1, '2025-09-01', '2025-09-21', 39.99, 'Paid'),      
(2, '2025-09-02', '2025-09-22', 29.99, 'Unpaid'),    
(3, '2025-08-15', '2025-09-04', 9.99, 'Overdue'),    
(4, '2025-09-05', '2025-09-25', 49.99, 'Unpaid'),    
(5, '2025-09-08', '2025-09-28', 14.99, 'Unpaid'),    
(6, '2025-08-20', '2025-09-10', 79.99, 'Paid'),      
(7, '2025-09-10', '2025-09-30', 7.99, 'Unpaid'),     
(1, '2025-08-01', '2025-08-21', 47.98, 'Paid'),      
(2, '2025-08-02', '2025-08-22', 29.99, 'Paid'),      
(8, '2025-09-12', '2025-10-02', 12.99, 'Unpaid');    

INSERT INTO Payments (invoice_id, payment_date, amount, payment_method) VALUES
(1, '2025-09-10 11:30:00', 39.99, 'Credit Card'),
(6, '2025-09-08 09:00:00', 79.99, 'Bank Transfer'),
(8, '2025-08-15 16:45:00', 47.98, 'PayPal'),
(9, '2025-08-18 10:00:00', 29.99, 'Credit Card');

-- Junction Tables Inserts
INSERT INTO CustomerPlans (customer_id, plan_id, subscription_date) VALUES
(1, 2, '2022-03-15'),  
(2, 3, '2023-08-21'),  
(3, 1, '2021-11-05'),  
(4, 4, '2024-01-30'),  
(5, 6, '2022-07-11'),  
(6, 5, '2023-09-01'),  
(7, 7, '2020-05-18'),  
(8, 9, '2024-02-14'),  
(1, 7, '2024-05-01'),  
(10, 10, '2023-12-07'),
(2, 1, '2024-03-01');

INSERT INTO InvoiceDetails (invoice_id, service_type_id, charge_description, amount) VALUES
(1, 1, 'Unlimited Mobile Max Monthly Fee', 39.99),
(2, 2, 'Fiber 100 Monthly Fee', 29.99),
(3, 1, 'Basic Mobile Monthly Fee', 9.99),
(4, 2, 'Fiber 500 Gigabit Monthly Fee', 49.99),
(5, 4, 'Home TV & Stream Monthly Fee', 14.99),
(6, 3, 'Business Pro 1G Monthly Fee', 79.99),
(7, 6, 'Cloud Backup 1TB Monthly Fee', 7.99),
(8, 1, 'Unlimited Mobile Max Monthly Fee', 39.99), -- First part of invoice #8
(8, 6, 'Cloud Backup 1TB Monthly Fee', 7.99),      -- Second part of invoice #8
(9, 2, 'Fiber 100 Monthly Fee', 29.99),
(10, 8, 'Family Secure Pack Monthly Fee', 12.99);

INSERT INTO CallRecords (caller_customer_id, receiver_phone_number, call_date, duration_seconds) VALUES
(1, '+49 176 98765432', '2025-09-24 10:15:00', 120),
(3, '+49 152 87654321', '2025-09-24 11:05:00', 345),
(1, '+49 174 76543210', '2025-09-23 18:30:00', 85),
(6, '+49 157 65432109', '2025-09-23 09:00:00', 610),
(10, '+49 162 54321098', '2025-09-22 14:22:00', 45);

INSERT INTO CellTowers (location, activation_date, technology) VALUES
('Berlin-Mitte, Brandenburg Gate', '2022-01-10', '5G'),
('Munich-Schwabing, Englischer Garten', '2021-06-15', '5G'),
('Hamburg-HafenCity, Elbphilharmonie', '2022-05-20', '5G'),
('Frankfurt-Westend, Messeturm', '2020-11-01', '4G'),
('Cologne-Ehrenfeld, Venloer Str.', '2023-03-30', '5G');

INSERT INTO CustomerDevices (customer_id, device_id, purchase_date) VALUES
(1, 1, '2023-09-20'),
(2, 9, '2023-08-21'),
(3, 3, '2023-10-15'),
(4, 9, '2024-01-30'),
(1, 6, '2024-03-10'),
(2, 1, '2024-03-01');

INSERT INTO DataUsage (customer_id, usage_date, data_used_mb) VALUES
(1, '2025-09-24', 850.50),
(3, '2025-09-24', 220.75),
(2, '2025-09-24', 15360.00),
(1, '2025-09-23', 1230.20),
(4, '2025-09-23', 25600.80),
(1, '2025-08-05', 1150.70),
(2, '2025-08-10', 14320.50),
(3, '2025-08-15', 190.25),
(4, '2025-08-20', 22500.00),
(1, '2025-07-08', 980.00),
(2, '2025-07-12', 13500.00),
(3, '2025-07-18', 250.60),
(4, '2025-07-25', 21000.40),
(1, '2025-06-05', 950.00),
(2, '2025-06-11', 12500.50),
(3, '2025-06-18', 180.75),
(4, '2025-06-22', 20500.00),
(1, '2025-07-08', 980.00),
(2, '2025-07-12', 13500.00),
(3, '2025-07-18', 250.60),
(4, '2025-07-25', 21000.40),
(1, '2025-08-05', 1150.70),
(2, '2025-08-10', 14320.50),
(3, '2025-08-15', 190.25),
(4, '2025-08-20', 22500.00);

INSERT INTO Employees (first_name, last_name, job_title, hire_date) VALUES
('Sabine', 'Weber', 'Customer Support Agent', '2022-02-01'),
('Felix', 'Hoffmann', 'Technical Support Specialist', '2021-08-15'),
('Lena', 'Bauer', 'Team Lead, Customer Care', '2019-05-20'),
('Tom', 'Ziegler', 'Network Engineer', '2023-01-10'),
('Jonas', 'Keller', 'Billing Specialist', '2022-09-01');

INSERT INTO SupportTickets (customer_id, subject, description, date_created, status) VALUES
(2, 'Slow internet speed', 'My fiber connection has been very slow the last 2 days.', '2025-09-22 14:00:00', 'In Progress'),
(5, 'Billing question', 'I was charged for a service I did not order.', '2025-09-23 09:30:00', 'Open'),
(1, 'Cannot make international calls', 'My phone plan should include international calls but it is not working.', '2025-09-15 11:00:00', 'Resolved'),
(7, 'Cloud backup failed', 'My scheduled backup did not run last night.', '2025-09-25 08:15:00', 'Open'),
(6, 'Lost 5G connection', 'My business line suddenly dropped to 4G and is very slow.', '2025-09-25 11:00:00', 'Open');

INSERT INTO TicketAssignments (ticket_id, employee_id, assigned_at) VALUES
(1, 2, '2025-09-22 14:05:00'),
(2, 1, '2025-09-23 09:32:00'),
(3, 1, '2025-09-15 11:02:00'),
(3, 3, '2025-09-16 10:00:00'),
(4, 2, '2025-09-25 08:17:00');

-- View Creation
-- Customer Invoice Summary View
CREATE VIEW V_CustomerInvoiceSummary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(i.invoice_id) AS total_invoices,
    SUM(i.total_amount) AS total_billed_amount,
    SUM(CASE WHEN i.status = 'Unpaid' THEN 1 ELSE 0 END) AS unpaid_invoice_count
FROM
    Customers c
LEFT JOIN
    Invoices i ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id, customer_name, c.email;

-- Monthly Data Usage Trend View 
CREATE VIEW V_MonthlyDataUsageTrend AS
SELECT
    DATE_FORMAT(usage_date, '%Y-%m') AS usage_month,
    SUM(data_used_mb) / 1024 AS total_usage_gb
FROM
    DataUsage
GROUP BY
    usage_month
ORDER BY
    usage_month;
    
-- Queries
-- Query 1
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_paid
FROM Customers c
JOIN Invoices i ON c.customer_id = i.customer_id
JOIN Payments p ON i.invoice_id = p.invoice_id
GROUP BY c.customer_id, customer_name
ORDER BY total_paid DESC
LIMIT 5;

-- Query 2
SELECT
    customer_name,
    total_billed_amount,
    CASE
        WHEN total_billed_amount > 50 THEN 'Gold Customer'
        WHEN total_billed_amount > 30 AND total_billed_amount <= 50 THEN 'Silver Customer'
        ELSE 'Bronze Customer'
    END AS customer_segment
FROM V_CustomerInvoiceSummary; 

-- Query 3
SELECT
    plan_name,
    monthly_cost
FROM Plans
WHERE monthly_cost > (SELECT AVG(monthly_cost) FROM Plans);

-- Query 4
WITH RankedPlans AS (
    SELECT
        p.plan_name,
        s.type_name,
        p.monthly_cost,
        RANK() OVER(PARTITION BY s.type_name ORDER BY p.monthly_cost DESC) as price_rank
    FROM Plans p
    JOIN ServiceTypes s ON p.service_type_id = s.service_type_id
)
SELECT
    plan_name,
    type_name,
    monthly_cost
FROM RankedPlans
WHERE price_rank = 1;

-- Query 5
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Customers c
JOIN CustomerPlans cp ON c.customer_id = cp.customer_id
JOIN Plans p ON cp.plan_id = p.plan_id
JOIN ServiceTypes st ON p.service_type_id = st.service_type_id
WHERE st.type_name IN ('Mobile Plans', 'Fiber Broadband')
GROUP BY c.customer_id, customer_name
HAVING COUNT(DISTINCT st.type_name) = 2;

-- Query Performance and Optimization

-- Indexes for the joins
CREATE INDEX idx_invoices_customer_id ON Invoices(customer_id);
CREATE INDEX idx_payments_invoice_id ON Payments(invoice_id);

-- Alter the Customers table to add the new column
ALTER TABLE Customers ADD COLUMN total_lifetime_spend DECIMAL(12, 2) DEFAULT 0.00;
-- Update Customers Table
UPDATE Customers c
JOIN (
    SELECT
        i.customer_id,
        SUM(p.amount) AS total_paid
    FROM Payments p
    JOIN Invoices i ON p.invoice_id = i.invoice_id
    GROUP BY i.customer_id
) AS customer_payments ON c.customer_id = customer_payments.customer_id
SET
    c.total_lifetime_spend = customer_payments.total_paid;
-- New Query 1    
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    total_lifetime_spend
FROM Customers
ORDER BY total_lifetime_spend DESC
LIMIT 5;
