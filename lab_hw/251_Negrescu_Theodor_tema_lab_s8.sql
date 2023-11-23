/*
    E7. Adaptați cerințele exercițiilor 2 și 4 (folosind ca bază cerințele exercițiilor 1, respectiv 3) pentru
    diagrama proiectului prezentată la materia Baze de Date din anul I. Rezolvați aceste două exerciții
    în PL/SQL, folosind baza de date proprie. (PARTIAL doar ex. 2)

    1. (adaptat)
    Definiți un subprogram prin care să obțineți orașul în care lucrează un angajat, folosind numele angajatului.
    Funcția trebuie să funcționeze chiar dacă utilizatorul introduce doar numele de familie sau doar prenumele.
    Tratați toate excepțiile ce pot fi generate.
    2.
    Rezolvați exercițiul 1 folosind o funcție stocată.
*/

CREATE OR REPLACE FUNCTION f2_oras_angajat(v_nume IN angajat.nume%TYPE)
RETURN oras.nume%TYPE IS
    v_id angajat.id_angajat%TYPE;
    v_nume_oras oras.nume%TYPE;
    BEGIN
        SELECT id_angajat
        INTO v_id
        FROM angajat
        WHERE regexp_like(nume, '(^| )'||v_nume||'($| )', 'i');

        -- Imposibil să avem expectie la join, datorită constrângerilor
        -- FOREIGN KEY și NOT NULL pe id_restaurant și id_oras.
        SELECT oras.nume
        INTO v_nume_oras
        FROM angajat
        JOIN restaurant
        USING (id_restaurant)
        JOIN oras
        USING (id_oras)
        WHERE id_angajat = v_id;
        RETURN v_nume_oras;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20009, 'Nu s-a găsit un angajat cu nume sau prenume '||v_nume||'.');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20009, 'Input ambiguu: multiplii angajați găsiți cu nume sau prenume '||v_nume||'.');
            RETURN -2;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20009,'Alta eroare: '||SQLERRM);
            RETURN -3;
END;
/

/*
    Găsește un nume a.î. count >= 1 pentru a cauza eroarea
*/
WITH fn AS (
    SELECT regexp_substr(nume, '(\w+)$', 1, 1, NULL, 1) AS nume FROM angajat
)
SELECT nume, COUNT(*) FROM fn
GROUP BY nume
ORDER BY COUNT(*) DESC;
/*
 Iulia si Anamaria ar trebui să cauzeze eroarea.
*/

DECLARE
    TYPE test_inputs IS VARRAY(10) OF angajat.nume%TYPE;
    v_test_inputs test_inputs := test_inputs('Adrian', 'Iulia', 'Trandafir', 'Trandafi', 'Iorga Irina', 'Anamaria', 'Stefan');
    esec_f2_oras_angajat EXCEPTION;
    PRAGMA EXCEPTION_INIT (esec_f2_oras_angajat, -20009);
BEGIN
    FOR i IN 1..v_test_inputs.LAST
    LOOP
        dbms_output.PUT(v_test_inputs(i) || ' => ');
        BEGIN
            dbms_output.PUT_LINE('Lucrează în '||f2_oras_angajat(v_test_inputs(i))||'.');
        EXCEPTION
            WHEN esec_f2_oras_angajat THEN
                dbms_output.put_line(SQLERRM);
        END;
    END LOOP;
END;
/

DROP FUNCTION f2_oras_angajat;
