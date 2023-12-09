/*
3. (adaptat)
Definiți un pachet cu un subprogram care găsește salariul maxim al angajaților care lucrează într-un oraș,
un cursor care returnează angajații care au salariul cel puțin egal cu un salariu dat, și un cursor ajutător
care folosește subprogramul pentru a returna angajații cu salariul cel puțin egal cu salariul maxim dintr-un oraș.
*/

CREATE OR REPLACE PACKAGE hw_lab10 AS
    CURSOR c_angajati_cu_cel_putin_salariul(min_sal NUMBER) RETURN angajat%ROWTYPE;
    CURSOR c_angajati_cu_cel_putin_max_salariul_orasului(nume_oras oras.nume%TYPE) RETURN angajat%ROWTYPE;
    FUNCTION salariu_maxim_din_oras(nume_oras oras.nume%TYPE) RETURN NUMBER;
    oras_nu_exista EXCEPTION;
    PRAGMA EXCEPTION_INIT (oras_nu_exista, -20003);
END hw_lab10;

CREATE OR REPLACE PACKAGE BODY hw_lab10 AS
    CURSOR c_angajati_cu_cel_putin_salariul(min_sal NUMBER) RETURN angajat%ROWTYPE
    IS
        SELECT *
        FROM angajat
        WHERE salariu >= min_sal;

    CURSOR c_angajati_cu_cel_putin_max_salariul_orasului(nume_oras oras.nume%TYPE) RETURN angajat%ROWTYPE
    IS
        SELECT *
        FROM angajat
        WHERE salariu >= salariu_maxim_din_oras(nume_oras);

    FUNCTION salariu_maxim_din_oras(nume_oras oras.nume%TYPE) RETURN NUMBER
    IS
        v_id_oras oras.id_oras%TYPE;
        v_salariu BINARY_INTEGER;
        BEGIN
            BEGIN
                SELECT id_oras
                INTO v_id_oras
                FROM oras
                WHERE nume = nume_oras;
            EXCEPTION
                WHEN no_data_found THEN
                    raise_application_error(-20003, 'Nu s-a găsit orașul "'||nume_oras||'".');
            END;

            SELECT MAX(salariu)
            INTO v_salariu
            FROM angajat
            JOIN restaurant
            USING (id_restaurant)
            WHERE id_oras = v_id_oras;

            RETURN v_salariu;
    END;
END hw_lab10;

BEGIN
    FOR angajat IN hw_lab10.c_angajati_cu_cel_putin_salariul(5000)
    LOOP
        dbms_output.put_line(angajat.nume||' => '||angajat.salariu);
    END LOOP;
END;
/

DECLARE
    CURSOR c_test_data
    IS
        SELECT 1 as test_nr, 'Cluj' AS nume FROM dual
        UNION
        SELECT rownum + 1 AS test_nr, nume FROM oras;
BEGIN
    FOR test IN c_test_data
    LOOP
        dbms_output.PUT_LINE('--- Test '||test.test_nr||': '||test.nume||' ---');
        dbms_output.PUT('-- Salariul maxim în '||test.nume||': ');
        BEGIN
            dbms_output.PUT_LINE(hw_lab10.salariu_maxim_din_oras(test.nume));
        EXCEPTION
            WHEN hw_lab10.oras_nu_exista THEN
                dbms_output.PUT_LINE(SQLERRM);
        END;
        dbms_output.PUT_LINE('-- Angajați cu salariul cel puțin egal cu maximul din acest oras:');
        BEGIN
            FOR angajat IN hw_lab10.c_angajati_cu_cel_putin_max_salariul_orasului(test.nume)
            LOOP
                dbms_output.put_line(angajat.nume||' '||angajat.salariu);
            END LOOP;
        EXCEPTION
            WHEN hw_lab10.oras_nu_exista THEN
                dbms_output.PUT_LINE(SQLERRM);
        END;
    END LOOP;
END;
/

DROP PACKAGE hw_lab10;
