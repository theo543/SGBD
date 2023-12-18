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
