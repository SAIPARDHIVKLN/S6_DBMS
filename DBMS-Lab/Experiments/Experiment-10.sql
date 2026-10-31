-- ======================================================================
-- TITLE
-- Experiment 10: PL/SQL Programming: Conditional Blocks, Exceptions, Procedures, Functions, Triggers and Cursors
-- (Oracle PL/SQL)
-- ======================================================================

-- ======================================================================
-- SQL CODE
-- ======================================================================

-- 7.1 Create tables and insert data
SET SERVEROUTPUT ON;

CREATE TABLE patients (
    patient_id NUMBER(5) PRIMARY KEY,
    patient_name VARCHAR2(40) NOT NULL,
    department VARCHAR2(30) NOT NULL,
    bill_amount NUMBER(10,2) CHECK (bill_amount >= 0),
    paid_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT ck_paid CHECK (paid_amount >= 0
                              AND paid_amount <= bill_amount)
);

CREATE TABLE patient_audit (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id NUMBER(5),
    action_type VARCHAR2(10),
    old_bill NUMBER(10,2),
    new_bill NUMBER(10,2),
    changed_on TIMESTAMP DEFAULT SYSTIMESTAMP
);

INSERT INTO patients VALUES (201, 'Asha', 'Cardiology', 12000, 8000);
INSERT INTO patients VALUES (202, 'Bala', 'Orthopedics', 9000, 9000);
INSERT INTO patients VALUES (203, 'Charan', 'Neurology', 18000, 6000);
INSERT INTO patients VALUES (204, 'Deepa', 'Cardiology', 7000, 3000);
INSERT INTO patients VALUES (205, 'Eshan', 'General', 5000, 1000);
COMMIT;

SELECT patient_id, patient_name,
       bill_amount - paid_amount AS balance
FROM patients ORDER BY patient_id;

-- 7.2 (a) User-input conditional PL/SQL block
ACCEPT p_id NUMBER PROMPT 'Enter patient ID: '
DECLARE
    v_id patients.patient_id%TYPE := &p_id;
    v_name patients.patient_name%TYPE;
    v_due NUMBER(10,2);
BEGIN
    SELECT patient_name, bill_amount - paid_amount
    INTO v_name, v_due FROM patients
    WHERE patient_id = v_id;
    IF v_due = 0 THEN
        DBMS_OUTPUT.PUT_LINE(v_name || ': Fully paid');
    ELSIF v_due > 10000 THEN
        DBMS_OUTPUT.PUT_LINE(v_name || ': High outstanding');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_name || ': Payment pending');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Patient not found');
END;
/

-- 7.3 (b) Exception handling: named and unexpected exceptions
DECLARE
    v_name patients.patient_name%TYPE;
    v_result NUMBER;
BEGIN
    BEGIN
        SELECT patient_name INTO v_name
        FROM patients WHERE patient_id = 999;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND handled');
    END;
    BEGIN
        SELECT patient_name INTO v_name
        FROM patients WHERE department = 'Cardiology';
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS handled');
    END;
    BEGIN
        v_result := 10 / 0;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE handled');
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected: ' || SQLERRM);
END;
/

-- 7.4 (c) Stored procedure: record payment
CREATE OR REPLACE PROCEDURE record_payment (
    p_patient_id IN NUMBER,
    p_amount IN NUMBER
) AS
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Payment must be positive');
    END IF;
    UPDATE patients SET paid_amount = paid_amount + p_amount
    WHERE patient_id = p_patient_id
      AND paid_amount + p_amount <= bill_amount;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Patient missing or payment exceeds balance');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Payment recorded');
END;
/

BEGIN
    record_payment(201, 1000);
END;
/

SELECT paid_amount FROM patients WHERE patient_id = 201;
ROLLBACK;

-- 7.5 (c) Stored function: outstanding balance
CREATE OR REPLACE FUNCTION get_balance (
    p_patient_id IN NUMBER
) RETURN NUMBER AS
    v_balance NUMBER(10,2);
BEGIN
    SELECT bill_amount - paid_amount INTO v_balance
    FROM patients WHERE patient_id = p_patient_id;
    RETURN v_balance;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

SELECT patient_id, get_balance(patient_id) AS balance
FROM patients ORDER BY patient_id;

-- 7.6 (d) INSERT, UPDATE and DELETE triggers
CREATE OR REPLACE TRIGGER trg_patient_insert
AFTER INSERT ON patients FOR EACH ROW
BEGIN
    INSERT INTO patient_audit(patient_id, action_type,
                              old_bill, new_bill)
    VALUES(:NEW.patient_id, 'INSERT', NULL, :NEW.bill_amount);
END;
/

CREATE OR REPLACE TRIGGER trg_patient_update
AFTER UPDATE ON patients FOR EACH ROW
BEGIN
    INSERT INTO patient_audit(patient_id, action_type,
                              old_bill, new_bill)
    VALUES(:NEW.patient_id, 'UPDATE', :OLD.bill_amount,
           :NEW.bill_amount);
END;
/

CREATE OR REPLACE TRIGGER trg_patient_delete
AFTER DELETE ON patients FOR EACH ROW
BEGIN
    INSERT INTO patient_audit(patient_id, action_type,
                              old_bill, new_bill)
    VALUES(:OLD.patient_id, 'DELETE', :OLD.bill_amount, NULL);
END;
/

SAVEPOINT before_trigger_test;
INSERT INTO patients VALUES
    (206, 'Farah', 'General', 4000, 1000);
UPDATE patients SET bill_amount = 4500 WHERE patient_id = 206;
DELETE FROM patients WHERE patient_id = 206;
SELECT patient_id, action_type, old_bill, new_bill
FROM patient_audit ORDER BY audit_id;
ROLLBACK TO before_trigger_test;

-- 7.7 (e) Implicit cursor
BEGIN
    UPDATE patients SET paid_amount = paid_amount + 500
    WHERE department = 'Cardiology'
      AND paid_amount + 500 <= bill_amount;
    DBMS_OUTPUT.PUT_LINE('Updated rows: ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/

-- 7.8 (e) Explicit cursor
DECLARE
    CURSOR c_due IS
        SELECT patient_name, bill_amount - paid_amount AS due
        FROM patients WHERE bill_amount > paid_amount
        ORDER BY patient_id;
    v_name patients.patient_name%TYPE;
    v_due NUMBER(10,2);
BEGIN
    OPEN c_due;
    LOOP
        FETCH c_due INTO v_name, v_due;
        EXIT WHEN c_due%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ': ' || v_due);
    END LOOP;
    CLOSE c_due;
END;
/

-- ======================================================================
-- OUTPUT
-- ======================================================================

-- 7.1 Create tables and insert data
-- PATIENT_ID PATIENT_NAME BALANCE
-- ---------- ------------ -------
--        201 Asha            4000
--        202 Bala               0
--        203 Charan         12000
--        204 Deepa           4000
--        205 Eshan           4000

-- 7.2 (a) User-input conditional PL/SQL block
-- Enter patient ID: 203
-- Charan: High outstanding
-- Enter patient ID: 202
-- Bala: Fully paid
-- Enter patient ID: 999
-- Patient not found

-- 7.3 (b) Exception handling: named and unexpected exceptions
-- NO_DATA_FOUND handled
-- TOO_MANY_ROWS handled
-- ZERO_DIVIDE handled

-- 7.4 (c) Stored procedure: record payment
-- Payment recorded
-- PAID_AMOUNT
-- -----------
--        9000
-- (ROLLBACK restores paid_amount of patient 201 to 8000)

-- 7.5 (c) Stored function: outstanding balance
-- PATIENT_ID BALANCE
-- ---------- -------
--        201    4000
--        202       0
--        203   12000
--        204    4000
--        205    4000

-- 7.6 (d) INSERT, UPDATE and DELETE triggers
-- PATIENT_ID ACTION_TYPE OLD_BILL NEW_BILL
-- ---------- ----------- -------- --------
--        206 INSERT
--        206 UPDATE          4000     4500
--        206 DELETE          4500
-- (ROLLBACK TO before_trigger_test removes these audit rows and the DML effects)

-- 7.7 (e) Implicit cursor
-- Updated rows: 2

-- 7.8 (e) Explicit cursor
-- Asha: 4000
-- Charan: 12000
-- Deepa: 4000
-- Eshan: 4000
