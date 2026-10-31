-- ======================================================================
-- TITLE
-- Experiment 2: Insertion, Deletion, Modification, Alteration, Updating and Conditional Record Viewing
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Query 1: Create database
CREATE DATABASE PayrollLabDB;
USE PayrollLabDB;

-- Query 2: Create Employee table
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(25) NOT NULL,
    Designation VARCHAR(30) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    City VARCHAR(30),
    Join_Date DATE NOT NULL
);

-- Query 3: Insert eight initial records
INSERT INTO Employee (Emp_ID, Emp_Name, Department, Designation, Salary, City, Join_Date)
VALUES
(201, 'Asha', 'HR', 'Executive', 38000, 'Chennai', '2023-06-12'),
(202, 'Bharat', 'IT', 'Developer', 52000, 'Hyderabad', '2022-08-01'),
(203, 'Charan', 'Sales', 'Associate', 32000, 'Vijayawada', '2024-01-15'),
(204, 'Deepa', 'IT', 'Analyst', 48000, 'Bengaluru', '2023-03-20'),
(205, 'Eshan', 'Finance', 'Accountant', 45000, 'Chennai', '2021-11-05'),
(206, 'Farah', 'HR', 'Recruiter', 41000, 'Hyderabad', '2024-02-10'),
(207, 'Gopal', 'Sales', 'Executive', 35000, 'Nellore', '2022-07-18'),
(208, 'Hema', 'IT', 'Developer', 56000, 'Tirupati', '2021-09-30');

-- Query 4: View initial records
SELECT * FROM Employee ORDER BY Emp_ID;

-- Query 5: Insert one new employee
INSERT INTO Employee VALUES (209, 'Ishita', 'Marketing', 'Coordinator', 39000, 'Guntur', '2025-01-06');
SELECT Emp_ID, Emp_Name, Department, Salary FROM Employee WHERE Emp_ID = 209;

-- Query 6: Update one salary
UPDATE Employee SET Salary = 55000 WHERE Emp_ID = 202;
SELECT Emp_ID, Emp_Name, Salary FROM Employee WHERE Emp_ID = 202;

-- Query 7: Increase Sales salaries by 10%
UPDATE Employee SET Salary = ROUND(Salary * 1.10, 2) WHERE Department = 'Sales';
SELECT Emp_ID, Emp_Name, Salary FROM Employee WHERE Department = 'Sales' ORDER BY Emp_ID;

-- Query 8: Modify employee department
UPDATE Employee SET Department = 'Operations' WHERE Emp_ID = 206;
SELECT Emp_ID, Emp_Name, Department FROM Employee WHERE Emp_ID = 206;

-- Query 9: Add a new column
ALTER TABLE Employee ADD COLUMN Email VARCHAR(80) NULL;
SHOW COLUMNS FROM Employee LIKE 'Email';

-- Query 10: Populate new column
UPDATE Employee SET Email = 'asha@company.test' WHERE Emp_ID = 201;
UPDATE Employee SET Email = 'bharat@company.test' WHERE Emp_ID = 202;
SELECT Emp_ID, Emp_Name, Email FROM Employee WHERE Email IS NOT NULL ORDER BY Emp_ID;

-- Query 11: Modify a column data type
ALTER TABLE Employee MODIFY COLUMN Designation VARCHAR(50) NOT NULL;
SHOW COLUMNS FROM Employee LIKE 'Designation';

-- Query 12: View conditional records
SELECT Emp_ID, Emp_Name, Department, Salary FROM Employee WHERE Salary >= 45000 ORDER BY Salary DESC, Emp_ID;

-- Query 13: Delete a selected employee
DELETE FROM Employee WHERE Emp_ID = 209;
SELECT COUNT(*) AS Total_Employees FROM Employee;

-- Query 14: Delete by condition
DELETE FROM Employee WHERE Department = 'Operations' AND Emp_ID = 206;
SELECT Emp_ID, Emp_Name, Department FROM Employee ORDER BY Emp_ID;

-- Query 15: View final payroll
SELECT Emp_ID, Emp_Name, Department, Salary, Email FROM Employee ORDER BY Emp_ID;

-- Verification 1: Consolidated checks
SELECT COUNT(*) AS Final_Count FROM Employee;
SELECT Emp_Name, Salary FROM Employee WHERE Department = 'Sales' ORDER BY Emp_ID;
SHOW COLUMNS FROM Employee;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Query 4: View initial records
-- +--------+----------+------------+-------------+----------+------------+------------+
-- | Emp_ID | Emp_Name | Department | Designation | Salary   | City       | Join_Date  |
-- +--------+----------+------------+-------------+----------+------------+------------+
-- |    201 | Asha     | HR         | Executive   | 38000.00 | Chennai    | 2023-06-12 |
-- |    202 | Bharat   | IT         | Developer   | 52000.00 | Hyderabad  | 2022-08-01 |
-- |    203 | Charan   | Sales      | Associate   | 32000.00 | Vijayawada | 2024-01-15 |
-- |    204 | Deepa    | IT         | Analyst     | 48000.00 | Bengaluru  | 2023-03-20 |
-- |    205 | Eshan    | Finance    | Accountant  | 45000.00 | Chennai    | 2021-11-05 |
-- |    206 | Farah    | HR         | Recruiter   | 41000.00 | Hyderabad  | 2024-02-10 |
-- |    207 | Gopal    | Sales      | Executive   | 35000.00 | Nellore    | 2022-07-18 |
-- |    208 | Hema     | IT         | Developer   | 56000.00 | Tirupati   | 2021-09-30 |
-- +--------+----------+------------+-------------+----------+------------+------------+

-- Query 5: Insert one new employee
-- +--------+----------+------------+----------+
-- | Emp_ID | Emp_Name | Department | Salary   |
-- +--------+----------+------------+----------+
-- |    209 | Ishita   | Marketing  | 39000.00 |
-- +--------+----------+------------+----------+

-- Query 6: Update one salary
-- +--------+----------+----------+
-- | Emp_ID | Emp_Name | Salary   |
-- +--------+----------+----------+
-- |    202 | Bharat   | 55000.00 |
-- +--------+----------+----------+

-- Query 7: Increase Sales salaries by 10%
-- +--------+----------+----------+
-- | Emp_ID | Emp_Name | Salary   |
-- +--------+----------+----------+
-- |    203 | Charan   | 35200.00 |
-- |    207 | Gopal    | 38500.00 |
-- +--------+----------+----------+

-- Query 8: Modify employee department
-- +--------+----------+------------+
-- | Emp_ID | Emp_Name | Department |
-- +--------+----------+------------+
-- |    206 | Farah    | Operations |
-- +--------+----------+------------+

-- Query 9: Add a new column
-- +-------+-------------+------+-----+---------+-------+
-- | Field | Type        | Null | Key | Default | Extra |
-- +-------+-------------+------+-----+---------+-------+
-- | Email | varchar(80) | YES  |     | NULL    |       |
-- +-------+-------------+------+-----+---------+-------+

-- Query 10: Populate new column
-- +--------+----------+---------------------+
-- | Emp_ID | Emp_Name | Email               |
-- +--------+----------+---------------------+
-- |    201 | Asha     | asha@company.test   |
-- |    202 | Bharat   | bharat@company.test |
-- +--------+----------+---------------------+

-- Query 11: Modify a column data type
-- +-------------+-------------+------+-----+---------+-------+
-- | Field       | Type        | Null | Key | Default | Extra |
-- +-------------+-------------+------+-----+---------+-------+
-- | Designation | varchar(50) | NO   |     | NULL    |       |
-- +-------------+-------------+------+-----+---------+-------+

-- Query 12: View conditional records
-- +--------+----------+------------+----------+
-- | Emp_ID | Emp_Name | Department | Salary   |
-- +--------+----------+------------+----------+
-- |    208 | Hema     | IT         | 56000.00 |
-- |    202 | Bharat   | IT         | 55000.00 |
-- |    204 | Deepa    | IT         | 48000.00 |
-- |    205 | Eshan    | Finance    | 45000.00 |
-- +--------+----------+------------+----------+

-- Query 13: Delete a selected employee
-- +-----------------+
-- | Total_Employees |
-- +-----------------+
-- |               8 |
-- +-----------------+

-- Query 14: Delete by condition
-- +--------+----------+------------+
-- | Emp_ID | Emp_Name | Department |
-- +--------+----------+------------+
-- |    201 | Asha     | HR         |
-- |    202 | Bharat   | IT         |
-- |    203 | Charan   | Sales      |
-- |    204 | Deepa    | IT         |
-- |    205 | Eshan    | Finance    |
-- |    207 | Gopal    | Sales      |
-- |    208 | Hema     | IT         |
-- +--------+----------+------------+

-- Query 15: View final payroll
-- +--------+----------+------------+----------+---------------------+
-- | Emp_ID | Emp_Name | Department | Salary   | Email               |
-- +--------+----------+------------+----------+---------------------+
-- |    201 | Asha     | HR         | 38000.00 | asha@company.test   |
-- |    202 | Bharat   | IT         | 55000.00 | bharat@company.test |
-- |    203 | Charan   | Sales      | 35200.00 | NULL                |
-- |    204 | Deepa    | IT         | 48000.00 | NULL                |
-- |    205 | Eshan    | Finance    | 45000.00 | NULL                |
-- |    207 | Gopal    | Sales      | 38500.00 | NULL                |
-- |    208 | Hema     | IT         | 56000.00 | NULL                |
-- +--------+----------+------------+----------+---------------------+

-- Verification 1: Consolidated checks
-- +-------------+
-- | Final_Count |
-- +-------------+
-- |           7 |
-- +-------------+
-- +----------+----------+
-- | Emp_Name | Salary   |
-- +----------+----------+
-- | Charan   | 35200.00 |
-- | Gopal    | 38500.00 |
-- +----------+----------+
-- +-------------+---------------+------+-----+---------+-------+
-- | Field       | Type          | Null | Key | Default | Extra |
-- +-------------+---------------+------+-----+---------+-------+
-- | Emp_ID      | int           | NO   | PRI | NULL    |       |
-- | Emp_Name    | varchar(50)   | NO   |     | NULL    |       |
-- | Department  | varchar(25)   | NO   |     | NULL    |       |
-- | Designation | varchar(50)   | NO   |     | NULL    |       |
-- | Salary      | decimal(10,2) | NO   |     | NULL    |       |
-- | City        | varchar(30)   | YES  |     | NULL    |       |
-- | Join_Date   | date          | NO   |     | NULL    |       |
-- | Email       | varchar(80)   | YES  |     | NULL    |       |
-- +-------------+---------------+------+-----+---------+-------+
