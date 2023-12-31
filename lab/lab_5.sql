-- Cu un tabel indexat de record

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_emp_data IS RECORD (id employees.employee_id%TYPE, salary employees.salary%TYPE);
    TYPE t_emp_table IS TABLE OF t_emp_data INDEX BY BINARY_INTEGER;
    v_worst_paid t_emp_table;
    v_index BINARY_INTEGER;
    v_local t_emp_data;
BEGIN
    WITH ordered_salaries AS (
        SELECT employee_id, salary
        FROM EMPLOYEES
        WHERE ((commission_pct = 0) OR  (commission_pct IS NULL))
        ORDER BY salary
    )
    SELECT employee_id, salary
    BULK COLLECT INTO v_worst_paid
    FROM ordered_salaries
    WHERE ROWNUM <= 10;

    DBMS_OUTPUT.PUT_LINE('Worst paid:');
    FOR v_index IN v_worst_paid.FIRST..v_worst_paid.LAST
    LOOP
        v_local := v_worst_paid(v_index);
        DBMS_OUTPUT.PUT('ID '||v_local.id||' - '||v_local.salary||'$');
        v_local.salary := v_local.salary * 1.05;
        DBMS_OUTPUT.PUT_LINE(' - will update to '||v_local.salary||'$');
        v_worst_paid(v_index).salary := v_local.salary;
    END LOOP;
    
    FORALL v_index IN v_worst_paid.FIRST..v_worst_paid.LAST
    UPDATE employees
    SET salary = v_worst_paid(v_index).salary
    WHERE employee_id = v_worst_paid(v_index).id;
    
    ROLLBACK;
END;
/

-- Cu doua tabele imbricate de %TYPE

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_ids IS TABLE OF employees.employee_id%TYPE;
    TYPE t_salaries IS TABLE OF employees.salary%TYPE;
    v_ids t_ids;
    v_salaries t_salaries;
    v_index BINARY_INTEGER;
BEGIN
    WITH ordered_salaries AS (
        SELECT employee_id, salary
        FROM EMPLOYEES
        WHERE ((commission_pct = 0) OR  (commission_pct IS NULL))
        ORDER BY salary
    )
    SELECT employee_id, salary
    BULK COLLECT INTO v_ids, v_salaries
    FROM ordered_salaries
    WHERE ROWNUM <= 10;

    DBMS_OUTPUT.PUT_LINE('Worst paid:');
    FOR v_index IN v_ids.FIRST..v_ids.LAST
    LOOP
        DBMS_OUTPUT.PUT('ID '||v_ids(v_index)||' - '||v_salaries(v_index)||'$');
        v_salaries(v_index) := v_salaries(v_index) * 1.05;
        DBMS_OUTPUT.PUT_LINE(' - will update to '||v_salaries(v_index)||'$');
    END LOOP;
    
    FORALL v_index IN v_ids.FIRST..v_ids.LAST
    UPDATE employees
    SET salary = v_salaries(v_index)
    WHERE employee_id = v_ids(v_index);
    
    ROLLBACK;
END;
/
