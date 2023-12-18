/*
E4. Definiți  un  declanșator cu ajutorul căruia să se implementeze restricția conform căreia într-un
departament  nu  pot  lucra  mai  mult  de  45  persoane  (se  vor  utiliza  doar  tabelele  emp_***  și
dept_*** fără a modifica structura acestora).

Aș fi putut refolosi codul de la E3, dar era destul de urât, așa că am luat codul de la temă, care l-am scris mai frumos.
*/

/**
  Cod pentru testare.
*/

-- din sesiunea 1...
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
SELECT LEVEL + 1000, 'a', 'b', 'c@c.c'||LEVEL, 10, SYSDATE, 'IT_PROG', 100, 0, NULL, 30 FROM DUAL
CONNECT BY LEVEL < 30;

-- din sesiunea 2...
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
SELECT LEVEL + 3000, 'a', 'b', 'c@c.c'||(1000 + LEVEL), 10, SYSDATE, 'IT_PROG', 100, 0, NULL, 30 FROM DUAL
CONNECT BY LEVEL < 30;

DELETE FROM employees WHERE employee_id >= 1000;

/**
  Exemplu de trigger care NU funcționează. INSERT-urile vor fi blocare cu eroare MUTATING.
*/

CREATE OR REPLACE TRIGGER check_max_dept
    AFTER INSERT OR UPDATE ON employees
    FOR EACH ROW
DECLARE
    v_total NUMBER(10);
BEGIN
    SELECT COUNT(employee_id)
    INTO v_total
    FROM employees
    WHERE department_id = :NEW.department_id;
    IF v_total > 45 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nu pot fi peste 45 de angajați într-un departament!');
    END IF;
END;

DROP TRIGGER check_max_dept;

/**
  Trigger care funcționează corect.
*/

CREATE TABLE info_dept (
    department_id NUMBER(10) PRIMARY KEY,
    employee_count NUMBER(10) NOT NULL
);

INSERT INTO info_dept
    /* funcția COUNT va ignora id_angajat NULL */
    SELECT department_id, COUNT(employee_id)
    FROM departments
    LEFT JOIN employees
    USING (department_id)
    GROUP BY department_id

CREATE OR REPLACE TRIGGER update_info_dept
    FOR INSERT OR DELETE OR UPDATE ON employees
    COMPOUND TRIGGER

    v_emp_cnt NUMBER(10);

    BEFORE STATEMENT
    IS
    BEGIN
        -- Necesar pentru a funcționa cu două sesiuni care încercă să facă COMMIT simultan.
        LOCK TABLE info_dept IN EXCLUSIVE MODE;
    END BEFORE STATEMENT;

    BEFORE EACH ROW
    IS
    BEGIN
        IF DELETING OR UPDATING THEN
            UPDATE info_dept
            SET employee_count = employee_count - 1
            WHERE department_id = :OLD.department_id;
        END IF;
        IF INSERTING OR UPDATING THEN
            UPDATE info_dept
            SET employee_count = employee_count + 1
            WHERE department_id = :NEW.department_id
            RETURNING employee_count INTO v_emp_cnt;
            IF v_emp_cnt > 45 THEN
                raise_application_error(-20001, 'Nu pot fi mai mult de 45 de angajați într-un departament!');
            END IF;
        END IF;
    END BEFORE EACH ROW;
END;

DROP TRIGGER update_info_dept;
DROP TABLE info_dept;

/*
 Soluție alternativă în SQL declarativ.
 Această soluție nu blochează întregul tabel, dar totuși funcționează cu două sesiuni simultane.
 Este similară cu soluția anterioară, dar implementată la nivelul DBMS, și poate fi extinsă ușor la constrângeri multi-tabel.
 Un dezavantaj este că eroare va fi activată doar la COMMIT, ceea ce poate fi nonintuitiv, și poate duce la timp pierdut,
 lucrând cu o tranzacție care nu poate fi comisă.
*/

CREATE MATERIALIZED VIEW LOG ON employees
    WITH PRIMARY KEY, ROWID (department_id)
    INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW dpt_count
REFRESH FAST
ON COMMIT
AS
    SELECT department_id, COUNT(employee_id) as department_count
    FROM employees
    GROUP BY department_id;

ALTER TABLE dpt_count
ADD CONSTRAINT max_angajati_per_dept
CHECK (department_count <= 45);

SELECT * FROM dpt_count;

DROP MATERIALIZED VIEW dpt_count;
DROP MATERIALIZED VIEW LOG ON employees;
