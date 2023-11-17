--E6. Adaptați cerința exercițiului 10 pentru diagrama proiectului prezentată la materia Baze de Date
--din anul I. Rezolvați subpunctul (a) al acestui exercițiu în PL/SQL, folosind baza de date
--proprie.
--10. Pentru fiecare dintre restaurantele 1, 2, 3, 4, obțineți orasul, precum și lista numelor
--angajaților care își desfășoară activitatea în cadrul acestora. Rezolvați problema folosind:
--a. cele trei tipuri de cursoare studiate;
--b. expresii cursor.
--Observație: În Oracle9i a fost introdus conceptul de expresie cursor care întoarce un cursor
--imbricat (nested cursor).
--Varianta 1.1 – cursor clasic
--Varianta 1.2 – ciclu cursor
--Varianta 1.3 – ciclu cursor cu subcereri

-- cursoare clasice
DECLARE
    CURSOR c_rest
        IS
        SELECT id_restaurant, nume nume_oras
        FROM RESTAURANT
        JOIN ORAS
        USING (id_oras)
        WHERE id_restaurant IN (1, 2, 3, 4);
    CURSOR c_ang(id_rest RESTAURANT.id_restaurant%TYPE)
        IS
        SELECT id_angajat, nume nume_angajat
        FROM ANGAJAT
        WHERE id_restaurant = id_rest;
    rest c_rest%ROWTYPE;
    ang c_ang%ROWTYPE;
BEGIN
    OPEN c_rest;
    LOOP
        FETCH c_rest INTO rest;
        EXIT WHEN c_rest%NOTFOUND;
        dbms_output.PUT_LINE('-------- Restaurant '||rest.id_restaurant||' (oras '||rest.nume_oras||'): --------');
        OPEN c_ang(rest.id_restaurant);
        LOOP
            FETCH c_ang INTO ang;
            EXIT WHEN c_ang%NOTFOUND;
            dbms_output.PUT_LINE(ang.nume_angajat|| ' (ID '||ang.id_angajat||')');
        END LOOP;
        CLOSE c_ang;
    END LOOP;
    CLOSE c_rest;
END;
/

-- cicluri cursor
DECLARE
    CURSOR c_rest
        IS
        SELECT id_restaurant, nume nume_oras
        FROM RESTAURANT
        JOIN ORAS
        USING (id_oras)
        WHERE id_restaurant IN (1, 2, 3, 4);
    CURSOR c_ang(id_rest RESTAURANT.id_restaurant%TYPE)
        IS
        SELECT id_angajat, nume nume_angajat
        FROM ANGAJAT
        WHERE id_restaurant = id_rest;
BEGIN
    FOR rest IN c_rest
    LOOP
        dbms_output.PUT_LINE('-------- Restaurant '||rest.id_restaurant||' (oras '||rest.nume_oras||'): --------');
        FOR ang IN c_ang(rest.id_restaurant)
        LOOP
            dbms_output.PUT_LINE(ang.nume_angajat|| ' (ID '||ang.id_angajat||')');
        END LOOP;
    END LOOP;
END;
/

-- cicluri cursor cu subcereri
BEGIN
    FOR rest IN (
        SELECT id_restaurant, nume nume_oras
        FROM RESTAURANT
        JOIN ORAS
        USING (id_oras)
        WHERE id_restaurant IN (1, 2, 3, 4)
    )
    LOOP
        dbms_output.PUT_LINE('-------- Restaurant '||rest.id_restaurant||' (oras '||rest.nume_oras||'): --------');
        FOR ang IN (
            SELECT id_angajat, nume nume_angajat
            FROM ANGAJAT
            WHERE id_restaurant = rest.id_restaurant
        )
        LOOP
            dbms_output.PUT_LINE(ang.nume_angajat|| ' (ID '||ang.id_angajat||')');
        END LOOP;
    END LOOP;
END;
/
