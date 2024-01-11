/*
S-a decis că deoarece unele tabele din baza de date se vor schimba rar, ar trebui monitorizate modificări ale lor.
Acele tabele sunt:
ALERGIE, INGREDIENT_provoaca_ALERGIE, INGREDIENT, RETETA_contine_INGREDIENT, RETETA, JOB
Să se stocheze log-ul tuturor modificărilor la aceste tabele.
Log-ul va include: username, nume tabel, data modificare, numar de raduri.
Deoarece 
*/

CREATE SEQUENCE id_modificari_anormale_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE log_modificari_anormale (
    id_modificari_anormale NUMBER(10) DEFAULT id_modificari_anormale_seq.nextval PRIMARY KEY,
    username VARCHAR2(255) DEFAULT USER NOT NULL,
    nume_tabel VARCHAR2(255) NOT NULL,
    tip_operatie VARCHAR2(15) NOT NULL,
    data_modificare DATE DEFAULT SYSDATE NOT NULL
);

CREATE OR REPLACE PROCEDURE create_modification_log(nume_tabel VARCHAR2)
IS
    tip VARCHAR2(15) := 'UNKNOWN';
BEGIN
    IF INSERTING THEN
        tip := 'INSERT';
    ELSIF UPDATING THEN
        tip := 'UPDATE';
    ELSIF DELETING THEN
        tip := 'DELETE';
    END IF;
    INSERT INTO log_modificari_anormale (nume_tabel, tip_operatie) VALUES (nume_tabel, tip);
END;
/

CREATE OR REPLACE PROCEDURE instalare_triggeri_autogenerat
IS
    template VARCHAR2(1023) := 'CREATE OR REPLACE TRIGGER LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_{{NUMETABEL}}
        BEFORE INSERT OR UPDATE OR DELETE ON {{NUMETABEL}}
    BEGIN
        create_modification_log(''{{NUMETABEL}}'');
    END;';
    cod VARCHAR2(1023);
    TYPE lista IS TABLE OF VARCHAR2(31);
    tabele_monitorizate lista :=
        lista('ALERGIE', 'INGREDIENT_provoaca_ALERGIE', 'INGREDIENT', 'RETETA_contine_INGREDIENT', 'RETETA', 'JOB');
BEGIN
    FOR i IN 1..tabele_monitorizate.LAST
    LOOP
        cod := REPLACE(template, '{{NUMETABEL}}', tabele_monitorizate(i));
        EXECUTE IMMEDIATE cod;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE stergere_triggeri_autogenerat
IS
    CURSOR triggeri_autogenerati
    IS
    SELECT trigger_name
    FROM all_triggers
    WHERE trigger_name LIKE 'LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_%';
BEGIN
    FOR trigger_autogenerat IN triggeri_autogenerati
    LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_autogenerat.trigger_name;
    END LOOP;
END;
/

BEGIN
    instalare_triggeri_autogenerat();
END;
/

SELECT * FROM all_triggers;

INSERT INTO alergie (nume) VALUES ('alergie1');
UPDATE alergie SET nume = 'alergie2' WHERE id_alergie = 1;
UPDATE reteta SET pret = pret * pret;
DELETE FROM alergie WHERE nume = 'alergie1';
UPDATE reteta_contine_ingredient SET id_ingredient = 1 WHERE id_ingredient = 2;
INSERT INTO job (job_cod, salariu_baza, bonus_maxim)
SELECT 'job '||LEVEL, LEVEL * 1000, LEVEL * 100
FROM DUAL
CONNECT BY LEVEL <= 10000;

SELECT * FROM log_modificari_anormale;

ROLLBACK;

BEGIN
    stergere_triggeri_autogenerat();
END;

DROP TABLE log_modificari_anormale;
DROP SEQUENCE id_modificari_anormale_seq;
DROP PROCEDURE create_modification_log;
DROP PROCEDURE instalare_triggeri_autogenerat;
DROP PROCEDURE stergere_triggeri_autogenerat;
