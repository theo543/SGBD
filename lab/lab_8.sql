/*
E2.Modificați exercițiul anterior astfel încât să obțineți și următoarele informații:
- un număr de ordine pentru fiecare angajat care va fi resetat pentru fiecare job
- pentru fiecare job
    - numărul de angajați
    - valoarea lunară a veniturilor angajaților
    - valoarea medie a veniturilor angajaților
- indiferent job
    - numărul total de angajați
    - valoarea totală lunară a veniturilor angajaților
    - valoarea medie a veniturilor angajaților
*/

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
    v_nr_de_ordine BINARY_INTEGER;
    v_total_salary_per_job BINARY_INTEGER;
    v_nr_ang BINARY_INTEGER := 0;
    v_total_salary BINARY_INTEGER := 0;
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
        v_nr_de_ordine := 1;
        v_total_salary_per_job := 0;
        LOOP
            DBMS_OUTPUT.PUT_LINE('    Nr. '||v_nr_de_ordine||': '||v_angajat.name||', salariu '||v_angajat.salary);
            v_total_salary_per_job := v_total_salary_per_job + v_angajat.salary;
            v_nr_de_ordine := v_nr_de_ordine + 1;
            FETCH c_angajati INTO v_angajat;
            EXIT WHEN c_angajati%NOTFOUND;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--- Statistici pt. job "'||v_job.job_title||'": ---');
        DBMS_OUTPUT.PUT_LINE('Nr. total de angajati: '||c_angajati%ROWCOUNT);
        v_nr_ang := v_nr_ang + c_angajati%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Salariu total al angajatilor: '||v_total_salary_per_job);
        DBMS_OUTPUT.PUT_LINE('Salariu mediu al angajatilor: '||v_total_salary_per_job / c_angajati%ROWCOUNT);
        v_total_salary := v_total_salary + v_total_salary_per_job;
        CLOSE c_angajati;
    END LOOP;
    CLOSE c_jobs;
    DBMS_OUTPUT.NEW_LINE();
    DBMS_OUTPUT.PUT_LINE('--- Statistici pt. intreaga companie ----');
    DBMS_OUTPUT.PUT_LINE('Nr. total de angajati: '||v_nr_ang);
    DBMS_OUTPUT.PUT_LINE('Salariu total al angajatilor: '||v_total_salary);
    DBMS_OUTPUT.PUT_LINE('Salariu mediu al angajatilor: '||v_total_salary / v_nr_ang);
END;
/

ROLLBACK;
