/*
1. Enunțați o cerere în limbaj natural pe schema,
care să implice în rezolvare utilizarea unui cursor dinamic.
Scrieți un subprogram care utilizează acest cursor.
Vor fi afișate informațiile din cel puțin două coloane returnate de cursor.
Tratați erorile care pot să apară la apelare. Testați.

Sa se afiseze angajatii din compania, sortati fie dupa salariu,
fie dupa job, fie dupa numarul de proiecte la care lucreaza.
Userul decide daca sortarea e crescatoare sau descrescatore.
*/

DECLARE
    v_cursor SYS_REFCURSOR;
    v_alegere BINARY_INTEGER := &p_alegere;
    /* 1 = salariu, 2 = job, 3 = proiecte */
    v_directie BINARY_INTEGER := &p_directie;
    /* 1 = ASC, 2 = DESC */
    v_emp_id EMPLOYEES.employee_id%TYPE;
    v_emp_name VARCHAR2(100);
    v_emp_salary EMPLOYEES.salary%TYPE;
    v_emp_job EMPLOYEES.job_id%TYPE;
    v_nr_proiecte BINARY_INTEGER;
    v_order_by VARCHAR(20);
    v_order_asc_desc VARCHAR(5);
    input_invalid_pt_sql_dinamic EXCEPTION;
    PRAGMA EXCEPTION_INIT (input_invalid_pt_sql_dinamic, -20000);
BEGIN
    CASE v_alegere
        WHEN 1 THEN v_order_by := 'salary';
        WHEN 2 THEN v_order_by := 'job_id';
        WHEN 3 THEN v_order_by := 'nr_proiecte';
        ELSE raise_application_error(-20000, 'v_alegere invalid');
    END CASE;
    CASE v_directie
        WHEN 1 THEN v_order_asc_desc := 'ASC';
        WHEN 2 THEN v_order_asc_desc := 'DESC';
        ELSE raise_application_error(-20000, 'v_directie invalid');
    END CASE;
    OPEN v_cursor FOR
        'WITH project_counts AS (
            SELECT employee_id, COUNT(*) nr_proiecte FROM works_on
            GROUP BY employee_id
        )
        SELECT employee_id, first_name || '' '' || last_name emp_name, salary, job_id, nr_proiecte
        FROM employees
        JOIN project_counts
        USING (employee_id)
        ORDER BY ' || v_order_by || ' ' || v_order_asc_desc;
    LOOP
        FETCH v_cursor INTO v_emp_id, v_emp_name, v_emp_salary, v_emp_job, v_nr_proiecte;
        EXIT WHEN v_cursor%NOTFOUND;
        dbms_output.PUT_LINE(v_emp_id||': '||v_emp_salary||', cu salariu '||v_emp_salary||', cu job '||v_emp_job||', nr. proiecte la care lucreaza: '||v_nr_proiecte);
    END LOOP;
    CLOSE v_cursor;
END;
/

/*
2. Definiți un bloc PL/SQL în care procedura proc_ex2 (Exemplul 6.2 din SGBD6 - PLSQL Subprograme.pdf)
este apelată pentru fiecare produs din categoria 'it' (nivel 1).
Prețul acestor produse va fi micșorat cu 5%.
*/

CREATE PROCEDURE proc_ex1 (v_id produse.id_produs%TYPE, v_procent NUMBER)
AS
BEGIN
    UPDATE produse
    SET pret_unitar = pret_unitar + pret_unitar * v_procent
    WHERE id_produs = v_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR (-20000,'Nu exista produsul');
END;

BEGIN
    FOR produs IN (
        SELECT id_produs
        FROM PRODUSE
        WHERE id_categorie = 1
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Scădere preț - produs '||produs.id_produs);
        proc_ex1(produs.id_produs, -0.05);
    END LOOP;
END;

ROLLBACK;

DROP PROCEDURE proc_ex1;
