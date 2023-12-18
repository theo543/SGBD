/*
Laborator6_PLSQL.pdf

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

/*
Laborator7_PLSQL.pdf

E1. Să se creeze un bloc PL/SQL care afişează radicalul unei variabile introduse de la tastatură. Să
se trateze cazul în care valoarea variabilei este negativă. Gestiunea  erorii  se  va  realiza  prin 
definirea unei excepţii de către utilizator, respectiv  prin  captarea  erorii  interne  a  sistemului. 
Codul şi mesajul erorii vor fi introduse în tabelul error_***(cod, mesaj).
*/

CREATE OR REPLACE PACKAGE pkg_sqrt
AS
    imaginary_numbers_not_supported EXCEPTION;
    PRAGMA EXCEPTION_INIT (imaginary_numbers_not_supported, -20005);
    FUNCTION checked_sqrt(x NUMBER) RETURN NUMBER;
END pkg_sqrt;

CREATE OR REPLACE PACKAGE BODY pkg_sqrt AS
    FUNCTION checked_sqrt(x NUMBER) RETURN NUMBER
    AS
    BEGIN
        IF x < 0 THEN
            raise_application_error(-20005, 'sqrt('||x||') would be an imaginary number');
        END IF;
        RETURN sqrt(x);
    END;
END pkg_sqrt;

CREATE SEQUENCE seq_error_sqrt INCREMENT BY 1 START WITH 1;

CREATE table error_sqrt (
    id_error_sqrt NUMBER(10) DEFAULT seq_error_sqrt.nextval PRIMARY KEY,
    code NUMBER(10),
    msg VARCHAR2(255)
);

BEGIN
    FOR num IN -10..10
    LOOP
        DECLARE
            v_result BINARY_INTEGER;
        BEGIN
            dbms_output.PUT('Attempting to take square root of number '||num||'...');
            IF MOD(num, 2) = 0
            THEN
                dbms_output.PUT(' using checked_sqrt...');
                v_result := pkg_sqrt.checked_sqrt(num);
            ELSE
                dbms_output.PUT(' using sqrt...');
                v_result := sqrt(num);
            END IF;
            dbms_output.PUT_LINE(' Got result '||v_result);
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE(' Exception occured. Logging code '||SQLCODE||' and message '||SQLERRM||' to error_sqrt');
                DECLARE
                    v_code error_sqrt.code%TYPE := SQLCODE;
                    v_errm error_sqrt.msg%TYPE := SQLERRM;
                BEGIN
                    INSERT INTO error_sqrt (code, msg) VALUES (v_code, v_errm);
                END;
        END;
    END LOOP;
END;

SELECT * FROM error_sqrt;

DROP TABLE error_sqrt;
DROP SEQUENCE seq_error_sqrt;
DROP PACKAGE pkg_sqrt;

/*
E2. Să se creeze un bloc PL/SQL prin care să se afişeze numele salariatului (din tabelul emp_***)
care câştigă un anumit salariu. Valoarea salariului se introduce de la tastatură. Se va testa
programul pentru următoarele valori: 500, 3000 şi 5000.
Dacă interogarea  nu  întoarce  nicio linie, atunci să se trateze excepţia şi să se afişeze mesajul
“nu exista salariati care sa castige acest salariu ”.  Dacă interogarea  întoarce  o singură linie,
atunci să se afişeze numele salariatului. Dacă interogarea întoarce mai multe linii, atunci să se
afişeze mesajul “exista mai mulţi salariati care castiga acest salariu”.
*/

DECLARE
    v_query_salary employees.salary%TYPE := &p_query_salary;
    v_employee_name VARCHAR2(255);
BEGIN
    SELECT first_name || ' ' || last_name
    INTO v_employee_name
    FROM employees
    WHERE salary = v_query_salary;
    dbms_output.put_line(v_employee_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('nu exista salariati care sa castige acest salariu: '||v_query_salary);
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('exista mai mulţi salariati care castiga acest salariu: '||v_query_salary);
END;

/*
E3. Să se creeze un bloc PL/SQL  care tratează eroarea apărută în cazul în care se modifică codul
unui departament în care lucrează angajaţi.
*/

DECLARE
    child_record_found EXCEPTION;
    PRAGMA EXCEPTION_INIT (child_record_found, -02292);
BEGIN
    UPDATE departments
    SET department_id = 1
    WHERE department_id = 10;
EXCEPTION
    WHEN child_record_found THEN
        dbms_output.PUT_LINE('Nu se poate schimba codul deoarece există angajați în acest departament.');
END;

/*
E4. Să se creeze un   bloc  PL/SQL  prin care se afişează numele departamentului 10 dacă numărul
său de angajaţi este într-un interval dat de la tastatură. Să se trateze cazul în care departamentul
nu îndeplineşte această condiţie.
*/

DECLARE
    v_lower BINARY_INTEGER := &p_lower;
    v_upper BINARY_INTEGER := &p_upper;
    v_dname VARCHAR2(255);
BEGIN
    SELECT department_name
    INTO v_dname
    FROM departments
    JOIN employees
    USING (department_id)
    WHERE department_id = 10
    GROUP BY department_id, department_name
    HAVING COUNT(employee_id) BETWEEN v_lower AND v_upper;
    dbms_output.PUT_LINE(v_dname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.PUT_LINE('Departamentul 10 nu are între '||v_lower||' și '||v_upper||' angajați.');
END;

/*
E5. Să se modifice numele unui departament al cărui cod este dat de la tastatură. Să se trateze cazul
în care nu există acel departament. Tratarea excepţie se va face în secţiunea executabilă.
*/

DECLARE
    v_dep BINARY_INTEGER := &p_dep;
    v_new_name VARCHAR2(255) := &p_new_name;
BEGIN
    UPDATE departments
    SET department_name = v_new_name
    WHERE department_id = v_dep;
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.PUT_LINE('Nu există departamentul '||v_dep||'.');
    END IF;
END;

/*
E6. Să se creeze un bloc PL/SQL  care afişează numele departamentului ce se află într-o anumită
locaţie şi numele departamentului ce are un anumit cod (se vor folosi două comenzi SELECT).
Să se trateze excepţia NO_DATA_FOUND şi să se afişeze care dintre comenzi a determinat
eroarea.  Să se rezolve problema în două moduri.
*/

DECLARE
    v_which VARCHAR2(255) := 'locație';
    v_name  VARCHAR2(255);
BEGIN
    SELECT department_name
    INTO v_name
    FROM departments
    WHERE location_id = 1700 AND ROWNUM = 1;
    dbms_output.put_line(v_name);
    v_which := 'id';
    SELECT department_name
    INTO v_name
    FROM departments
    WHERE department_id = 1 AND ROWNUM = 1;
    dbms_output.put_line(v_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.PUT_LINE('Eroare la cererea pentru '||v_which);
END;

DECLARE
    v_name  VARCHAR2(255);
BEGIN
    BEGIN
        SELECT department_name
        INTO v_name
        FROM departments
        WHERE location_id = 1700 AND ROWNUM = 1;
        dbms_output.put_line(v_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.PUT_LINE('Eroare la cererea pentru locație');
    END;
    BEGIN
        SELECT department_name
        INTO v_name
        FROM departments
        WHERE department_id = 1 AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.PUT_LINE('Eroare la cererea pentru id');
    END;
END;
