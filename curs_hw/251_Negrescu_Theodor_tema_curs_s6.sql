-- Pentru restaurantul cu numărul maxim de angajați, să se afle salariul total al angajaților.

DECLARE
    v_retaurant_maxim ANGAJAT.id_restaurant%TYPE;
    v_max_count BINARY_INTEGER := 0;
    v_nr_ang BINARY_INTEGER;
    v_salariu_total BINARY_INTEGER;
    cnt BINARY_INTEGER;
    CURSOR c_salariu_total (id_rest ANGAJAT.id_restaurant%TYPE)
    IS
        SELECT SUM(salariu) FROM angajat
        JOIN JOB_ARE_SALARIU
        USING (job_cod)
        WHERE id_restaurant = id_rest;
    CURSOR c_max_cnt
    IS
        SELECT COUNT(*) cnt
        FROM ANGAJAT
        GROUP BY id_restaurant;
BEGIN
    FOR cnt IN c_max_cnt
    LOOP
        IF cnt.cnt > v_max_count
        THEN
            v_max_count := cnt.cnt;
        END IF;
    END LOOP;

    BEGIN
        SELECT id_restaurant, COUNT(id_angajat)
        INTO v_retaurant_maxim, v_nr_ang
        FROM ANGAJAT
        GROUP BY id_restaurant
        HAVING COUNT(id_angajat) = v_max_count;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Detalii eroare: multiple restaurante cu nr. maxim de angajati '||v_max_count);
            RAISE;
    END;
    OPEN c_salariu_total(v_retaurant_maxim);
    FETCH c_salariu_total INTO v_salariu_total;
    CLOSE c_salariu_total;
    DBMS_OUTPUT.PUT_LINE('Restaurantul '||v_retaurant_maxim||' cu '||v_nr_ang||' angajati are suma salariilor angajatilor '||v_salariu_total||'.');
END;
/
