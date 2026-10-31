-- ======================================================================
-- TITLE
-- Experiment 1: Creation of a Database and SQL Queries for Information Retrieval
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Query 1: Create the database
CREATE DATABASE UniversityDB;

-- Query 2: Select the database
USE UniversityDB;

-- Query 3: Create Student table
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    City VARCHAR(30)
);

-- Query 4: Inspect table structure
DESC Student;

-- Query 5: Insert ten records
INSERT INTO Student
(Student_ID, Student_Name, Department, Year, Age, Gender, Marks, City)
VALUES
(101, 'Arun', 'CSE', 2, 19, 'Male', 85, 'Chennai'),
(102, 'Priya', 'ECE', 3, 20, 'Female', 92, 'Hyderabad'),
(103, 'Ravi', 'CSE', 2, 19, 'Male', 67, 'Vijayawada'),
(104, 'Sneha', 'AIML', 1, 18, 'Female', 88, 'Bengaluru'),
(105, 'Kiran', 'EEE', 4, 21, 'Male', 56, 'Chennai'),
(106, 'Divya', 'CSE', 3, 20, 'Female', 94, 'Tirupati'),
(107, 'Rahul', 'MECH', 2, 19, 'Male', 72, 'Nellore'),
(108, 'Anjali', 'AIML', 1, 18, 'Female', 81, 'Hyderabad'),
(109, 'Naveen', 'ECE', 4, 21, 'Male', 63, 'Guntur'),
(110, 'Kavya', 'CSE', 3, 20, 'Female', 90, 'Chennai');

-- Query 6: Retrieve all records
SELECT * FROM Student ORDER BY Student_ID;

-- Query 7: Select three columns
SELECT Student_ID, Student_Name, Department FROM Student ORDER BY Student_ID;

-- Query 8: Filter CSE students
SELECT Student_ID, Student_Name, Department FROM Student WHERE Department = 'CSE' ORDER BY Student_ID;

-- Query 9: Use AND
SELECT Student_Name, Department, Marks FROM Student WHERE Department = 'CSE' AND Marks > 80 ORDER BY Student_ID;

-- Query 10: Use OR
SELECT Student_Name, Department FROM Student WHERE Department = 'AIML' OR Department = 'ECE' ORDER BY Student_ID;

-- Query 11: Distinct departments
SELECT DISTINCT Department FROM Student ORDER BY Department;

-- Query 12: Sort marks ascending
SELECT Student_Name, Marks FROM Student ORDER BY Marks ASC;

-- Query 13: Sort marks descending
SELECT Student_Name, Marks FROM Student ORDER BY Marks DESC;

-- Query 14: Use BETWEEN
SELECT Student_Name, Marks FROM Student WHERE Marks BETWEEN 70 AND 90 ORDER BY Marks ASC;

-- Query 15: Search using LIKE
SELECT Student_ID, Student_Name FROM Student WHERE Student_Name LIKE 'A%' ORDER BY Student_ID;

-- Query 16: Use IN
SELECT Student_Name, Department FROM Student WHERE Department IN ('CSE', 'ECE', 'AIML') ORDER BY Student_ID;

-- Query 17: Find missing cities
SELECT Student_ID, Student_Name, City FROM Student WHERE City IS NULL;

-- Query 18: Top three marks
SELECT Student_Name, Department, Marks FROM Student ORDER BY Marks DESC, Student_ID ASC LIMIT 3;

-- Verification 1: Consolidated checks
SELECT COUNT(*) AS Total FROM Student;
SELECT COUNT(DISTINCT Department) AS Departments FROM Student;
SELECT MAX(Marks) AS Highest, MIN(Marks) AS Lowest FROM Student;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Query 4: Inspect table structure
-- +--------------+--------------+------+-----+---------+-------+
-- | Field        | Type         | Null | Key | Default | Extra |
-- +--------------+--------------+------+-----+---------+-------+
-- | Student_ID   | int          | NO   | PRI | NULL    |       |
-- | Student_Name | varchar(50)  | NO   |     | NULL    |       |
-- | Department   | varchar(20)  | NO   |     | NULL    |       |
-- | Year         | int          | NO   |     | NULL    |       |
-- | Age          | int          | YES  |     | NULL    |       |
-- | Gender       | varchar(10)  | YES  |     | NULL    |       |
-- | Marks        | decimal(5,2) | YES  |     | NULL    |       |
-- | City         | varchar(30)  | YES  |     | NULL    |       |
-- +--------------+--------------+------+-----+---------+-------+

-- Query 6: Retrieve all records
-- +------------+--------------+------------+------+------+--------+-------+------------+
-- | Student_ID | Student_Name | Department | Year | Age  | Gender | Marks | City       |
-- +------------+--------------+------------+------+------+--------+-------+------------+
-- |        101 | Arun         | CSE        |    2 |   19 | Male   | 85.00 | Chennai    |
-- |        102 | Priya        | ECE        |    3 |   20 | Female | 92.00 | Hyderabad  |
-- |        103 | Ravi         | CSE        |    2 |   19 | Male   | 67.00 | Vijayawada |
-- |        104 | Sneha        | AIML       |    1 |   18 | Female | 88.00 | Bengaluru  |
-- |        105 | Kiran        | EEE        |    4 |   21 | Male   | 56.00 | Chennai    |
-- |        106 | Divya        | CSE        |    3 |   20 | Female | 94.00 | Tirupati   |
-- |        107 | Rahul        | MECH       |    2 |   19 | Male   | 72.00 | Nellore    |
-- |        108 | Anjali       | AIML       |    1 |   18 | Female | 81.00 | Hyderabad  |
-- |        109 | Naveen       | ECE        |    4 |   21 | Male   | 63.00 | Guntur     |
-- |        110 | Kavya        | CSE        |    3 |   20 | Female | 90.00 | Chennai    |
-- +------------+--------------+------------+------+------+--------+-------+------------+

-- Query 7: Select three columns
-- +------------+--------------+------------+
-- | Student_ID | Student_Name | Department |
-- +------------+--------------+------------+
-- |        101 | Arun         | CSE        |
-- |        102 | Priya        | ECE        |
-- |        103 | Ravi         | CSE        |
-- |        104 | Sneha        | AIML       |
-- |        105 | Kiran        | EEE        |
-- |        106 | Divya        | CSE        |
-- |        107 | Rahul        | MECH       |
-- |        108 | Anjali       | AIML       |
-- |        109 | Naveen       | ECE        |
-- |        110 | Kavya        | CSE        |
-- +------------+--------------+------------+

-- Query 8: Filter CSE students
-- +------------+--------------+------------+
-- | Student_ID | Student_Name | Department |
-- +------------+--------------+------------+
-- |        101 | Arun         | CSE        |
-- |        103 | Ravi         | CSE        |
-- |        106 | Divya        | CSE        |
-- |        110 | Kavya        | CSE        |
-- +------------+--------------+------------+

-- Query 9: Use AND
-- +--------------+------------+-------+
-- | Student_Name | Department | Marks |
-- +--------------+------------+-------+
-- | Arun         | CSE        | 85.00 |
-- | Divya        | CSE        | 94.00 |
-- | Kavya        | CSE        | 90.00 |
-- +--------------+------------+-------+

-- Query 10: Use OR
-- +--------------+------------+
-- | Student_Name | Department |
-- +--------------+------------+
-- | Priya        | ECE        |
-- | Sneha        | AIML       |
-- | Anjali       | AIML       |
-- | Naveen       | ECE        |
-- +--------------+------------+

-- Query 11: Distinct departments
-- +------------+
-- | Department |
-- +------------+
-- | AIML       |
-- | CSE        |
-- | ECE        |
-- | EEE        |
-- | MECH       |
-- +------------+

-- Query 12: Sort marks ascending
-- +--------------+-------+
-- | Student_Name | Marks |
-- +--------------+-------+
-- | Kiran        | 56.00 |
-- | Naveen       | 63.00 |
-- | Ravi         | 67.00 |
-- | Rahul        | 72.00 |
-- | Anjali       | 81.00 |
-- | Arun         | 85.00 |
-- | Sneha        | 88.00 |
-- | Kavya        | 90.00 |
-- | Priya        | 92.00 |
-- | Divya        | 94.00 |
-- +--------------+-------+

-- Query 13: Sort marks descending
-- +--------------+-------+
-- | Student_Name | Marks |
-- +--------------+-------+
-- | Divya        | 94.00 |
-- | Priya        | 92.00 |
-- | Kavya        | 90.00 |
-- | Sneha        | 88.00 |
-- | Arun         | 85.00 |
-- | Anjali       | 81.00 |
-- | Rahul        | 72.00 |
-- | Ravi         | 67.00 |
-- | Naveen       | 63.00 |
-- | Kiran        | 56.00 |
-- +--------------+-------+

-- Query 14: Use BETWEEN
-- +--------------+-------+
-- | Student_Name | Marks |
-- +--------------+-------+
-- | Rahul        | 72.00 |
-- | Anjali       | 81.00 |
-- | Arun         | 85.00 |
-- | Sneha        | 88.00 |
-- | Kavya        | 90.00 |
-- +--------------+-------+

-- Query 15: Search using LIKE
-- +------------+--------------+
-- | Student_ID | Student_Name |
-- +------------+--------------+
-- |        101 | Arun         |
-- |        108 | Anjali       |
-- +------------+--------------+

-- Query 16: Use IN
-- +--------------+------------+
-- | Student_Name | Department |
-- +--------------+------------+
-- | Arun         | CSE        |
-- | Priya        | ECE        |
-- | Ravi         | CSE        |
-- | Sneha        | AIML       |
-- | Divya        | CSE        |
-- | Anjali       | AIML       |
-- | Naveen       | ECE        |
-- | Kavya        | CSE        |
-- +--------------+------------+

-- Query 17: Find missing cities
-- Empty set (0 rows)

-- Query 18: Top three marks
-- +--------------+------------+-------+
-- | Student_Name | Department | Marks |
-- +--------------+------------+-------+
-- | Divya        | CSE        | 94.00 |
-- | Priya        | ECE        | 92.00 |
-- | Kavya        | CSE        | 90.00 |
-- +--------------+------------+-------+

-- Verification 1: Consolidated checks
-- +-------+
-- | Total |
-- +-------+
-- |    10 |
-- +-------+
-- +-------------+
-- | Departments |
-- +-------------+
-- |           5 |
-- +-------------+
-- +---------+--------+
-- | Highest | Lowest |
-- +---------+--------+
-- |   94.00 |  56.00 |
-- +---------+--------+
