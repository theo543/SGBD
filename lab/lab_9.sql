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

    PROCEDURE insert_log(error_code BINARY_INTEGER)
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
