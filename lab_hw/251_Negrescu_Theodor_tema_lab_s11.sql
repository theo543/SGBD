/*
E7. Adaptați cerința  exercițiului  4  pentru  diagrama proiectului  prezentată la materia  Baze  de  Date  din 
anul I. Rezolvați acest exercițiu în PL/SQL, folosind baza de date proprie.
*/

/*
4. (adaptat) a. Creați tabelul info_restaurant cu următoarele coloane:
- id_restaurant (codul restaurantului) – cheie primară
- numar_angajati
- total_plati  (suma alocată lunar pentru plata salariilor)
*/

CREATE TABLE info_restaurant (
    id_restaurant NUMBER(10) PRIMARY KEY,
    numar_angajati NUMBER(10) NOT NULL,
    plati NUMBER(10) NOT NULL
);

/*
 4. (adaptat) b. Introduceți date în tabelul creat anterior corespunzătoare informațiilor existente în schemă.
*/

INSERT INTO info_restaurant
    /* nu există restaurante fără angajați, dar dacă ar exista funcția ar funcționa corect cu ele */
    SELECT id_restaurant, COUNT(id_angajat), SUM(COALESCE(salariu, 0)) AS count
    FROM restaurant
    LEFT JOIN angajat
    USING (id_restaurant)
    GROUP BY id_restaurant

/*
 4. (adaptat) c.  Definiți  un  declanșator  care  va  actualiza  automat  câmpul  plati  atunci  când  se  introduce  un
nou angajat, respectiv se șterge angajatul sau se modifică salariul.
*/

CREATE OR REPLACE PROCEDURE delete_angajat(v_rest restaurant.id_restaurant%TYPE, v_sal angajat.salariu%TYPE)
AS
BEGIN
    UPDATE info_restaurant
    SET numar_angajati = numar_angajati - 1, plati = plati - v_sal
    WHERE id_restaurant = v_rest;
END;

CREATE OR REPLACE PROCEDURE add_angajat(v_rest restaurant.id_restaurant%TYPE, v_sal angajat.salariu%TYPE)
AS
BEGIN
    UPDATE info_restaurant
    SET numar_angajati = numar_angajati + 1, plati = plati + v_sal
    WHERE id_restaurant = v_rest;
END;

CREATE OR REPLACE TRIGGER update_info_restaurant
    BEFORE INSERT OR DELETE OR UPDATE ON angajat
    FOR EACH ROW
BEGIN
    IF DELETING OR UPDATING THEN
        delete_angajat(:OLD.id_restaurant, :OLD.salariu);
    END IF;
    IF INSERTING OR UPDATING THEN
        add_angajat(:NEW.id_restaurant, :NEW.salariu);
    END IF;
END;

SELECT * FROM info_restaurant;

UPDATE angajat
SET id_restaurant = 2
WHERE id_restaurant = 1 AND id_angajat != 1;

DELETE FROM comanda
WHERE id_restaurant = 4;

DELETE FROM angajat
WHERE id_restaurant = 4;

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (5, NULL, 'MANAGER', 'test', SYSDATE, 1000000);

SELECT * FROM info_restaurant;

ROLLBACK;
DROP TRIGGER update_info_restaurant;
DROP PROCEDURE delete_angajat;
DROP PROCEDURE add_angajat;
DROP TABLE info_restaurant;
