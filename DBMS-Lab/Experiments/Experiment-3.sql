-- ======================================================================
-- TITLE
-- Experiment 3: DCL and TCL Commands
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- Operation 1: Create the database and transactional table
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;
CREATE TABLE BankAccount (
    Account_ID INT PRIMARY KEY,
    Holder_Name VARCHAR(50) NOT NULL,
    Branch VARCHAR(30) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL CHECK (Balance >= 0),
    Account_Type VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- Operation 2: Insert five accounts
INSERT INTO BankAccount VALUES
(201, 'Anand', 'Chennai', 50000, 'Savings'),
(202, 'Bhavya', 'Hyderabad', 35000, 'Savings'),
(203, 'Charan', 'Vijayawada', 20000, 'Current'),
(204, 'Deepa', 'Chennai', 45000, 'Savings'),
(205, 'Eshan', 'Bengaluru', 60000, 'Current');

-- Operation 3: Inspect account balances
SELECT Account_ID, Holder_Name, Balance
FROM BankAccount ORDER BY Account_ID;

-- Operation 4: Create a limited-access bank teller user (administrator)
CREATE USER 'lab_teller3'@'localhost'
IDENTIFIED BY 'LabDemo_ChangeMe_2026!';

-- Operation 5: GRANT read access (administrator)
GRANT SELECT ON BankDB.BankAccount
TO 'lab_teller3'@'localhost';

-- Operation 6: Verify assigned privileges (administrator)
SHOW GRANTS FOR 'lab_teller3'@'localhost';

-- Operation 7: Test the teller permissions (separate login)
-- Connect to MySQL as lab_teller3 first, then run the statements below.
-- SELECT Account_ID, Balance
-- FROM BankDB.BankAccount;
-- UPDATE BankDB.BankAccount
-- SET Balance = Balance + 100
-- WHERE Account_ID = 201;

-- Operation 8: REVOKE read access (administrator)
REVOKE SELECT ON BankDB.BankAccount
FROM 'lab_teller3'@'localhost';
SHOW GRANTS FOR 'lab_teller3'@'localhost';

-- Operation 9: COMMIT a deposit
START TRANSACTION;
UPDATE BankAccount
SET Balance = Balance + 5000
WHERE Account_ID = 201;
COMMIT;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID = 201;

-- Operation 10: ROLLBACK a withdrawal
START TRANSACTION;
UPDATE BankAccount
SET Balance = Balance - 3000
WHERE Account_ID = 202;
ROLLBACK;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID = 202;

-- Operation 11: SAVEPOINT and partial rollback
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance + 1000
WHERE Account_ID = 203;
SAVEPOINT after_first_change;
UPDATE BankAccount SET Balance = Balance + 2000
WHERE Account_ID = 204;
ROLLBACK TO SAVEPOINT after_first_change;
COMMIT;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID IN (203, 204) ORDER BY Account_ID;

-- Operation 12: Atomic fund transfer using COMMIT
START TRANSACTION;
UPDATE BankAccount SET Balance = Balance - 4000
WHERE Account_ID = 201 AND Balance >= 4000;
-- Check ROW_COUNT() = 1 before continuing.
UPDATE BankAccount SET Balance = Balance + 4000
WHERE Account_ID = 202;
-- Check ROW_COUNT() = 1 before COMMIT.
COMMIT;
SELECT Account_ID, Balance FROM BankAccount
WHERE Account_ID IN (201, 202) ORDER BY Account_ID;

-- Operation 13: RELEASE SAVEPOINT
START TRANSACTION;
SAVEPOINT test_point;
RELEASE SAVEPOINT test_point;
ROLLBACK;

-- Operation 14: Clean up the test login (administrator)
DROP USER 'lab_teller3'@'localhost';

-- Verification 1: Final balances
SELECT Account_ID, Balance FROM BankAccount ORDER BY Account_ID;
SELECT SUM(Balance) AS Total_Balance FROM BankAccount;

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- Operation 3: Inspect account balances
-- +------------+-------------+----------+
-- | Account_ID | Holder_Name | Balance  |
-- +------------+-------------+----------+
-- |        201 | Anand       | 50000.00 |
-- |        202 | Bhavya      | 35000.00 |
-- |        203 | Charan      | 20000.00 |
-- |        204 | Deepa       | 45000.00 |
-- |        205 | Eshan       | 60000.00 |
-- +------------+-------------+----------+

-- Operation 6: Verify assigned privileges (administrator)
-- +---------------------------------------------------------------------+
-- | Grants for lab_teller3@localhost                                    |
-- +---------------------------------------------------------------------+
-- | GRANT USAGE ON *.* TO `lab_teller3`@`localhost`                     |
-- | GRANT SELECT ON `BankDB`.`BankAccount` TO `lab_teller3`@`localhost` |
-- +---------------------------------------------------------------------+

-- Operation 7: Test the teller permissions (separate login)
-- (run as lab_teller3, not as administrator)
-- SELECT: returns five rows
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        201 | 50000.00 |
-- |        202 | 35000.00 |
-- |        203 | 20000.00 |
-- |        204 | 45000.00 |
-- |        205 | 60000.00 |
-- +------------+----------+
-- UPDATE: fails, balance unchanged
-- ERROR 1142 (42000): UPDATE command denied to user 'lab_teller3'@'localhost' for table 'BankAccount'

-- Operation 8: REVOKE read access (administrator)
-- +-------------------------------------------------+
-- | Grants for lab_teller3@localhost                |
-- +-------------------------------------------------+
-- | GRANT USAGE ON *.* TO `lab_teller3`@`localhost` |
-- +-------------------------------------------------+

-- Operation 9: COMMIT a deposit
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        201 | 55000.00 |
-- +------------+----------+

-- Operation 10: ROLLBACK a withdrawal
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        202 | 35000.00 |
-- +------------+----------+

-- Operation 11: SAVEPOINT and partial rollback
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        203 | 21000.00 |
-- |        204 | 45000.00 |
-- +------------+----------+

-- Operation 12: Atomic fund transfer using COMMIT
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        201 | 51000.00 |
-- |        202 | 39000.00 |
-- +------------+----------+

-- Verification 1: Final balances
-- +------------+----------+
-- | Account_ID | Balance  |
-- +------------+----------+
-- |        201 | 51000.00 |
-- |        202 | 39000.00 |
-- |        203 | 21000.00 |
-- |        204 | 45000.00 |
-- |        205 | 60000.00 |
-- +------------+----------+
-- +---------------+
-- | Total_Balance |
-- +---------------+
-- |     216000.00 |
-- +---------------+
