-- 10. Pentru fiecare dintre departamentele 10, 20, 30 și 40, obțineți numele precum și lista numelor
-- angajaților care își desfășoară activitatea în cadrul acestora.

-- Cursor explicit.

DECLARE
    TYPE dep_ang_info IS RECORD(dep_name DEPARTMENTS.department_name%TYPE, ang_name VARCHAR2(100));
    CURSOR c_ang_dep(id_dep DEPARTMENTS.department_id%TYPE)
    IS
        SELECT department_name, first_name || ' ' || last_name FROM departments
        JOIN employees
        USING (department_id)
        WHERE department_id = id_dep;
    v_dep_ang_info dep_ang_info;
BEGIN
    FOR i IN 1..4
    LOOP
        OPEN c_ang_dep(i * 10);
        LOOP
            FETCH c_ang_dep INTO v_dep_ang_info;
            EXIT WHEN c_ang_dep%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_dep_ang_info.dep_name || ' => ' || v_dep_ang_info.ang_name);
        END LOOP;
        CLOSE c_ang_dep;
    END LOOP;
END;

-- Ciclu cursor.

BEGIN
    FOR i in 1..4
    LOOP
        FOR dep_name_ang_name IN (
            SELECT department_name, first_name || ' ' || last_name AS employee_name
            FROM DEPARTMENTS
            JOIN EMPLOYEES
            USING (department_id)
            WHERE department_id = i * 10
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(dep_name_ang_name.department_name || ' => ' || dep_name_ang_name.employee_name);
        END LOOP;
    END LOOP;
END;
