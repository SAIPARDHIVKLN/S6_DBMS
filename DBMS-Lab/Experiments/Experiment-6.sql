-- ======================================================================
-- TITLE
-- Experiment 6: SQL Aggregate Functions, GROUP BY and HAVING
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Step 1: Create and select the database
CREATE DATABASE IF NOT EXISTS RetailSalesDB;
USE RetailSalesDB;

-- Step 2: Create the table
CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Product_Name VARCHAR(40) NOT NULL,
    Category VARCHAR(25) NOT NULL,
    Region VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price DECIMAL(10,2) NOT NULL CHECK (Unit_Price >= 0)
);

-- Step 3: Insert all 12 records
INSERT INTO Sales VALUES
(1, 'Laptop', 'Electronics', 'South', 2, 45000),
(2, 'Mouse', 'Electronics', 'North', 10, 600),
(3, 'Chair', 'Furniture', 'South', 4, 3500),
(4, 'Desk', 'Furniture', 'East', 3, 8000),
(5, 'Notebook', 'Stationery', 'West', 20, 80),
(6, 'Pen', 'Stationery', 'North', 50, 20),
(7, 'Monitor', 'Electronics', 'East', 5, 12000),
(8, 'Chair', 'Furniture', 'North', 6, 3200),
(9, 'Notebook', 'Stationery', 'South', 30, 75),
(10, 'Keyboard', 'Electronics', 'West', 8, 1200),
(11, 'Desk', 'Furniture', 'West', 2, 8500),
(12, 'Pen', 'Stationery', 'East', 40, 25);

-- Query 1: COUNT - total sales records
SELECT COUNT(*) AS Total_Records FROM Sales;

-- Query 2: SUM - total units sold
SELECT SUM(Quantity) AS Total_Units FROM Sales;

-- Query 3: SUM - total sales revenue
SELECT SUM(Quantity * Unit_Price) AS Total_Revenue FROM Sales;

-- Query 4: AVG - average unit price
SELECT ROUND(AVG(Unit_Price), 2) AS Avg_Price FROM Sales;

-- Query 5: MIN and MAX - price range
SELECT MIN(Unit_Price) AS Lowest_Price, MAX(Unit_Price) AS Highest_Price FROM Sales;

-- Query 6: COUNT DISTINCT - product categories
SELECT COUNT(DISTINCT Category) AS Categories FROM Sales;

-- Query 7: GROUP BY - records per category
SELECT Category, COUNT(*) AS Sale_Records FROM Sales GROUP BY Category ORDER BY Category;

-- Query 8: GROUP BY - units per category
SELECT Category, SUM(Quantity) AS Units_Sold FROM Sales GROUP BY Category ORDER BY Category;

-- Query 9: GROUP BY - revenue per category
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue FROM Sales GROUP BY Category
ORDER BY Category;

-- Query 10: GROUP BY - region-wise revenue
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue FROM Sales GROUP BY Region
ORDER BY Revenue DESC, Region;

-- Query 11: HAVING - categories with more than 20 units
SELECT Category, SUM(Quantity) AS Units_Sold FROM Sales GROUP BY Category
HAVING SUM(Quantity) > 20 ORDER BY Category;

-- Query 12: HAVING - regions with revenue above 30000
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue FROM Sales GROUP BY Region
HAVING SUM(Quantity * Unit_Price) > 30000 ORDER BY Revenue DESC;

-- Query 13: WHERE and HAVING - filtered aggregates
SELECT Category, SUM(Quantity) AS Units_Sold FROM Sales
WHERE Region IN ('North', 'South')
GROUP BY Category HAVING SUM(Quantity) >= 10 ORDER BY Category;

-- Query 14: Multiple grouping columns
SELECT Category, Region, SUM(Quantity) AS Units_Sold FROM Sales
GROUP BY Category, Region ORDER BY Category, Region;

-- Query 15: Top category by revenue
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue FROM Sales GROUP BY Category
ORDER BY Revenue DESC, Category LIMIT 1;

-- Query 16: Average quantity by category
SELECT Category, ROUND(AVG(Quantity), 2) AS Avg_Quantity FROM Sales GROUP BY Category
ORDER BY Category;

-- Verification 1: Consolidated check
SELECT COUNT(*) AS Transactions, SUM(Quantity) AS Units,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Query 1: COUNT - total sales records
-- +---------------+
-- | Total_Records |
-- +---------------+
-- |            12 |
-- +---------------+

-- Query 2: SUM - total units sold
-- +-------------+
-- | Total_Units |
-- +-------------+
-- |         180 |
-- +-------------+

-- Query 3: SUM - total sales revenue
-- +---------------+
-- | Total_Revenue |
-- +---------------+
-- |     245650.00 |
-- +---------------+

-- Query 4: AVG - average unit price
-- +-----------+
-- | Avg_Price |
-- +-----------+
-- |   6850.00 |
-- +-----------+

-- Query 5: MIN and MAX - price range
-- +--------------+---------------+
-- | Lowest_Price | Highest_Price |
-- +--------------+---------------+
-- |        20.00 |      45000.00 |
-- +--------------+---------------+

-- Query 6: COUNT DISTINCT - product categories
-- +------------+
-- | Categories |
-- +------------+
-- |          3 |
-- +------------+

-- Query 7: GROUP BY - records per category
-- +-------------+--------------+
-- | Category    | Sale_Records |
-- +-------------+--------------+
-- | Electronics |            4 |
-- | Furniture   |            4 |
-- | Stationery  |            4 |
-- +-------------+--------------+

-- Query 8: GROUP BY - units per category
-- +-------------+------------+
-- | Category    | Units_Sold |
-- +-------------+------------+
-- | Electronics |         25 |
-- | Furniture   |         15 |
-- | Stationery  |        140 |
-- +-------------+------------+

-- Query 9: GROUP BY - revenue per category
-- +-------------+-----------+
-- | Category    | Revenue   |
-- +-------------+-----------+
-- | Electronics | 165600.00 |
-- | Furniture   |  74200.00 |
-- | Stationery  |   5850.00 |
-- +-------------+-----------+

-- Query 10: GROUP BY - region-wise revenue
-- +--------+-----------+
-- | Region | Revenue   |
-- +--------+-----------+
-- | South  | 106250.00 |
-- | East   |  85000.00 |
-- | West   |  28200.00 |
-- | North  |  26200.00 |
-- +--------+-----------+

-- Query 11: HAVING - categories with more than 20 units
-- +-------------+------------+
-- | Category    | Units_Sold |
-- +-------------+------------+
-- | Electronics |         25 |
-- | Stationery  |        140 |
-- +-------------+------------+

-- Query 12: HAVING - regions with revenue above 30000
-- +--------+-----------+
-- | Region | Revenue   |
-- +--------+-----------+
-- | South  | 106250.00 |
-- | East   |  85000.00 |
-- +--------+-----------+

-- Query 13: WHERE and HAVING - filtered aggregates
-- +-------------+------------+
-- | Category    | Units_Sold |
-- +-------------+------------+
-- | Electronics |         12 |
-- | Furniture   |         10 |
-- | Stationery  |         80 |
-- +-------------+------------+

-- Query 14: Multiple grouping columns
-- +-------------+--------+------------+
-- | Category    | Region | Units_Sold |
-- +-------------+--------+------------+
-- | Electronics | East   |          5 |
-- | Electronics | North  |         10 |
-- | Electronics | South  |          2 |
-- | Electronics | West   |          8 |
-- | Furniture   | East   |          3 |
-- | Furniture   | North  |          6 |
-- | Furniture   | South  |          4 |
-- | Furniture   | West   |          2 |
-- | Stationery  | East   |         40 |
-- | Stationery  | North  |         50 |
-- | Stationery  | South  |         30 |
-- | Stationery  | West   |         20 |
-- +-------------+--------+------------+

-- Query 15: Top category by revenue
-- +-------------+-----------+
-- | Category    | Revenue   |
-- +-------------+-----------+
-- | Electronics | 165600.00 |
-- +-------------+-----------+

-- Query 16: Average quantity by category
-- +-------------+--------------+
-- | Category    | Avg_Quantity |
-- +-------------+--------------+
-- | Electronics |         6.25 |
-- | Furniture   |         3.75 |
-- | Stationery  |        35.00 |
-- +-------------+--------------+

-- Verification 1: Consolidated check
-- +--------------+-------+-----------+
-- | Transactions | Units | Revenue   |
-- +--------------+-------+-----------+
-- |           12 |   180 | 245650.00 |
-- +--------------+-------+-----------+
