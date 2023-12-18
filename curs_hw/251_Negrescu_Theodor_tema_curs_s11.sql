/*
1. Definiti un tabel de LOG-uri in care sa puteti adăuga operațiile DML efectuate asupra unui tabel asociativ
din schema companie comercială.
În acest tabel vor fi stocate ID-ul, vechea valoare, noua valoare, tipul operației,
momentul în care s-a executat operația și de către cine (userul curent autentificat -
SELECT USER FROM dual).
Implementați un trigger care populează acest tabel cu informațiile menționate mai sus.
*/

CREATE SEQUENCE ID_MODIFICARE_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE PRODUSE_au_CARACTERISTICI_log (
    id_modificare NUMBER(10) DEFAULT ID_MODIFICARE_SEQ.nextval PRIMARY KEY,
    old_id_caracteristica NUMBER(38),
    new_id_caracteristica NUMBER(38),
    old_id_produs NUMBER(38),
    new_id_produs NUMBER(38),
    old_valoare VARCHAR2(255),
    new_valoare VARCHAR2(255),
    operation_type VARCHAR2(1) CHECK (operation_type IN ('I', 'U', 'D')) NOT NULL,
    operation_time DATE DEFAULT SYSDATE NOT NULL,
    operation_user VARCHAR2(30) DEFAULT USER NOT NULL
);

CREATE TRIGGER PRODUSE_au_CARACTERISTICI_log_trigger
    AFTER INSERT OR UPDATE OR DELETE ON PRODUSE_au_CARACTERISTICI
    FOR EACH ROW
DECLARE
    old_id_caracteristica NUMBER(38) := NULL;
    new_id_caracteristica NUMBER(38) := NULL;
    old_id_produs NUMBER(38) := NULL;
    new_id_produs NUMBER(38) := NULL;
    old_valoare VARCHAR2(255) := NULL;
    new_valoare VARCHAR2(255) := NULL;
    operation_type VARCHAR2(1) := NULL;
BEGIN
    IF INSERTING OR UPDATING THEN
        new_id_caracteristica := :new.id_caracteristica;
        new_id_produs := :new.id_produs;
        new_valoare := :new.valoare;
    END IF;
    IF UPDATING OR DELETING THEN
        old_id_caracteristica := :old.id_caracteristica;
        old_id_produs := :old.id_produs;
        old_valoare := :old.valoare;
    END IF;
    operation_type := CASE
        WHEN INSERTING THEN 'I'
        WHEN UPDATING THEN 'U'
        WHEN DELETING THEN 'D'
    END;
    INSERT INTO PRODUSE_au_CARACTERISTICI_log (
        old_id_caracteristica,
        new_id_caracteristica,
        old_id_produs,
        new_id_produs,
        old_valoare,
        new_valoare,
        operation_type
    )
    VALUES (
        old_id_caracteristica,
        new_id_caracteristica,
        old_id_produs,
        new_id_produs,
        old_valoare,
        new_valoare,
        operation_type
    );
END;
/

INSERT INTO produse_au_caracteristici (id_caracteristica, id_produs, valoare)
VALUES (1, 1, 1);
UPDATE produse_au_caracteristici
SET id_caracteristica = 2, id_produs = 2, valoare = 2
WHERE id_caracteristica = 1 AND id_produs = 1 AND valoare = 1;
DELETE FROM produse_au_caracteristici
WHERE id_caracteristica = 2 AND id_produs = 2 AND valoare = 2;

SELECT * FROM produse_au_caracteristici;
SELECT * FROM produse_au_caracteristici_log;

DROP TRIGGER produse_au_caracteristici_log_trigger;
DROP TABLE produse_au_caracteristici_log;
DROP SEQUENCE id_modificare_seq;

/*
2. Implementați cu ajutorul unui trigger următoarea restricție:
un client poate beneficia într-un an de cel mult 3 perioade cu prețuri preferențiale.
*/

CREATE OR REPLACE TRIGGER max_3_pret_preferential_pe_an_trigger
    FOR INSERT OR UPDATE ON clienti_au_pret_preferential
    COMPOUND TRIGGER

    preturi NUMBER(10);

    BEFORE STATEMENT IS
    BEGIN
        -- Necesar pentru a funcționa cu multiple sesiuni.
        LOCK TABLE clienti_au_pret_preferential IN EXCLUSIVE MODE;
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        SELECT COUNT(*) INTO preturi
        FROM clienti_au_pret_preferential
        WHERE id_client_j = :new.id_client_j
        AND EXTRACT(YEAR FROM data_in) <= EXTRACT(YEAR FROM :new.data_sf)
        AND EXTRACT(YEAR FROM :new.data_in) <= EXTRACT(YEAR FROM data_sf);
        IF preturi >= 3 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Clientul nu poate avea mai mult de 3 prețuri preferențiale pe an!');
        END IF;
    END BEFORE EACH ROW;
END;

-- din sesiunea 1
INSERT INTO clienti_au_pret_preferential (id_pret_pref, id_categorie, id_client_j, discount, data_in, data_sf)
VALUES (11, 1, 10, 50, SYSDATE, SYSDATE);
INSERT INTO clienti_au_pret_preferential (id_pret_pref, id_categorie, id_client_j, discount, data_in, data_sf)
VALUES (12, 1, 10, 50, SYSDATE, SYSDATE);
INSERT INTO clienti_au_pret_preferential (id_pret_pref, id_categorie, id_client_j, discount, data_in, data_sf)
VALUES (13, 1, 10, 50, SYSDATE, SYSDATE);
-- din sesiunea 2
INSERT INTO clienti_au_pret_preferential (id_pret_pref, id_categorie, id_client_j, discount, data_in, data_sf)
VALUES (14, 1, 10, 50, SYSDATE, SYSDATE);

DROP TRIGGER max_3_pret_preferential_pe_an_trigger;

/*
3. Pe un tabel dependent din schema companie comercială implementați cu ajutorul unui trigger 
o constrângere de integritate la alegere. 
Observație: trebuie să apară explicit pe ce tabel și care este constrangerea implementată.

Tabelul: clienti_persoane_fizice
Nu poate apărea în tabelul clienti_au_pret_preferential.

Nu mi-am dat seama cum să fac constrângere multi-tabel cu un trigger,
așa că am implementat-o în SQL declarativ folosind un materialized view.
*/

CREATE MATERIALIZED VIEW LOG ON clienti_persoane_fizice
WITH ROWID (id_client_f)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON clienti_au_pret_preferential
WITH ROWID (id_client_j)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW erori_clienti_pf
REFRESH FAST
ON COMMIT
AS
    SELECT COUNT(*) nr_erori FROM clienti_persoane_fizice
    JOIN clienti_au_pret_preferential
    ON clienti_persoane_fizice.id_client_f = clienti_au_pret_preferential.id_client_j;

ALTER TABLE erori_clienti_pf
ADD CONSTRAINT nu_poate_exista_client_pf_in_tabelul_pret_preferential CHECK (nr_erori = 0);

-- din sesiunea 1
INSERT INTO clienti_persoane_fizice (id_client_f, nume, prenume, cnp)
VALUES (10000, 'mr. test', 'test', 1);

-- din sesiunea 2
INSERT INTO clienti_au_pret_preferential (id_pret_pref, id_categorie, id_client_j, discount, data_in, data_sf)
VALUES (10000, 10000, 10000, 50, SYSDATE, SYSDATE);

DELETE FROM clienti_persoane_fizice WHERE id_client_f = 10000;
DELETE FROM clienti_au_pret_preferential WHERE id_client_j = 10000;
DROP MATERIALIZED VIEW erori_clienti_pf;
DROP MATERIALIZED VIEW LOG ON clienti_au_pret_preferential;
DROP MATERIALIZED VIEW LOG ON clienti_persoane_fizice;
