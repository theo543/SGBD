SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- 4. Definiți un bloc anonim în care să se afle numele restaurantului cu cei mai mulți angajați.
-- Comentați cazul în care există cel puțin două restaurante cu număr maxim de angajați.
-- 5. Rezolvați problema anterioară utilizând variabile de legătură. Afișați rezultatul atât din bloc, cât
-- și din exteriorul acestuia.

-- nu functioneaza... nu stiu de ce

VAR restaurant NUMBER(10, 0);
BEGIN
    WITH counts AS (
        SELECT id_restaurant, COUNT(*) nr_angajati
        FROM ANGAJAT
        GROUP BY (id_restaurant)
    )
    SELECT id_restaurant
    INTO :restaurant
    FROM counts
    WHERE nr_angajati = (SELECT MAX(nr_angajati) FROM counts);
    DBMS_OUTPUT.PUT_LINE('Restaurantul '||:restaurant);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple restaurante');
        :restaurant := null;
END;
/
PRINT restaurant;

-- 7. Determinați bonusul pe care îl primește un casier al cărui cod este dat de la
-- tastatură. Bonusul este determinat astfel: dacă numarul de comenzi procesate este cel puțin 8, atunci bonusul
-- este 200; dacă este cel puțin 5 si cel mult 7 atunci bonusul este 100,
-- iar dacă este cel putin 1 si cel mult 4, atunci bonusul este 50, altfel 0. Afișați bonusul obținut.
-- Comentați cazul în care nu există niciun angajat cu codul introdus

DECLARE
    v_cod casier.id_angajat%TYPE := &p_cod;
    v_bonus BINARY_INTEGER;
    v_nr_comenzi BINARY_INTEGER;
    v_check_exists BINARY_INTEGER;
BEGIN
    SELECT COUNT(id_angajat)
    INTO v_check_exists
    FROM CASIER
    WHERE id_angajat = v_cod;
    IF v_check_exists = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;
    SELECT COUNT(id_comanda)
    INTO v_nr_comenzi
    FROM COMANDA
    WHERE id_casier = v_cod;
    IF v_nr_comenzi >= 8 THEN
        v_bonus := 200;
    ELSIF v_nr_comenzi >= 5 THEN
        v_bonus := 100;
    ELSIF v_nr_comenzi >= 1 THEN
        v_bonus := 50;
    ELSE
        v_bonus := 0;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Bonusul este '||v_bonus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista casierul');
END;
/


-- 9. Scrieți un bloc PL/SQL în care stocați prin variabile de substituție un cod de angajat si un cod de
-- restaurant. Să se mute angajatul în noul restaurant. Daca modificarea s-a putut realiza
-- (există în tabel ANGAJAT un salariat având codul respectiv) să se afișeze mesajul “Actualizare
-- realizata”, iar în caz contrar mesajul “Nu exista un angajat cu acest cod”. Anulați modificările
-- realizate.

DECLARE
    v_cod_ang angajat.id_angajat%TYPE := &p_cod_ang;
    v_cod_rst angajat.id_restaurant%TYPE := &p_cod_rst;
BEGIN
    UPDATE ANGAJAT
    SET id_restaurant = v_cod_rst
    WHERE id_angajat = v_cod_ang;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
    END IF;

    ROLLBACK;
END;
