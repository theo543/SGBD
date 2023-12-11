CREATE OR REPLACE TRIGGER delete_interzis_user_theo
    BEFORE DELETE ON departments
BEGIN
    IF USER = 'THEO'
    THEN
        raise_application_error(-20010, 'User THEO nu are are acces la DELETE pe departments.');
    END IF;
END;

DELETE FROM departments
WHERE department_id = 1;

DROP TRIGGER delete_interzis_user_theo;

UPDATE employees
SET commission_pct = 0.6
WHERE employee_id = 100;

CREATE OR REPLACE TRIGGER limita_comision
    BEFORE UPDATE ON employees
    FOR EACH ROW
BEGIN
    IF  NOT (:old.commission_pct IS NOT NULL AND :old.commission_pct > 0.5)
        AND (:new.commission_pct IS NOT NULL AND :new.commission_pct > 0.5)
    THEN
        raise_application_error(-20011, 'Comisionul nu poate depăși 50%.');
    END IF;
END;

UPDATE employees
SET commission_pct = 0.7
WHERE employee_id = 100;

UPDATE employees
SET commission_pct = 2 * commission_pct;

UPDATE employees
SET commission_pct = NULL
WHERE employee_id = 100;

UPDATE employees
SET commission_pct = 0.7
WHERE employee_id = 100;

DROP TRIGGER limita_comision;
