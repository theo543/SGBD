-- teste pentru 6, 7, 8, 9

BEGIN
    pizza.RULEAZA_TESTE_EX_6_7_8_9();
END;
/

-- testare monitorizare modificari anormale

SELECT * FROM all_triggers
WHERE trigger_name LIKE '%AUTOGENERAT%';

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

-- testare limita angajati

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

-- testare protectie tabele

ALTER TABLE alergie ADD CONSTRAINT tmp CHECK (nume != '');
CREATE TABLE test (id NUMBER(10) PRIMARY KEY, nume VARCHAR2(127));
DROP TABLE test;
DROP TABLE incercari_log;
SELECT * FROM incercari_log;
