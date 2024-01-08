CREATE OR REPLACE PROCEDURE delete_table(tbl VARCHAR2)
IS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE '||tbl;
END;
/

CREATE TABLE test (test_nr NUMBER);

BEGIN
    delete_table('test');
END;
/

DROP PROCEDURE delete_table;


CREATE OR REPLACE FUNCTION number_emp(min_sal NUMBER) RETURN NUMBER
IS
    nr BINARY_INTEGER;
BEGIN
    EXECUTE IMMEDIATE
        'SELECT COUNT(*) FROM employees WHERE salary >= :x'
        INTO nr
        USING min_sal;
    RETURN nr;
END;
/

BEGIN
    dbms_output.PUT_LINE(number_emp(10000));
END;
/

DROP FUNCTION number_emp;

BEGIN
    EXECUTE IMMEDIATE
        'CREATE TABLE dynsql (col VARCHAR2(15))';
    FOR i IN 1..10 LOOP
        EXECUTE IMMEDIATE
            'INSERT INTO dynsql VALUES (:str)'
            USING 'Contor ' || i;
    END LOOP;
    EXECUTE IMMEDIATE
        'BEGIN
            FOR i IN (SELECT * FROM dynsql) LOOP
                DBMS_OUTPUT.PUT_LINE (i.col);
            END LOOP;
        END;';
    EXECUTE IMMEDIATE 'DROP TABLE dynsql';
END;
/

CREATE OR REPLACE PACKAGE dynsql AS
    TYPE refcursor IS REF CURSOR;
    FUNCTION f1 (sir VARCHAR2) RETURN refcursor;
    FUNCTION f2 (sir VARCHAR2) RETURN refcursor;
END dynsql;
/

CREATE OR REPLACE PACKAGE BODY dynsql AS
    FUNCTION f1 (sir VARCHAR2) RETURN refcursor
    IS
        rez refcursor;
    BEGIN
          OPEN rez FOR 'SELECT * FROM employees ' || sir;
          RETURN rez;
    END;

    FUNCTION f2 (sir VARCHAR2) RETURN refcursor IS
        rez refcursor;
    BEGIN
        OPEN rez FOR 'SELECT * FROM employees WHERE job_id = :j' USING sir;
        RETURN rez;
    END;
END dynsql;
/

DECLARE
    v_emp     employees%ROWTYPE;
    v_cursor  dynsql.refcursor;
BEGIN
    v_cursor := dynsql.f1('WHERE salary >10000');
    LOOP
        FETCH v_cursor INTO v_emp;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp.last_name||' '||v_emp.salary);
    END LOOP;
    CLOSE v_cursor;
    DBMS_OUTPUT.PUT_LINE ('*************************************');
    v_cursor := dynsql.f2 ('SA_MAN');
    LOOP
        FETCH v_cursor INTO v_emp;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE (v_emp.last_name||' '||v_emp.job_id);
    END LOOP;
    CLOSE v_cursor;
END;
/

DROP PACKAGE dynsql;

DECLARE
    TYPE  refc IS REF CURSOR;
    TYPE  t_cod IS TABLE OF NUMBER;
    TYPE  t_nume IS TABLE OF VARCHAR2(50);
    cursor_dept  refc;
    cod  t_cod;
    nume  t_nume;
BEGIN
        DBMS_OUTPUT.PUT_LINE ('********* Varianta 1 *******');
        OPEN cursor_dept FOR 'SELECT department_id, department_name FROM departments';
        FETCH cursor_dept BULK COLLECT INTO cod, nume;
        CLOSE cursor_dept;
        FOR i IN cod.FIRST..cod.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(cod(i)||' '||nume(i));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('********* Varianta 2 *******');
        EXECUTE  IMMEDIATE
            'SELECT  department_id,  department_name FROM departments '
            BULK COLLECT INTO cod, nume;
        FOR i IN cod.FIRST..cod.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(cod(i)||' '||nume(i));
        END LOOP;
END;
/

DECLARE
    TYPE tablou IS TABLE OF VARCHAR2(60);
    v_tab    tablou;
    valoare    NUMBER := 1000;
BEGIN
    EXECUTE IMMEDIATE
        'UPDATE employees SET salary = salary + :a WHERE
        job_id=''SA_MAN''
        RETURNING last_name INTO :b'
        USING valoare
        RETURNING BULK COLLECT INTO v_tab;
    FOR i IN v_tab.FIRST.. v_tab.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_tab (i));
    END LOOP;
END;
/

DECLARE
    TYPE  t_nr  IS TABLE OF NUMBER;
    TYPE  t_nume  IS TABLE OF VARCHAR2(30);
    nr  t_nr;
    nume  t_nume;
BEGIN
    nr := t_nr(110, 120, 130, 140, 150);
    FORALL i IN 1..5
        EXECUTE IMMEDIATE
            'UPDATE employees SET salary = salary*1.1
            WHERE  employee_id = :a
            RETURNING last_name INTO :b'
            USING nr(i)
            RETURNING BULK COLLECT INTO nume;
    FOR i IN nume.FIRST..nume.LAST LOOP
        DBMS_OUTPUT.PUT_LINE (nume (i));
    END LOOP;
END;
/
