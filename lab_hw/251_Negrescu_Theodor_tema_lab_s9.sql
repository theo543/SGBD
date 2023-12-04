/*
    E7. Adaptați cerințele exercițiilor 2 și 4 (folosind ca bază cerințele exercițiilor 1, respectiv 3) pentru
    diagrama proiectului prezentată la materia Baze de Date din anul I. Rezolvați aceste două exerciții
    în PL/SQL, folosind baza de date proprie. (PARTIAL doar ex. 4)

    1. (adaptat)
    Definiți un subprogram prin care să obțineți orașul în care lucrează un angajat, folosind numele angajatului.
    Funcția trebuie să funcționeze chiar dacă utilizatorul introduce doar numele de familie sau doar prenumele.
    Tratați toate excepțiile ce pot fi generate.

    4. Rezolvați exercițiul 1 folosind o procedură stocată.
*/

CREATE OR REPLACE PROCEDURE e4_oras_angajat(v_nume IN angajat.nume%TYPE)
IS
    v_id angajat.id_angajat%TYPE;
    v_nume_oras oras.nume%TYPE;
    BEGIN
        SELECT id_angajat
        INTO v_id
        FROM angajat
        WHERE regexp_like(nume, '(^| )'||v_nume||'($| )', 'i');

        -- Imposibil să avem expectie la join, datorită constrângerilor
        -- FOREIGN KEY și NOT NULL pe id_restaurant și id_oras.
        SELECT oras.nume
        INTO v_nume_oras
        FROM angajat
        JOIN restaurant
        USING (id_restaurant)
        JOIN oras
        USING (id_oras)
        WHERE id_angajat = v_id;

        dbms_output.PUT_LINE('Lucrează în '||v_nume_oras||'.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20009, 'Nu s-a găsit un angajat cu nume sau prenume '||v_nume||'.');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20009, 'Input ambiguu: multiplii angajați găsiți cu nume sau prenume '||v_nume||'.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20009,'Alta eroare: '||SQLERRM);
END;
/

/*
    Găsește un nume a.î. count >= 1 pentru a cauza eroarea
*/
WITH fn AS (
    SELECT regexp_substr(nume, '(\w+)$', 1, 1, NULL, 1) AS nume FROM angajat
)
SELECT nume, COUNT(*) FROM fn
GROUP BY nume
ORDER BY COUNT(*) DESC;
/*
 Iulia si Anamaria ar trebui să cauzeze eroarea.
*/

DECLARE
    TYPE test_inputs IS VARRAY(10) OF angajat.nume%TYPE;
    v_test_inputs test_inputs := test_inputs('Adrian', 'Iulia', 'Trandafir', 'Trandafi', 'Iorga Irina', 'Anamaria', 'Stefan');
    esec_f2_oras_angajat EXCEPTION;
    PRAGMA EXCEPTION_INIT (esec_f2_oras_angajat, -20009);
BEGIN
    FOR i IN 1..v_test_inputs.LAST
    LOOP
        dbms_output.PUT(v_test_inputs(i) || ' => ');
        BEGIN
            e4_oras_angajat(v_test_inputs(i));
        EXCEPTION
            WHEN esec_f2_oras_angajat THEN
                dbms_output.put_line(SQLERRM);
        END;
    END LOOP;
END;
/

DROP PROCEDURE e4_oras_angajat;


/*
E5. Definiți un subprogram care obține pentru fiecare nume de departament ziua din săptămână în
care au fost angajate cele mai multe persoane, lista cu numele acestora, vechimea și venitul lor
lunar. Afișați mesaje corespunzătoare următoarelor cazuri:
- într-un departament nu lucrează niciun angajat;
- într-o zi din săptămână nu a fost nimeni angajat.
Observații:
a.  Numele departamentului și ziua apar o singură dată în rezultat.
b.  Rezolvați problema în două variante, după cum se ține  cont  sau  nu  de  istoricul  joburilor
angajaților.

E6. Modificați exercițiul anterior astfel încât lista cu numele angajaților să apară într-un clasament
creat în funcție de vechimea acestora în departament. Specificați  numărul  poziției din
clasament  și  apoi  lista  angajaților  care  ocupă acel loc. Dacă doi angajați  au  aceeași  vechime,
atunci aceștia ocupă aceeași poziție în clasament.
*/

CREATE TYPE e5_employee IS OBJECT (employee_id NUMBER(6), first_name VARCHAR2(50), last_name VARCHAR2(50), days_hired NUMBER(10), seniority_rank NUMBER(6));
CREATE TYPE e5_employees IS TABLE OF e5_employee;
CREATE TYPE e5_empty_days IS TABLE OF NUMBER(6);
CREATE TYPE e5_return IS OBJECT (empty_days e5_empty_days, max_day NUMBER(1), max_day_employees e5_employees);
CREATE TYPE emp_hire_date IS OBJECT (employee_id NUMBER(6), hire_date DATE);
CREATE TYPE emp_hire_dates IS TABLE OF emp_hire_date;
CREATE TYPE emp_hire_day IS OBJECT (employee_id NUMBER(6), hire_day NUMBER(1));
CREATE TYPE emp_hire_days IS TABLE OF emp_hire_day;


CREATE TABLE weekdays AS
SELECT 1 day_nr, 'Monday' day_name FROM DUAL
UNION
SELECT 2, 'Tuesday' FROM DUAL
UNION
SELECT 3, 'Wednesday' FROM DUAL
UNION
SELECT 4, 'Thursday' FROM DUAL
UNION
SELECT 5, 'Friday' FROM DUAL
UNION
SELECT 6, 'Saturday' FROM DUAL
UNION
SELECT 7, 'Sunday' FROM DUAL;

CREATE OR REPLACE FUNCTION e5_hire_stats(v_department_name VARCHAR2, use_job_history NUMBER)
RETURN e5_return
IS
    v_retval e5_return := e5_return(e5_empty_days(), 0, e5_employees());
    v_dep_id NUMBER(4);
    v_hire_dates emp_hire_dates;
    v_hire_days emp_hire_days;
    BEGIN
        SELECT department_id
        INTO v_dep_id
        FROM departments
        WHERE department_name = v_department_name;

        SELECT emp_hire_date(employee_id, hire_date)
        BULK COLLECT INTO v_hire_dates
        FROM employees
        WHERE department_id = v_dep_id;

        IF use_job_history != 0
        THEN
            DECLARE
                tmp emp_hire_dates := v_hire_dates;
            BEGIN
                WITH hire_dates AS (
                    SELECT employee_id, hire_date
                    FROM TABLE(tmp)
                    UNION
                    SELECT employee_id, jh.end_date AS hire_date
                    FROM TABLE(tmp)
                    JOIN job_history jh
                    USING (employee_id)
                )
                SELECT emp_hire_date(t1.employee_id, t1.hire_date)
                BULK COLLECT INTO v_hire_dates
                FROM hire_dates t1
                LEFT JOIN hire_dates t2
                ON t1.employee_id = t2.employee_id AND t1.hire_date < t2.hire_date
                WHERE t2.hire_date IS NULL;
            END;
        END IF;

        SELECT emp_hire_day(employee_id, TRUNC(hire_date) - TRUNC(hire_date, 'IW') + 1) AS hire_day
        BULK COLLECT INTO v_hire_days
        FROM TABLE(v_hire_dates);

        SELECT day_nr
        BULK COLLECT INTO v_retval.empty_days
        FROM weekdays
        LEFT JOIN TABLE(v_hire_days) hire_days
        ON weekdays.day_nr = hire_days.hire_day
        WHERE hire_days.hire_day IS NULL;

        IF v_retval.empty_days.LAST = 7 THEN
            RETURN v_retval;
        END IF;

        WITH day_counts AS (
            SELECT hire_day
            FROM TABLE(v_hire_days)
            GROUP BY hire_day
            ORDER BY COUNT(*) DESC
        )
        SELECT hire_day
        INTO v_retval.max_day
        FROM day_counts
        WHERE rownum = 1;

        WITH emp_to_rank AS (
            SELECT employee_id, first_name, last_name, SYSDATE - hire_date AS days_worked
            FROM employees
            JOIN TABLE (v_hire_days)
            USING (employee_id)
            WHERE hire_day = v_retval.max_day
            ORDER BY days_worked DESC
        )
        SELECT e5_employee(employee_id, first_name, last_name, days_worked, RANK() OVER (ORDER BY days_worked DESC))
        BULK COLLECT INTO v_retval.max_day_employees
        FROM emp_to_rank;

        RETURN v_retval;
END;
/

DECLARE
    v_dep_name VARCHAR2(50) := &p_dep_name;
    v_use_history BOOLEAN := &p_use_history;
    v_hire_stats e5_return;
BEGIN
    dbms_output.PUT_LINE('Stats for department "'||v_dep_name||'". '|| CASE WHEN v_use_history THEN 'U' ELSE 'Not u' END||'sing job history.');
    v_hire_stats := e5_hire_stats(v_dep_name, CASE WHEN v_use_history THEN 1 ELSE 0 END);
    IF v_hire_stats.max_day = 0 THEN
        dbms_output.PUT_LINE('Department has no employees.');
    ELSE
        FOR v_row IN (
            SELECT day_name FROM TABLE(v_hire_stats.empty_days) ed
            JOIN weekdays
            ON weekdays.day_nr = ed.column_value
        )
        LOOP
            dbms_output.PUT_LINE('No employees were hired on day '||v_row.day_name||'.');
        END LOOP;
        DECLARE
            v_day_name VARCHAR2(50);
        BEGIN
            SELECT day_name
            INTO v_day_name
            FROM weekdays
            WHERE day_nr = v_hire_stats.max_day;
            dbms_output.PUT_LINE('Weekday '||v_day_name||' has maximum number of hired employees.');
        END;
        DECLARE
            v_current_rank BINARY_INTEGER := 0;
            v_emp e5_employee;
        BEGIN
            FOR i IN 1..v_hire_stats.max_day_employees.last
            LOOP
                v_emp := v_hire_stats.max_day_employees(i);
                IF v_current_rank != v_emp.seniority_rank
                THEN
                    v_current_rank := v_emp.seniority_rank;
                    dbms_output.PUT_LINE('Seniority rank '||v_current_rank||':');
                END IF;
                dbms_output.PUT_LINE(v_emp.first_name||' '||v_emp.last_name||' (ID '||v_emp.employee_id||', hired '||v_emp.days_hired||' days ago).');
            END LOOP;
        END;
    END IF;
END;

DROP FUNCTION e5_hire_stats;
DROP TYPE emp_hire_days;
DROP TYPE emp_hire_day;
DROP TYPE emp_hire_dates;
DROP TYPE emp_hire_date;
DROP TYPE e5_return;
DROP TYPE e5_empty_days;
DROP TYPE e5_employees;
DROP TYPE e5_employee;
DROP TABLE weekdays;
