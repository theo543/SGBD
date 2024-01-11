/*
Să se interzică ștergerea și alterarea tabelelor din baza de date.
Încercările de ștergere sau alterare a tabelelor vor fi înregistrate într-o tabelă log.
Log-ul trebuie protejat la fel ca și restul tabelelor.
*/

CREATE SEQUENCE incercari_log_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE incercari_log (
    id_incercare NUMBER(10) DEFAULT incercari_log_seq.nextval PRIMARY KEY,
    username VARCHAR2(127) DEFAULT user NOT NULL,
    data date DEFAULT sysdate NOT NULL,
    operation VARCHAR2(127) NOT NULL,
    obj_type VARCHAR2(127) NOT NULL,
    obj_name VARCHAR2(127) NOT NULL
);

CREATE OR REPLACE PROCEDURE log_ddl_neanulabil
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO incercari_log (operation, obj_type, obj_name)
    VALUES (sys.sysevent, sys.DICTIONARY_OBJ_TYPE(), sys.DICTIONARY_OBJ_NAME());
    COMMIT;
END;
/

CREATE OR REPLACE TRIGGER protectie_tabele
    BEFORE DDL ON THEO.SCHEMA
DECLARE
    TYPE lista_protejate IS TABLE OF VARCHAR2(127);
    lista lista_protejate := lista_protejate('ALERGIE', 'ANGAJAT', 'BUCATAR', 'CASIER', 'COMANDA',
        'COMANDA_INCLUDE_RETETA', 'INGREDIENT', 'INGREDIENT_PROVOACA_ALERGIE', 'JOB', 'LIVRARE',
        'MANAGER', 'ORAS', 'RESTAURANT', 'RETETA', 'RETETA_CONTINE_INGREDIENT', 'INCERCARI_LOG');
BEGIN
    FOR i IN 1..lista.COUNT
    LOOP
        IF (UPPER(sys.DICTIONARY_OBJ_NAME()) = lista(i))
        THEN
            log_ddl_neanulabil;
            RAISE_APPLICATION_ERROR(-20011, 'Nu se poate folosi DDL pe tabelele protejate!');
        END IF;
    END LOOP;
END;
/

ALTER TABLE alergie ADD CONSTRAINT tmp CHECK (nume != '');
CREATE TABLE test (id NUMBER(10) PRIMARY KEY, nume VARCHAR2(127));
DROP TABLE test;
DROP TABLE incercari_log;
SELECT * FROM incercari_log;

DROP TRIGGER protectie_tabele;
DROP PROCEDURE log_ddl_neanulabil;
DROP TABLE incercari_log;
DROP SEQUENCE incercari_log_seq;
