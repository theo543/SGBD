SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
    v_dep_id employees.department_id%TYPE := &p_dep_id;
    v_check_exists BINARY_INTEGER;
    v_emp_count BINARY_INTEGER;
    v_dep_type VARCHAR(20);
BEGIN
    SELECT COUNT(*)
    INTO v_check_exists
    FROM departments
    WHERE department_id = v_dep_id;
    SELECT COUNT(*)
    INTO v_emp_count
    FROM employees
    WHERE department_id = v_dep_id;
    v_dep_type := CASE
        WHEN v_check_exists = 0 THEN 'Nu exista'
        WHEN v_emp_count > 34 THEN 'Departament mare'
        WHEN v_emp_count >= 10 THEN 'Departament mediu'
        ELSE 'Departament mic'
    END;
    DBMS_OUTPUT.PUT_LINE('Departament '||v_dep_id||' => '||v_dep_type);
END;
/

SELECT d.department_id, COUNT(*) employee_count FROM departments d
JOIN employees e
ON e.department_id (+) = d.department_id
GROUP BY (d.department_id)
ORDER BY employee_count DESC;

/*
E2. Se dă următorul enunț: Pentru fiecare zi a lunii octombrie din 2023 (se vor lua în considerare și zilele din
lună în care nu au fost realizate împrumuturi) obțineți numărul de împrumuturi efectuate.
a. Încercați să rezolvați problema în SQL fără a folosi structuri ajutătoare.
b. Definiți tabelul octombrie_*** (data, nr_imprumuturi). Folosind PL/SQL populați cu date acest tabel.
Rezolvați în SQL problema dată.
*/

-- SQL

DROP TABLE octombrie_tne_2;

CREATE TABLE octombrie_tne_2 AS
WITH counts AS (
    SELECT TRUNC(book_date) data, COUNT(*) nr
    FROM rental
    GROUP BY (TRUNC(book_date))
),
each_day AS (
    SELECT TO_DATE('01-OCT-2023', 'DD-MON-YYYY') + LEVEL - 1 data FROM DUAL
    CONNECT BY LEVEL <= 31
)
SELECT data, NVL(nr, 0) nr_imprumuturi FROM each_day
LEFT JOIN counts
USING (data)
ORDER BY data;

SELECT * FROM octombrie_tne_2;

-- PL/SQL

CREATE TABLE octombrie_tne (
    data DATE PRIMARY KEY,
    nr_imprumuturi NUMBER(10) NOT NULL
);

DECLARE
    v_first_octombrie DATE := TO_DATE('01-OCT-2023', 'DD-MON-YYYY');
    v_current_date DATE;
    v_count_imprumut BINARY_INTEGER;
BEGIN
    DELETE FROM octombrie_tne;

    FOR v_day IN 1..31 LOOP
        v_current_date := v_first_octombrie + (v_day - 1);

        SELECT COUNT(*)
        INTO v_count_imprumut
        FROM rental
        WHERE TRUNC(book_date) = v_current_date;

        INSERT INTO octombrie_tne VALUES (v_current_date, v_count_imprumut);
    END LOOP;
END;
/

SELECT * FROM octombrie_tne;
