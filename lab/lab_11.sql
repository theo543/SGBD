/*
E1. Definiți un declanșator care să permită ștergerea informațiilor din tabelul dept_*** decât dacă
utilizatorul este SCOTT.
*/

CREATE OR REPLACE TRIGGER delete_interzis_user_theo
    BEFORE DELETE ON departments
BEGIN
    IF USER = 'THEO'
    THEN
        raise_application_error(-20010, 'User THEO nu are are acces la DELETE pe departments.');
    END IF;
END;

DELETE FROM departments
WHERE department_id = 1;

DROP TRIGGER delete_interzis_user_theo;

/*
E2. Creați un declanșator prin care să nu se permită mărirea comisionului astfel încât să depășească
50% din valoarea salariului.
*/

UPDATE employees
SET commission_pct = 0.6
WHERE employee_id = 100;

CREATE OR REPLACE TRIGGER limita_comision
    BEFORE UPDATE ON employees
    FOR EACH ROW
BEGIN
    IF  NOT (:old.commission_pct IS NOT NULL AND :old.commission_pct > 0.5)
        AND (:new.commission_pct IS NOT NULL AND :new.commission_pct > 0.5)
    THEN
        raise_application_error(-20011, 'Comisionul nu poate depăși 50%.');
    END IF;
END;

UPDATE employees
SET commission_pct = 0.7
WHERE employee_id = 100;

UPDATE employees
SET commission_pct = 2 * commission_pct;

UPDATE employees
SET commission_pct = NULL
WHERE employee_id = 100;

UPDATE employees
SET commission_pct = 0.7
WHERE employee_id = 100;

DROP TRIGGER limita_comision;

/*
E3. a.  Introduceți  în  tabelul  info_dept_***  coloana  numar  care  va  reprezenta  pentru  fiecare
departament  numărul de angajați care lucrează în departamentul respectiv. Populați  cu  date
această coloană pe baza informațiilor din schemă.
b. Definiți un declanșator care va  actualiza  automat  această coloană în funcție de actualizările
realizate asupra tabelului info_emp_***.
*/

CREATE TABLE info_departments (
    department_id PRIMARY KEY,
    count NOT NULL
)
AS
    SELECT department_id, COUNT(employee_id) AS count
    FROM employees
    JOIN departments
    USING (department_id)
    GROUP BY department_id
    UNION
    SELECT department_id, 0
    FROM departments
    LEFT JOIN employees
    USING (department_id)
    WHERE employee_id IS NULL;

CREATE OR REPLACE PROCEDURE update_count_emp(old_dep_id departments.department_id%TYPE, new_dep_id departments.department_id%TYPE)
AS
    BEGIN
        IF UPDATING AND old_dep_id = new_dep_id
        THEN
            RETURN;
        END IF;

        IF DELETING OR UPDATING
        THEN
            UPDATE info_departments
            SET count = count - 1
            WHERE info_departments.department_id = old_dep_id;
        END IF;

        IF INSERTING OR UPDATING
        THEN
            UPDATE info_departments
            SET count = count + 1
            WHERE info_departments.department_id = new_dep_id;
        END IF;
END;

CREATE OR REPLACE TRIGGER update_info_departments_count
    BEFORE INSERT OR DELETE OR UPDATE ON employees
    FOR EACH ROW
BEGIN
    update_count_emp(:OLD.department_id, :NEW.department_id);
END;

UPDATE employees
SET department_id = 90
WHERE department_id = 100;

SELECT department_id, count FROM info_departments
WHERE department_id = 90 OR department_id = 100;

INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (1111, 'a', 'b', 'c', 1, SYSDATE, 'IT_PROG', 1, NULL, 100, 100);

SELECT count FROM info_departments
WHERE department_id = 100;

DELETE FROM employees
WHERE department_id = 100;

SELECT count FROM info_departments
WHERE department_id = 100;

UPDATE employees
SET department_id = 110
WHERE department_id = 110;

SELECT count FROM info_departments
WHERE department_id = 110;

ROLLBACK;

DROP PROCEDURE update_count_emp;
DROP TRIGGER update_info_departments_count;
DROP TABLE info_departments;
