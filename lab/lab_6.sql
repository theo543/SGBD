-- Cu doi vectori de %TYPE

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_ids IS VARRAY(10) OF employees.employee_id%TYPE;
    TYPE t_salaries IS VARRAY(10) OF employees.salary%TYPE;
    v_ids t_ids;
    v_salaries t_salaries;
    v_index BINARY_INTEGER;
    TOO_MANY_VARRAY_VALUES EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOO_MANY_VARRAY_VALUES, -22165); -- varray overflow error code
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
EXCEPTION
    WHEN TOO_MANY_VARRAY_VALUES THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: '||SQLERRM||' - trebuie crescuta dimensiunea maxima a vectorului!');
END;
/
