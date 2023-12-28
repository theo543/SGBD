/*
E7. Adaptați cerința  exercițiului  5  pentru  diagrama proiectului  prezentată la materia  Baze  de  Date  din
anul I. Rezolvați acest exercițiu în PL/SQL, folosind baza de date proprie.

5. (adaptat) Să se creeze un  bloc PL/SQL prin care se afişează numărul de angajați care au venitul anual mai
mare decât o valoare dată. Să se trateze cazul în care niciun angajat nu îndeplineşte această condiţie
(excepţii externe).
*/

CREATE OR REPLACE PACKAGE hw_lab12
IS
    niciun_angajat EXCEPTION;
    FUNCTION numara_angajati(peste_sal_anual NUMBER) RETURN NUMBER;
END hw_lab12;

CREATE OR REPLACE PACKAGE BODY hw_lab12
IS
    FUNCTION numara_angajati(peste_sal_anual NUMBER) RETURN NUMBER
    IS
        v_count NUMBER;
        BEGIN
            SELECT COUNT(id_angajat)
            INTO v_count
            FROM angajat
            WHERE salariu * 12 > peste_sal_anual;

            IF v_count = 0 THEN
                RAISE niciun_angajat;
            END IF;

            RETURN v_count;
    END;
END hw_lab12;

DECLARE
    TYPE test_data IS TABLE OF NUMBER;
    v_test_data test_data := test_data(50000, 60000, 70000, 80000, 81000);
BEGIN
    FOR i IN 1..v_test_data.count
    LOOP
        BEGIN
            dbms_output.PUT('Nr. de angajati cu venit anual peste '||v_test_data(i)||': ');
            dbms_output.PUT_LINE(hw_lab12.numara_angajati(v_test_data(i)));
        EXCEPTION
            WHEN hw_lab12.niciun_angajat THEN
                dbms_output.PUT_LINE('niciunul!');
        END;
    END LOOP;
END;

DROP PACKAGE hw_lab12;
