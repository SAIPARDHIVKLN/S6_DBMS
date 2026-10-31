-- ======================================================================
-- TITLE
-- Experiment 5: Advanced SQL Queries and Set Operators
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Step 1: Create and select schema
CREATE DATABASE IF NOT EXISTS LibraryExp5;
USE LibraryExp5;

-- Step 2: Create three tables
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(80) NOT NULL,
    category VARCHAR(30) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    copies INT NOT NULL,
    CHECK (price >= 0),
    CHECK (copies >= 0)
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(60) NOT NULL,
    department VARCHAR(20) NOT NULL
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Step 3: Insert all sample records
INSERT INTO Books VALUES
(1, 'SQL Basics', 'Database', 400, 5),
(2, 'Advanced SQL', 'Database', 650, 3),
(3, 'Python Guide', 'Programming', 550, 4),
(4, 'Java Handbook', 'Programming', 700, 2),
(5, 'Data Science', 'Analytics', 900, 2),
(6, 'Statistics 101', 'Analytics', 450, 6),
(7, 'Web Design', 'Web', 300, 5),
(8, 'Cloud Computing', 'Cloud', 800, 3);

INSERT INTO Members VALUES
(101, 'Asha', 'CSE'),
(102, 'Bala', 'ECE'),
(103, 'Charan', 'CSE'),
(104, 'Deepa', 'AIML'),
(105, 'Esha', 'MECH');

INSERT INTO Loans VALUES
(201, 1, 101, '2026-09-01'),
(202, 3, 101, '2026-09-02'),
(203, 2, 102, '2026-09-03'),
(204, 5, 104, '2026-09-04'),
(205, 4, 103, '2026-09-05');

-- Step 4: IN - Database or Analytics books
SELECT book_id, title FROM Books
WHERE category IN ('Database', 'Analytics')
ORDER BY book_id;

-- Step 5: ANY - Above at least one Database book price
SELECT book_id, title, price FROM Books
WHERE price > ANY
    (SELECT price FROM Books WHERE category = 'Database')
ORDER BY book_id;

-- Step 6: ALL - Above every Database book price
SELECT book_id, title, price FROM Books
WHERE price > ALL
    (SELECT price FROM Books WHERE category = 'Database')
ORDER BY book_id;

-- Step 7: EXISTS - Members who borrowed a book
SELECT m.member_id, m.member_name FROM Members m
WHERE EXISTS (SELECT 1 FROM Loans l
              WHERE l.member_id = m.member_id)
ORDER BY m.member_id;

-- Step 8: NOT EXISTS - Members with no loans
SELECT m.member_id, m.member_name FROM Members m
WHERE NOT EXISTS (SELECT 1 FROM Loans l
                  WHERE l.member_id = m.member_id)
ORDER BY m.member_id;

-- Step 9: IN subquery - Borrowed book titles
SELECT book_id, title FROM Books
WHERE book_id IN (SELECT book_id FROM Loans)
ORDER BY book_id;

-- Step 10: UNION - CSE or AIML member names
SELECT member_name FROM Members WHERE department = 'CSE'
UNION
SELECT member_name FROM Members WHERE department = 'AIML'
ORDER BY member_name;

-- Step 11: INTERSECT - CSE members who borrowed
SELECT member_id FROM Members WHERE department = 'CSE'
INTERSECT
SELECT member_id FROM Loans
ORDER BY member_id;

-- Step 12: UNION - Books under 500 or over 750
SELECT title FROM Books WHERE price < 500
UNION
SELECT title FROM Books WHERE price > 750
ORDER BY title;

-- Step 13: INTERSECT - Programming books with loans
SELECT book_id FROM Books WHERE category = 'Programming'
INTERSECT
SELECT book_id FROM Loans
ORDER BY book_id;

-- Step 14: NOT EXISTS - Books never borrowed
SELECT b.book_id, b.title FROM Books b
WHERE NOT EXISTS (SELECT 1 FROM Loans l
                  WHERE l.book_id = b.book_id)
ORDER BY b.book_id;

-- Step 15: CHECK constraint - rejected insert
-- Run separately; an error is expected.
INSERT INTO Books VALUES
(9, 'Invalid Price', 'Test', -50, 2);

-- Step 16: Foreign key - rejected loan
-- Run separately; an error is expected.
INSERT INTO Loans VALUES
(206, 999, 101, '2026-09-06');

-- Step 17: Verify counts
SELECT (SELECT COUNT(*) FROM Books) AS books,
       (SELECT COUNT(*) FROM Members) AS members,
       (SELECT COUNT(*) FROM Loans) AS loans;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Step 4: IN - Database or Analytics books
-- +---------+----------------+
-- | book_id | title          |
-- +---------+----------------+
-- |       1 | SQL Basics     |
-- |       2 | Advanced SQL   |
-- |       5 | Data Science   |
-- |       6 | Statistics 101 |
-- +---------+----------------+

-- Step 5: ANY - Above at least one Database book price
-- +---------+-----------------+--------+
-- | book_id | title           | price  |
-- +---------+-----------------+--------+
-- |       2 | Advanced SQL    | 650.00 |
-- |       3 | Python Guide    | 550.00 |
-- |       4 | Java Handbook   | 700.00 |
-- |       5 | Data Science    | 900.00 |
-- |       6 | Statistics 101  | 450.00 |
-- |       8 | Cloud Computing | 800.00 |
-- +---------+-----------------+--------+

-- Step 6: ALL - Above every Database book price
-- +---------+-----------------+--------+
-- | book_id | title           | price  |
-- +---------+-----------------+--------+
-- |       4 | Java Handbook   | 700.00 |
-- |       5 | Data Science    | 900.00 |
-- |       8 | Cloud Computing | 800.00 |
-- +---------+-----------------+--------+

-- Step 7: EXISTS - Members who borrowed a book
-- +-----------+-------------+
-- | member_id | member_name |
-- +-----------+-------------+
-- |       101 | Asha        |
-- |       102 | Bala        |
-- |       103 | Charan      |
-- |       104 | Deepa       |
-- +-----------+-------------+

-- Step 8: NOT EXISTS - Members with no loans
-- +-----------+-------------+
-- | member_id | member_name |
-- +-----------+-------------+
-- |       105 | Esha        |
-- +-----------+-------------+

-- Step 9: IN subquery - Borrowed book titles
-- +---------+---------------+
-- | book_id | title         |
-- +---------+---------------+
-- |       1 | SQL Basics    |
-- |       2 | Advanced SQL  |
-- |       3 | Python Guide  |
-- |       4 | Java Handbook |
-- |       5 | Data Science  |
-- +---------+---------------+

-- Step 10: UNION - CSE or AIML member names
-- +-------------+
-- | member_name |
-- +-------------+
-- | Asha        |
-- | Charan      |
-- | Deepa       |
-- +-------------+

-- Step 11: INTERSECT - CSE members who borrowed
-- +-----------+
-- | member_id |
-- +-----------+
-- |       101 |
-- |       103 |
-- +-----------+

-- Step 12: UNION - Books under 500 or over 750
-- +-----------------+
-- | title           |
-- +-----------------+
-- | Cloud Computing |
-- | Data Science    |
-- | SQL Basics      |
-- | Statistics 101  |
-- | Web Design      |
-- +-----------------+

-- Step 13: INTERSECT - Programming books with loans
-- +---------+
-- | book_id |
-- +---------+
-- |       3 |
-- |       4 |
-- +---------+

-- Step 14: NOT EXISTS - Books never borrowed
-- +---------+-----------------+
-- | book_id | title           |
-- +---------+-----------------+
-- |       6 | Statistics 101  |
-- |       7 | Web Design      |
-- |       8 | Cloud Computing |
-- +---------+-----------------+

-- Step 15: CHECK constraint - rejected insert
-- ERROR 3819 (HY000): Check constraint 'Books_chk_1' is violated.

-- Step 16: Foreign key - rejected loan
-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`LibraryExp5`.`Loans`, CONSTRAINT `Loans_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `Books` (`book_id`))

-- Step 17: Verify counts
-- +-------+---------+-------+
-- | books | members | loans |
-- +-------+---------+-------+
-- |     8 |       5 |     5 |
-- +-------+---------+-------+
