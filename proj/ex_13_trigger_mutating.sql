CREATE OR REPLACE TRIGGER limita_angajati
    AFTER INSERT OR UPDATE ON angajat
    FOR EACH ROW
BEGIN
    pizza.IMPL_TRIGGER_EROARE_MUTATING_PER_ROW(:NEW.id_restaurant);
END;
/

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

DROP TRIGGER limita_angajati;
