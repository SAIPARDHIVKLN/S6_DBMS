-- ======================================================================
-- TITLE
-- Experiment 7: Creation of Views, Sequences, Indexes and Savepoints
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Query 1: Create and select database
CREATE DATABASE WarehouseDB;
USE WarehouseDB;

-- Query 2: Create Product table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(60) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Qty INT NOT NULL,
    Warehouse VARCHAR(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001;

-- Query 3: Insert eight sample products
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES
('Keyboard', 'Electronics', 800, 40, 'Chennai'),
('Mouse', 'Electronics', 450, 12, 'Chennai'),
('Office Chair', 'Furniture', 4500, 8, 'Bengaluru'),
('Desk', 'Furniture', 7200, 15, 'Chennai'),
('Notebook', 'Stationery', 60, 100, 'Hyderabad'),
('Pen Pack', 'Stationery', 120, 25, 'Hyderabad'),
('Monitor', 'Electronics', 12500, 6, 'Bengaluru'),
('Printer', 'Electronics', 9500, 4, 'Chennai');

-- Query 4: Create a product view
CREATE VIEW vw_product_catalog AS
SELECT Product_ID, Product_Name, Category, Unit_Price
FROM Product;

-- Query 5: Retrieve data from the view
SELECT * FROM vw_product_catalog
ORDER BY Product_ID;

-- Query 6: Create a low-stock view
CREATE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Stock_Qty
FROM Product WHERE Stock_Qty < 10;

-- Query 7: Display low-stock products
SELECT * FROM vw_low_stock
ORDER BY Product_ID;

-- Query 8: Replace a view definition
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Category, Stock_Qty
FROM Product WHERE Stock_Qty <= 12;
SELECT * FROM vw_low_stock
ORDER BY Product_ID;

-- Query 9: Generate the next automatic ID
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES ('Webcam', 'Electronics', 2200, 18, 'Chennai');
SELECT LAST_INSERT_ID() AS New_Product_ID;

-- Query 10: Create an index
CREATE INDEX idx_product_category
ON Product(Category);

-- Query 11: Inspect indexes
SHOW INDEX FROM Product;

-- Query 12: Inspect an indexed query plan
EXPLAIN SELECT * FROM Product
WHERE Category = 'Electronics';

-- Query 13: Create and use a savepoint
START TRANSACTION;
UPDATE Product SET Stock_Qty = Stock_Qty - 5
WHERE Product_ID = 1001;
SAVEPOINT sp_after_keyboard;
UPDATE Product SET Stock_Qty = Stock_Qty - 3
WHERE Product_ID = 1002;
SELECT Product_ID, Stock_Qty FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 14: Roll back to savepoint
ROLLBACK TO SAVEPOINT sp_after_keyboard;
SELECT Product_ID, Stock_Qty FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 15: Commit retained changes
COMMIT;
SELECT Product_ID, Stock_Qty FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 16: Demonstrate full rollback
START TRANSACTION;
UPDATE Product SET Stock_Qty = 0
WHERE Product_ID = 1003;
ROLLBACK;
SELECT Product_ID, Stock_Qty FROM Product
WHERE Product_ID = 1003;

-- Query 17: Drop the secondary index
DROP INDEX idx_product_category ON Product;
SHOW INDEX FROM Product;

-- Verification 1: Consolidated checks
SELECT COUNT(*) AS Total_Products FROM Product;
SELECT Product_ID, Stock_Qty FROM Product
WHERE Product_ID IN (1001, 1002, 1003);
SHOW FULL TABLES IN WarehouseDB;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Query 5: Retrieve data from the view
-- +------------+--------------+-------------+------------+
-- | Product_ID | Product_Name | Category    | Unit_Price |
-- +------------+--------------+-------------+------------+
-- |       1001 | Keyboard     | Electronics |     800.00 |
-- |       1002 | Mouse        | Electronics |     450.00 |
-- |       1003 | Office Chair | Furniture   |    4500.00 |
-- |       1004 | Desk         | Furniture   |    7200.00 |
-- |       1005 | Notebook     | Stationery  |      60.00 |
-- |       1006 | Pen Pack     | Stationery  |     120.00 |
-- |       1007 | Monitor      | Electronics |   12500.00 |
-- |       1008 | Printer      | Electronics |    9500.00 |
-- +------------+--------------+-------------+------------+

-- Query 7: Display low-stock products
-- +------------+--------------+-----------+
-- | Product_ID | Product_Name | Stock_Qty |
-- +------------+--------------+-----------+
-- |       1003 | Office Chair |         8 |
-- |       1007 | Monitor      |         6 |
-- |       1008 | Printer      |         4 |
-- +------------+--------------+-----------+

-- Query 8: Replace a view definition
-- +------------+--------------+-------------+-----------+
-- | Product_ID | Product_Name | Category    | Stock_Qty |
-- +------------+--------------+-------------+-----------+
-- |       1002 | Mouse        | Electronics |        12 |
-- |       1003 | Office Chair | Furniture   |         8 |
-- |       1007 | Monitor      | Electronics |         6 |
-- |       1008 | Printer      | Electronics |         4 |
-- +------------+--------------+-------------+-----------+

-- Query 9: Generate the next automatic ID
-- +----------------+
-- | New_Product_ID |
-- +----------------+
-- |           1009 |
-- +----------------+

-- Query 11: Inspect indexes
-- (SHOW CREATE TABLE result)
--          0 | PRIMARY              |            1 | Product_ID  | A         |           2 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | Product |          1 | idx_product_category |            1 | Category    | A         |           3 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL

-- Query 12: Inspect an indexed query plan
-- +----+-------------+---------+------------+------+----------------------+----------------------+---------+-------+------+----------+-------+
-- | id | select_type | table   | partitions | type | possible_keys        | key                  | key_len | ref   | rows | filtered | Extra |
-- +----+-------------+---------+------------+------+----------------------+----------------------+---------+-------+------+----------+-------+
-- |  1 | SIMPLE      | Product | NULL       | ref  | idx_product_category | idx_product_category | 122     | const |    5 |   100.00 | NULL  |
-- +----+-------------+---------+------------+------+----------------------+----------------------+---------+-------+------+----------+-------+

-- Query 13: Create and use a savepoint
-- +------------+-----------+
-- | Product_ID | Stock_Qty |
-- +------------+-----------+
-- |       1001 |        35 |
-- |       1002 |         9 |
-- +------------+-----------+

-- Query 14: Roll back to savepoint
-- +------------+-----------+
-- | Product_ID | Stock_Qty |
-- +------------+-----------+
-- |       1001 |        35 |
-- |       1002 |        12 |
-- +------------+-----------+

-- Query 15: Commit retained changes
-- +------------+-----------+
-- | Product_ID | Stock_Qty |
-- +------------+-----------+
-- |       1001 |        35 |
-- |       1002 |        12 |
-- +------------+-----------+

-- Query 16: Demonstrate full rollback
-- +------------+-----------+
-- | Product_ID | Stock_Qty |
-- +------------+-----------+
-- |       1003 |         8 |
-- +------------+-----------+

-- Query 17: Drop the secondary index
-- (SHOW CREATE TABLE result)
--          0 | PRIMARY  |            1 | Product_ID  | A         |           2 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL

-- Verification 1: Consolidated checks
-- +----------------+
-- | Total_Products |
-- +----------------+
-- |              9 |
-- +----------------+
-- +------------+-----------+
-- | Product_ID | Stock_Qty |
-- +------------+-----------+
-- |       1001 |        35 |
-- |       1002 |        12 |
-- |       1003 |         8 |
-- +------------+-----------+
-- +-----------------------+------------+
-- | Tables_in_WarehouseDB | Table_type |
-- +-----------------------+------------+
-- | Product               | BASE TABLE |
-- | vw_low_stock          | VIEW       |
-- | vw_product_catalog    | VIEW       |
-- +-----------------------+------------+
