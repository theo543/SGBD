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

