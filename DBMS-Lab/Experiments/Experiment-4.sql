-- ======================================================================
-- TITLE
-- Experiment 4: Creating a Database to Set Various Constraints
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Step 1: Create database and select it
CREATE DATABASE IF NOT EXISTS RetailConstraintDB;
USE RetailConstraintDB;

-- Step 2: Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60) NOT NULL,
    email VARCHAR(80) NOT NULL UNIQUE,
    city VARCHAR(40) DEFAULT 'Chennai'
) ENGINE=InnoDB;

-- Step 3: Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(60) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

-- Step 4: Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(12) NOT NULL DEFAULT 'Pending',
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT fk_order_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_status CHECK
        (order_status IN ('Pending', 'Confirmed', 'Cancelled'))
) ENGINE=InnoDB;

-- Step 5: Insert customers
INSERT INTO Customers(customer_id, customer_name, email, city) VALUES
(201, 'Asha', 'asha@example.com', 'Chennai'),
(202, 'Bala', 'bala@example.com', 'Hyderabad'),
(203, 'Charu', 'charu@example.com', 'Bengaluru');

-- Step 6: Insert products
INSERT INTO Products(product_id, sku, product_name, price, stock) VALUES
(301, 'KB-01', 'Keyboard', 850, 25),
(302, 'MS-02', 'Mouse', 450, 40),
(303, 'HD-03', 'Hard Drive', 4200, 10);

-- Step 7: Insert orders
INSERT INTO Orders(order_id, customer_id, product_id, quantity, order_status) VALUES
(401, 201, 301, 2, 'Pending'),
(402, 202, 302, 3, 'Confirmed'),
(403, 203, 303, 1, 'Pending');

-- Step 8: Test DEFAULT value
INSERT INTO Customers(customer_id, customer_name, email)
VALUES (204, 'Deepa', 'deepa@example.com');
SELECT customer_id, customer_name, city FROM Customers WHERE customer_id = 204;

-- Expected-failure tests (Steps 9 to 15): run each statement individually.
-- A script stops at the first error, so execute them one at a time.

-- Step 9: Test duplicate PRIMARY KEY (expected failure)
INSERT INTO Customers(customer_id, customer_name, email)
VALUES (201, 'Duplicate', 'duplicate@example.com');

-- Step 10: Test duplicate UNIQUE email (expected failure)
INSERT INTO Customers(customer_id, customer_name, email)
VALUES (205, 'Esha', 'asha@example.com');

-- Step 11: Test NOT NULL (expected failure)
INSERT INTO Customers(customer_id, customer_name, email)
VALUES (205, NULL, 'esha@example.com');

-- Step 12: Test CHECK price (expected failure)
INSERT INTO Products(product_id, sku, product_name, price, stock)
VALUES (304, 'BAD-04', 'Invalid Product', -10, 5);

-- Step 13: Test CHECK quantity (expected failure)
INSERT INTO Orders(order_id, customer_id, product_id, quantity)
VALUES (404, 201, 301, 0);

-- Step 14: Test FOREIGN KEY (expected failure)
INSERT INTO Orders(order_id, customer_id, product_id, quantity)
VALUES (404, 999, 301, 1);

-- Step 15: Test status CHECK (expected failure)
INSERT INTO Orders(order_id, customer_id, product_id, quantity, order_status)
VALUES (404, 201, 301, 1, 'Shipped');

-- Step 16: Verify data and table constraints
SELECT customer_id, customer_name, email, city
FROM Customers ORDER BY customer_id;
SELECT order_id, customer_id, product_id, quantity, order_status
FROM Orders ORDER BY order_id;
SHOW CREATE TABLE Orders;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Step 8: Test DEFAULT value
-- +-------------+---------------+---------+
-- | customer_id | customer_name | city    |
-- +-------------+---------------+---------+
-- |         204 | Deepa         | Chennai |
-- +-------------+---------------+---------+

-- Step 9: Test duplicate PRIMARY KEY (expected failure)
-- ERROR 1062 (23000): Duplicate entry '201' for key 'Customers.PRIMARY'

-- Step 10: Test duplicate UNIQUE email (expected failure)
-- ERROR 1062 (23000): Duplicate entry 'asha@example.com' for key 'Customers.email'

-- Step 11: Test NOT NULL (expected failure)
-- ERROR 1048 (23000): Column 'customer_name' cannot be null

-- Step 12: Test CHECK price (expected failure)
-- ERROR 3819 (HY000): Check constraint 'chk_price' is violated.

-- Step 13: Test CHECK quantity (expected failure)
-- ERROR 3819 (HY000): Check constraint 'chk_quantity' is violated.

-- Step 14: Test FOREIGN KEY (expected failure)
-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`RetailConstraintDB`.`Orders`, CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`customer_id`))

-- Step 15: Test status CHECK (expected failure)
-- ERROR 3819 (HY000): Check constraint 'chk_status' is violated.

-- Step 16: Verify data and table constraints
-- +-------------+---------------+-------------------+-----------+
-- | customer_id | customer_name | email             | city      |
-- +-------------+---------------+-------------------+-----------+
-- |         201 | Asha          | asha@example.com  | Chennai   |
-- |         202 | Bala          | bala@example.com  | Hyderabad |
-- |         203 | Charu         | charu@example.com | Bengaluru |
-- |         204 | Deepa         | deepa@example.com | Chennai   |
-- +-------------+---------------+-------------------+-----------+
-- +----------+-------------+------------+----------+--------------+
-- | order_id | customer_id | product_id | quantity | order_status |
-- +----------+-------------+------------+----------+--------------+
-- |      401 |         201 |        301 |        2 | Pending      |
-- |      402 |         202 |        302 |        3 | Confirmed    |
-- |      403 |         203 |        303 |        1 | Pending      |
-- +----------+-------------+------------+----------+--------------+
-- (SHOW CREATE TABLE result)
-- CREATE TABLE `Orders` (
--   `order_id` int NOT NULL,
--   `customer_id` int NOT NULL,
--   `product_id` int NOT NULL,
--   `quantity` int NOT NULL,
--   `order_status` varchar(12) NOT NULL DEFAULT 'Pending',
--   `order_date` date NOT NULL DEFAULT (curdate()),
--   PRIMARY KEY (`order_id`),
--   KEY `fk_order_customer` (`customer_id`),
--   KEY `fk_order_product` (`product_id`),
--   CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`customer_id`),
--   CONSTRAINT `fk_order_product` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`),
--   CONSTRAINT `chk_quantity` CHECK ((`quantity` > 0)),
--   CONSTRAINT `chk_status` CHECK ((`order_status` in (_utf8mb4'Pending',_utf8mb4'Confirmed',_utf8mb4'Cancelled')))
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
