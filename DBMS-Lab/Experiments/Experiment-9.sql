-- ======================================================================
-- TITLE
-- Experiment 9: Creating Relationships Between Tables and Performing JOINs and Subqueries
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Query 1: Create and select the database
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Query 2: Create four related tables
CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE Employees (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(40) NOT NULL,
    Dept_ID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

CREATE TABLE Projects (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(60) NOT NULL,
    Dept_ID INT NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

CREATE TABLE Assignments (
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Hours INT NOT NULL,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID)
);

-- Query 3: Insert records
INSERT INTO Departments VALUES
(10, 'Development'), (20, 'Testing'), (30, 'HR'), (40, 'Research');

INSERT INTO Employees VALUES
(101, 'Arun', 10, 60000), (102, 'Priya', 10, 75000),
(103, 'Ravi', 20, 50000), (104, 'Sneha', 20, 55000),
(105, 'Kiran', 30, 45000), (106, 'Divya', 40, 90000),
(107, 'Rahul', 10, 65000);

INSERT INTO Projects VALUES
(201, 'Web Portal', 10, 300000),
(202, 'Mobile App', 10, 450000),
(203, 'QA Automation', 20, 200000),
(204, 'AI Prototype', 40, 600000),
(205, 'Recruitment Portal', 30, 120000);

INSERT INTO Assignments VALUES
(101, 201, 30), (102, 201, 25), (102, 202, 35),
(103, 203, 40), (104, 203, 20), (106, 204, 45),
(107, 202, 30);

-- Query 4: INNER JOIN - employees and departments
SELECT e.Emp_Name, d.Dept_Name
FROM Employees e INNER JOIN Departments d
ON e.Dept_ID = d.Dept_ID
ORDER BY e.Emp_ID;

-- Query 5: JOIN three tables - project assignments
SELECT e.Emp_Name, p.Project_Name, a.Hours
FROM Assignments a
JOIN Employees e ON a.Emp_ID = e.Emp_ID
JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY a.Emp_ID, a.Project_ID;

-- Query 6: LEFT JOIN - all employees, including unassigned
SELECT e.Emp_Name, p.Project_Name
FROM Employees e
LEFT JOIN Assignments a ON e.Emp_ID = a.Emp_ID
LEFT JOIN Projects p ON a.Project_ID = p.Project_ID
ORDER BY e.Emp_ID, p.Project_ID;

-- Query 7: RIGHT JOIN - all projects, including unassigned
SELECT p.Project_Name, e.Emp_Name
FROM Assignments a
RIGHT JOIN Projects p ON a.Project_ID = p.Project_ID
LEFT JOIN Employees e ON a.Emp_ID = e.Emp_ID
ORDER BY p.Project_ID, e.Emp_ID;

-- Query 8: CROSS JOIN - department/project combinations
SELECT d.Dept_Name, p.Project_Name
FROM Departments d CROSS JOIN Projects p
WHERE d.Dept_ID = 30
ORDER BY p.Project_ID;

-- Query 9: Self JOIN - pairs of employees in the same department
SELECT a.Emp_Name AS Employee1,
       b.Emp_Name AS Employee2
FROM Employees a JOIN Employees b
ON a.Dept_ID = b.Dept_ID AND a.Emp_ID < b.Emp_ID
ORDER BY a.Emp_ID, b.Emp_ID;

-- Query 10: Scalar subquery - salary above company average
SELECT Emp_Name, Salary FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;

-- Query 11: IN subquery - employees in departments with large project budgets
SELECT Emp_Name, Dept_ID FROM Employees
WHERE Dept_ID IN
    (SELECT Dept_ID FROM Projects WHERE Budget >= 400000)
ORDER BY Emp_ID;

-- Query 12: EXISTS - employees assigned to a project
SELECT e.Emp_Name FROM Employees e
WHERE EXISTS (SELECT 1 FROM Assignments a
              WHERE a.Emp_ID = e.Emp_ID)
ORDER BY e.Emp_ID;

-- Query 13: NOT EXISTS - employees with no assignment
SELECT e.Emp_Name FROM Employees e
WHERE NOT EXISTS (SELECT 1 FROM Assignments a
                  WHERE a.Emp_ID = e.Emp_ID);

-- Query 14: Correlated subquery - above department average
SELECT e.Emp_Name, e.Dept_ID, e.Salary
FROM Employees e
WHERE e.Salary > (SELECT AVG(x.Salary)
                  FROM Employees x WHERE x.Dept_ID = e.Dept_ID)
ORDER BY e.Emp_ID;

-- Query 15: Subquery using MAX - highest-paid employee
SELECT Emp_Name, Salary FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

-- Query 16: JOIN + GROUP BY - project staffing
SELECT p.Project_Name, COUNT(a.Emp_ID) AS Staff
FROM Projects p LEFT JOIN Assignments a
ON p.Project_ID = a.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY p.Project_ID;

-- Query 17: NOT EXISTS - projects without staff
SELECT p.Project_Name FROM Projects p
WHERE NOT EXISTS (SELECT 1 FROM Assignments a
                  WHERE a.Project_ID = p.Project_ID);

-- Verification 1: Consolidated check
SELECT (SELECT COUNT(*) FROM Departments) AS Departments,
       (SELECT COUNT(*) FROM Employees) AS Employees,
       (SELECT COUNT(*) FROM Projects) AS Projects,
       (SELECT COUNT(*) FROM Assignments) AS Assignments;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Query 4: INNER JOIN - employees and departments
-- +----------+-------------+
-- | Emp_Name | Dept_Name   |
-- +----------+-------------+
-- | Arun     | Development |
-- | Priya    | Development |
-- | Ravi     | Testing     |
-- | Sneha    | Testing     |
-- | Kiran    | HR          |
-- | Divya    | Research    |
-- | Rahul    | Development |
-- +----------+-------------+

-- Query 5: JOIN three tables - project assignments
-- +----------+---------------+-------+
-- | Emp_Name | Project_Name  | Hours |
-- +----------+---------------+-------+
-- | Arun     | Web Portal    |    30 |
-- | Priya    | Web Portal    |    25 |
-- | Priya    | Mobile App    |    35 |
-- | Ravi     | QA Automation |    40 |
-- | Sneha    | QA Automation |    20 |
-- | Divya    | AI Prototype  |    45 |
-- | Rahul    | Mobile App    |    30 |
-- +----------+---------------+-------+

-- Query 6: LEFT JOIN - all employees, including unassigned
-- +----------+---------------+
-- | Emp_Name | Project_Name  |
-- +----------+---------------+
-- | Arun     | Web Portal    |
-- | Priya    | Web Portal    |
-- | Priya    | Mobile App    |
-- | Ravi     | QA Automation |
-- | Sneha    | QA Automation |
-- | Kiran    | NULL          |
-- | Divya    | AI Prototype  |
-- | Rahul    | Mobile App    |
-- +----------+---------------+

-- Query 7: RIGHT JOIN - all projects, including unassigned
-- +--------------------+----------+
-- | Project_Name       | Emp_Name |
-- +--------------------+----------+
-- | Web Portal         | Arun     |
-- | Web Portal         | Priya    |
-- | Mobile App         | Priya    |
-- | Mobile App         | Rahul    |
-- | QA Automation      | Ravi     |
-- | QA Automation      | Sneha    |
-- | AI Prototype       | Divya    |
-- | Recruitment Portal | NULL     |
-- +--------------------+----------+

-- Query 8: CROSS JOIN - department/project combinations
-- +-----------+--------------------+
-- | Dept_Name | Project_Name       |
-- +-----------+--------------------+
-- | HR        | Web Portal         |
-- | HR        | Mobile App         |
-- | HR        | QA Automation      |
-- | HR        | AI Prototype       |
-- | HR        | Recruitment Portal |
-- +-----------+--------------------+

-- Query 9: Self JOIN - pairs of employees in the same department
-- +-----------+-----------+
-- | Employee1 | Employee2 |
-- +-----------+-----------+
-- | Arun      | Priya     |
-- | Arun      | Rahul     |
-- | Priya     | Rahul     |
-- | Ravi      | Sneha     |
-- +-----------+-----------+

-- Query 10: Scalar subquery - salary above company average
-- +----------+----------+
-- | Emp_Name | Salary   |
-- +----------+----------+
-- | Divya    | 90000.00 |
-- | Priya    | 75000.00 |
-- | Rahul    | 65000.00 |
-- +----------+----------+

-- Query 11: IN subquery - employees in departments with large project budgets
-- +----------+---------+
-- | Emp_Name | Dept_ID |
-- +----------+---------+
-- | Arun     |      10 |
-- | Priya    |      10 |
-- | Divya    |      40 |
-- | Rahul    |      10 |
-- +----------+---------+

-- Query 12: EXISTS - employees assigned to a project
-- +----------+
-- | Emp_Name |
-- +----------+
-- | Arun     |
-- | Priya    |
-- | Ravi     |
-- | Sneha    |
-- | Divya    |
-- | Rahul    |
-- +----------+

-- Query 13: NOT EXISTS - employees with no assignment
-- +----------+
-- | Emp_Name |
-- +----------+
-- | Kiran    |
-- +----------+

-- Query 14: Correlated subquery - above department average
-- +----------+---------+----------+
-- | Emp_Name | Dept_ID | Salary   |
-- +----------+---------+----------+
-- | Priya    |      10 | 75000.00 |
-- | Sneha    |      20 | 55000.00 |
-- +----------+---------+----------+

-- Query 15: Subquery using MAX - highest-paid employee
-- +----------+----------+
-- | Emp_Name | Salary   |
-- +----------+----------+
-- | Divya    | 90000.00 |
-- +----------+----------+

-- Query 16: JOIN + GROUP BY - project staffing
-- +--------------------+-------+
-- | Project_Name       | Staff |
-- +--------------------+-------+
-- | Web Portal         |     2 |
-- | Mobile App         |     2 |
-- | QA Automation      |     2 |
-- | AI Prototype       |     1 |
-- | Recruitment Portal |     0 |
-- +--------------------+-------+

-- Query 17: NOT EXISTS - projects without staff
-- +--------------------+
-- | Project_Name       |
-- +--------------------+
-- | Recruitment Portal |
-- +--------------------+

-- Verification 1: Consolidated check
-- +-------------+-----------+----------+-------------+
-- | Departments | Employees | Projects | Assignments |
-- +-------------+-----------+----------+-------------+
-- |           4 |         7 |        5 |           7 |
-- +-------------+-----------+----------+-------------+
