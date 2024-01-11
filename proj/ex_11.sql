/*
Din cauza unor griji că managerii nu sunt antrenați să organizeze numere mari de angajați,
s-a decis să se limiteze numărul de angajați la 5 pe restaurant.
Să se creeze un trigger care să nu permită peste 5 angajați pe restaurant.
Se va arăta și un exemplu de trigger _incorect_, care nu funcționează din cauze erorii mutating.
*/

/**
  Exemplu de trigger cu eroare mutating.
*/

CREATE OR REPLACE TRIGGER limita_angajati
    AFTER INSERT OR UPDATE ON angajat
    FOR EACH ROW
DECLARE
    v_total NUMBER(10);
BEGIN
    SELECT COUNT(id_angajat)
    INTO v_total
    FROM angajat
    WHERE id_restaurant = :NEW.id_restaurant;
    IF v_total > 5 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Nu pot fi peste 5 angajați într-un restaurant!');
    END IF;
END;
/

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

DROP TRIGGER limita_angajati;

/**
  Rezolvarea erorii mutating cu un tabel auxiliar, siguranța multi-sesiune e asigurată cu LOCK TABLE prin trigger compus.
*/

CREATE TABLE aux_lim_ang AS
    SELECT id_restaurant, COUNT(id_angajat) AS nr_angajati
    FROM angajat
    GROUP BY id_restaurant;

CREATE OR REPLACE TRIGGER limita_angajati
    FOR INSERT OR DELETE OR UPDATE ON angajat
    COMPOUND TRIGGER

    v_nr_angajati NUMBER(10);

    BEFORE STATEMENT
    IS
    BEGIN
        LOCK TABLE aux_lim_ang IN EXCLUSIVE MODE;
    END BEFORE STATEMENT;

    BEFORE EACH ROW
    IS
    BEGIN
        IF DELETING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati - 1
            WHERE id_restaurant = :OLD.id_restaurant;
        END IF;
        IF INSERTING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati + 1
            WHERE id_restaurant = :NEW.id_restaurant
            RETURNING nr_angajati INTO v_nr_angajati;
            IF v_nr_angajati > 5 THEN
                raise_application_error(-20010, 'Nu pot fi mai mult de 5 angajați într-un restaurant!');
            END IF;
        END IF;
    END BEFORE EACH ROW;
END;
/

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

DROP TRIGGER limita_angajati;
DROP TABLE aux_lim_ang;
