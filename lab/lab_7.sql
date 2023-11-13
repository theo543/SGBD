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

-- E1.Pentru fiecare job (titlu – care va fi afișat o singură dată) obțineți lista angajaților (nume și
-- salariu) care lucrează în prezent pe jobul respectiv. Tratați cazul în care nu există angajați care
-- să lucreze în prezent pe un anumit job. Rezolvați problema folosind:
-- a. cursoare clasice
-- b. ciclu cursoare
-- c. ciclu cursoare cu subcereri
-- d. expresii cursor

INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES ('TEST_JOB', 'Job fara angajati (test).', 0, 0);

-- a. cursoare clasice / explicite

DECLARE
    CURSOR c_jobs
        IS
        SELECT job_id, job_title
        FROM jobs;
    v_job c_jobs%ROWTYPE;
    CURSOR c_angajati(required_job_id jobs.job_id%TYPE)
        IS
        SELECT first_name || ' ' || last_name name, salary
        FROM employees
        WHERE job_id = required_job_id;
    v_angajat c_angajati%ROWTYPE;
BEGIN
    OPEN c_jobs;
    LOOP
        FETCH c_jobs INTO v_job;
        EXIT WHEN c_jobs%NOTFOUND;
        OPEN c_angajati(v_job.job_id);
        FETCH c_angajati INTO v_angajat;
        IF c_angajati%NOTFOUND
        THEN
            DBMS_OUTPUT.PUT_LINE('--- Nu sunt angajati cu jobul "'||v_job.job_title||'" ---');
            CLOSE c_angajati;
            CONTINUE;
        END IF;
        DBMS_OUTPUT.PUT_LINE('--- Angajati din job "'||v_job.job_title||'": ---');
        LOOP
            DBMS_OUTPUT.PUT_LINE('    '||v_angajat.name||', salariu '||v_angajat.salary);
            FETCH c_angajati INTO v_angajat;
            EXIT WHEN c_angajati%NOTFOUND;
        END LOOP;
        CLOSE c_angajati;
    END LOOP;
    CLOSE c_jobs;
END;
/

-- b. ciclu cursoare

DECLARE
    v_current_job jobs.job_id%TYPE := -1;
BEGIN
    FOR rowdata IN (
        SELECT job_id, job_title, EMPLOYEE_ID, first_name, last_name, salary
        FROM jobs
        LEFT JOIN employees
        USING (job_id)
    )
    LOOP
        IF rowdata.first_name IS NULL
        THEN
            dbms_output.PUT_LINE('--- Nu sunt angajati cu jobul "'||rowdata.job_title||'" ---');
            CONTINUE;
        END IF;
        IF v_current_job != rowdata.job_id
        THEN
            v_current_job := rowdata.job_id;
            dbms_output.PUT_LINE('--- Angajati din job "'||rowdata.job_title||'": ---');
        END IF;
        dbms_output.PUT_LINE('    '||rowdata.first_name||' '||rowdata.last_name||', salariu '||rowdata.salary);
    END LOOP;
END;

-- c. ciclu cursoare cu subcereri

DECLARE
    v_any_employees BOOLEAN;
BEGIN
    FOR job IN (SELECT job_id, job_title FROM JOBS)
    LOOP
        DBMS_OUTPUT.PUT_LINE('--- Angajati din job "'||job.job_title||'": ---');
        v_any_employees := FALSE;
        FOR angajat IN (
            SELECT first_name || ' ' || last_name name, salary
            FROM employees
            WHERE job_id = job.job_id
        )
        LOOP
            v_any_employees := TRUE;
            DBMS_OUTPUT.PUT_LINE('    '||angajat.name||', salariu '||angajat.salary);
        END LOOP;
        IF NOT v_any_employees
        THEN
            DBMS_OUTPUT.PUT_LINE('    Niciun angajat in acest job!');
        END IF;
    END LOOP;
END;
/
