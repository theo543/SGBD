/*
 E2. (procedură) Modificați funcția definită la exercițiul 2, respectiv procedura definită la exercițiul 4 astfel încât
să determine inserarea în tabelul info_*** a informațiile corespunzătoare fiecărui caz
determinat de valoarea dată pentru parametru:
- există un singur angajat cu numele specificat;
- există mai mulți angajați cu numele specificat;
- nu există angajați cu numele specificat.
*/

CREATE SEQUENCE seq_info_proc START WITH 1 INCREMENT BY 1;
CREATE TABLE info_proc (
    id         NUMBER DEFAULT seq_info_proc.nextval PRIMARY KEY,
    utilizator VARCHAR2(50),
    data       DATE,
    comanda    VARCHAR2(255),
    nr_linii   NUMBER(6),
    eroare     NUMBER
);

CREATE OR REPLACE PROCEDURE p4(v_nume employees.last_name%TYPE)
IS
    salariu employees.salary%TYPE;

    PROCEDURE insert_log(error_code NUMBER)
    IS
        BEGIN
            INSERT INTO info_proc (utilizator, data, comanda, nr_linii, eroare)
            VALUES ((SELECT USER FROM DUAL),
                    (SELECT SYSDATE FROM DUAL),
                    'SELECT salary INTO salariu'||chr(10)||'FROM employees'||chr(10)||'WHERE last_name = '||v_nume||chr(10),
                    (SELECT COUNT(*) FROM employees WHERE last_name = v_nume),
                    error_code);
    END insert_log;

    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE last_name = v_nume;

        DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
        insert_log(0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            insert_log(-20001);
        WHEN TOO_MANY_ROWS THEN
            insert_log(-20002);
        WHEN OTHERS THEN
            insert_log(-20003);
END p4;
/

BEGIN
    p4('Bell');
    p4('Grant');
    p4('non-existent');
END;
/

SELECT * FROM info_proc;

/*

1,THEO,2023-11-27 12:38:21,"SELECT salary INTO salariu
FROM employees
WHERE last_name = Bell
",1,0

2,THEO,2023-11-27 12:38:21,"SELECT salary INTO salariu
FROM employees
WHERE last_name = Grant
",2,-20002

3,THEO,2023-11-27 12:38:21,"SELECT salary INTO salariu
FROM employees
WHERE last_name = non-existent
",0,-20001

*/

DROP PROCEDURE p4;
DROP TABLE info_proc;
DROP SEQUENCE seq_info_proc;



/*
 E3. Definiți o funcție stocată care determină numărul de angajați care au avut cel puțin 2 joburi
diferite și care în prezent lucrează într-un oraș dat ca parametru. Tratați cazul în care orașul dat
ca parametru nu există, respectiv cazul în care în orașul dat nu lucrează niciun angajat. Inserați
în tabelul info_*** informațiile corespunzătoare fiecărui caz determinat de valoarea dată pentru
parametru.
*/

CREATE SEQUENCE seq_info_fn_e3;
CREATE TABLE info_fn_e3(
    id         NUMBER DEFAULT seq_info_fn_e3.nextval PRIMARY KEY,
    utilizator VARCHAR2(50),
    data       DATE,
    oras_cerut VARCHAR2(30),
    rezultat   NUMBER,
    eroare_msg VARCHAR2(255)
);

CREATE OR REPLACE FUNCTION fn_e3(v_oras locations.city%TYPE)
RETURN NUMBER
IS

    locatii_cu_orasul  BINARY_INTEGER;
    angajati_cu_orasul BINARY_INTEGER;
    raspuns            BINARY_INTEGER;

    PROCEDURE insert_log(rezultat NUMBER, error_msg VARCHAR2)
    IS
        BEGIN
            INSERT INTO info_fn_e3 (utilizator, data, oras_cerut, rezultat, eroare_msg)
            VALUES ((SELECT USER FROM DUAL),
                    (SELECT SYSDATE FROM DUAL),
                    v_oras,
                    rezultat,
                    error_msg);
    END insert_log;

    BEGIN
        SELECT COUNT(location_id)
        INTO locatii_cu_orasul
        FROM locations
        WHERE city = v_oras;

        IF locatii_cu_orasul = 0 THEN
            insert_log(0, 'Nu există locații în orașul "'||v_oras||'".');
            RETURN 0;
        END IF;

        SELECT COUNT(employee_id)
        INTO angajati_cu_orasul
        FROM employees
        JOIN departments
        USING (department_id)
        JOIN locations
        USING (location_id)
        WHERE city = v_oras;

        IF angajati_cu_orasul = 0 THEN
            insert_log(0, 'Deși există locații în orașul "'||v_oras||'", nu lucreză nimeniun angajat acolo momentan.');
            RETURN 0;
        END IF;

        SELECT COUNT(employee_id)
        INTO raspuns
        FROM employees
        JOIN departments
        USING (department_id)
        JOIN locations
        USING (location_id)
        WHERE city = v_oras AND EXISTS(
            SELECT *
            FROM job_history
            WHERE job_history.employee_id = employees.employee_id
        );

        IF raspuns = 0 THEN
            insert_log(0, 'Desi exista angajați care lucreză in orașul "'||v_oras||'", nu există unul care să fi avut cel puțin două joburi.');
            RETURN 0;
        END IF;

        insert_log(raspuns, 'Găsit '||raspuns||' angajați la căutarea de angajați in orasul "'||v_oras||'" care să fi avut cel puțin două joburi.');
        RETURN raspuns;
END fn_e3;
/

DECLARE
    eroare_msg info_fn_e3.eroare_msg%TYPE;
    TYPE test_cases IS VARRAY(50) OF VARCHAR2(255);
    v_test_cases test_cases := test_cases(
        'Bucharest', 'Craiova', '___nonexistent___', 'Roma', 'Venice', 'Tokyo', 'Hiroshima', 'Southlake', 'South San Francisco', 'South Brunswick', 'Seattle', 'Toronto', 'Whitehorse', 'Beijing', 'Bombay', 'Sydney', 'Singapore', 'London', 'Oxford', 'Stretford', 'Munich', 'Sao Paulo', 'Geneva', 'Bern', 'Utrecht', 'Mexico City'
    );
BEGIN
    FOR i IN 1..v_test_cases.LAST
    LOOP
        dbms_output.PUT_LINE(v_test_cases(i)||' => '||fn_e3(v_test_cases(i)));
        SELECT eroare_msg
        INTO eroare_msg
        FROM info_fn_e3
        WHERE id = (SELECT MAX(id) FROM info_fn_e3);
        dbms_output.PUT_LINE(eroare_msg);
    END LOOP;
END;
/

/*
 Bucharest => 0
Nu există locații în orașul "Bucharest".
Craiova => 0
Nu există locații în orașul "Craiova".
___nonexistent___ => 0
Nu există locații în orașul "___nonexistent___".
Roma => 0
Deși există locații în orașul "Roma", nu lucreză nimeniun angajat acolo momentan.
Venice => 0
Deși există locații în orașul "Venice", nu lucreză nimeniun angajat acolo momentan.
Tokyo => 0
Deși există locații în orașul "Tokyo", nu lucreză nimeniun angajat acolo momentan.
Hiroshima => 0
Deși există locații în orașul "Hiroshima", nu lucreză nimeniun angajat acolo momentan.
Southlake => 0
Desi exista angajați care lucreză in orașul "Southlake", nu există unul care să fi avut cel puțin două joburi.
South San Francisco => 1
Găsit 1 angajați la căutarea de angajați in orasul "South San Francisco" care să fi avut cel puțin două joburi.
South Brunswick => 0
Deși există locații în orașul "South Brunswick", nu lucreză nimeniun angajat acolo momentan.
Seattle => 4
Găsit 4 angajați la căutarea de angajați in orasul "Seattle" care să fi avut cel puțin două joburi.
Toronto => 1
Găsit 1 angajați la căutarea de angajați in orasul "Toronto" care să fi avut cel puțin două joburi.
Whitehorse => 0
Deși există locații în orașul "Whitehorse", nu lucreză nimeniun angajat acolo momentan.
Beijing => 0
Deși există locații în orașul "Beijing", nu lucreză nimeniun angajat acolo momentan.
Bombay => 0
Deși există locații în orașul "Bombay", nu lucreză nimeniun angajat acolo momentan.
Sydney => 0
Deși există locații în orașul "Sydney", nu lucreză nimeniun angajat acolo momentan.
Singapore => 0
Deși există locații în orașul "Singapore", nu lucreză nimeniun angajat acolo momentan.
London => 0
Desi exista angajați care lucreză in orașul "London", nu există unul care să fi avut cel puțin două joburi.
Oxford => 1
Găsit 1 angajați la căutarea de angajați in orasul "Oxford" care să fi avut cel puțin două joburi.
Stretford => 0
Deși există locații în orașul "Stretford", nu lucreză nimeniun angajat acolo momentan.
Munich => 0
Desi exista angajați care lucreză in orașul "Munich", nu există unul care să fi avut cel puțin două joburi.
Sao Paulo => 0
Deși există locații în orașul "Sao Paulo", nu lucreză nimeniun angajat acolo momentan.
Geneva => 0
Deși există locații în orașul "Geneva", nu lucreză nimeniun angajat acolo momentan.
Bern => 0
Deși există locații în orașul "Bern", nu lucreză nimeniun angajat acolo momentan.
Utrecht => 0
Deși există locații în orașul "Utrecht", nu lucreză nimeniun angajat acolo momentan.
Mexico City => 0
Deși există locații în orașul "Mexico City", nu lucreză nimeniun angajat acolo momentan.
*/

SELECT * FROM info_fn_e3;

DROP FUNCTION fn_e3;
DROP TABLE info_fn_e3;
DROP SEQUENCE seq_info_fn_e3;

/*
    E4. Definiți o procedură stocată care mărește cu 10% salariile tuturor angajaților conduși direct sau
    indirect de către un manager al cărui cod este dat ca parametru. Tratați cazul în care nu există
    niciun manager cu codul dat. Inserați în tabelul info_*** informațiile corespunzătoare fiecărui
    caz determinat de valoarea dată pentru parametru.
*/

CREATE SEQUENCE seq_tree_proc START WITH 1 INCREMENT BY 1;
CREATE TABLE info_tree_proc (
    call_id    NUMBER,
    iteration  NUMBER,
    utilizator VARCHAR2(50),
    data       DATE,
    root_mgr   NUMBER(6),
    percent    NUMBER,
    rezultat   VARCHAR2(100),
    PRIMARY KEY (call_id, iteration)
);

CREATE OR REPLACE PROCEDURE tree_proc(v_root_manager employees.manager_id%TYPE, v_percent NUMBER)
IS
    v_id BINARY_INTEGER;
    v_iteration BINARY_INTEGER := 1;
    v_msg VARCHAR2(100);
    v_check_exists BINARY_INTEGER;

    CURSOR c_branching_query
    IS
        SELECT employee_id, salary
        FROM employees e1
        START WITH employee_id = v_root_manager
        CONNECT BY manager_id = PRIOR employee_id
        FOR UPDATE;

    PROCEDURE insert_log(v_id NUMBER, v_iteration NUMBER, v_rezultat VARCHAR2)
    IS
        BEGIN
            INSERT INTO info_tree_proc (call_id, iteration, utilizator, data, root_mgr, percent, rezultat)
            VALUES (v_id, v_iteration, (SELECT USER FROM DUAL), (SELECT SYSDATE FROM DUAL), v_root_manager, v_percent, v_rezultat);
    END insert_log;

    BEGIN

        SELECT seq_tree_proc.nextval
        INTO v_id
        FROM DUAL;


        SELECT COUNT(*)
        INTO v_check_exists
        FROM employees
        WHERE employee_id = v_root_manager AND EXISTS(
            SELECT *
            FROM employees
            WHERE manager_id = v_root_manager
        );

        IF v_check_exists = 0
        THEN
            SELECT COUNT(*)
            INTO v_check_exists
            FROM employees
            WHERE employee_id = v_root_manager;

            IF v_check_exists = 0
            THEN
                insert_log(v_id, -1, 'Nu există angajat cu ID '||v_root_manager||'.');
            ELSE
                insert_log(v_id, -1, 'Angajatul cu ID '||v_root_manager||' nu este manager.');
            END IF;
        END IF;

        FOR rezultat IN c_branching_query
        LOOP
            CONTINUE WHEN rezultat.employee_id = v_root_manager;

            v_msg := 'Actualizat salariul angajatului '||rezultat.employee_id||' de la '||rezultat.salary||' lei la ';
            rezultat.salary := rezultat.salary * v_percent;
            v_msg := v_msg||rezultat.salary||' lei. (procent = '||v_percent||')';
            insert_log(v_id, v_iteration, v_msg);
            v_iteration := v_iteration + 1;
        END LOOP;
END;
/

DECLARE
    v_percent NUMBER := 1.1;
BEGIN
    -- testare cu manageri
    tree_proc(101, v_percent);
    tree_proc(102, v_percent);

    -- testare cu non-manager
    tree_proc(206, v_percent);

    -- testare cu id non-existent
    tree_proc(9999, v_percent);
END;
/

SELECT * FROM info_tree_proc;

/*
1,1,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 108 de la 12000 lei la 13200 lei. (procent = 1,1)"
1,2,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 109 de la 9000 lei la 9900 lei. (procent = 1,1)"
1,3,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 110 de la 8200 lei la 9020 lei. (procent = 1,1)"
1,4,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 111 de la 7700 lei la 8470 lei. (procent = 1,1)"
1,5,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 112 de la 7800 lei la 8580 lei. (procent = 1,1)"
1,6,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 113 de la 6900 lei la 7590 lei. (procent = 1,1)"
1,7,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 200 de la 4400 lei la 4840 lei. (procent = 1,1)"
1,8,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 203 de la 6500 lei la 7150 lei. (procent = 1,1)"
1,9,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 204 de la 10000 lei la 11000 lei. (procent = 1,1)"
1,10,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 205 de la 12000 lei la 13200 lei. (procent = 1,1)"
1,11,THEO,2023-11-27 14:59:51,101,1.1,"Actualizat salariul angajatului 206 de la 8300 lei la 9130 lei. (procent = 1,1)"
2,1,THEO,2023-11-27 14:59:51,102,1.1,"Actualizat salariul angajatului 103 de la 9000 lei la 9900 lei. (procent = 1,1)"
2,2,THEO,2023-11-27 14:59:51,102,1.1,"Actualizat salariul angajatului 104 de la 6000 lei la 6600 lei. (procent = 1,1)"
2,3,THEO,2023-11-27 14:59:51,102,1.1,"Actualizat salariul angajatului 105 de la 4800 lei la 5280 lei. (procent = 1,1)"
2,4,THEO,2023-11-27 14:59:51,102,1.1,"Actualizat salariul angajatului 106 de la 4800 lei la 5280 lei. (procent = 1,1)"
2,5,THEO,2023-11-27 14:59:51,102,1.1,"Actualizat salariul angajatului 107 de la 4200 lei la 4620 lei. (procent = 1,1)"
3,-1,THEO,2023-11-27 14:59:51,206,1.1,Angajatul cu ID 206 nu este manager.
4,-1,THEO,2023-11-27 14:59:51,9999,1.1,Nu există angajat cu ID 9999.
*/

DROP PROCEDURE tree_proc;
DROP TABLE info_tree_proc;
DROP SEQUENCE seq_tree_proc;
