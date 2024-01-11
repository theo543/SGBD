/*
Să se afle care dintre casierii angajați de un manager au adus cel mai mult profit companiei.
Managerul se precizează prin nume.
Se vor raporta următoarele cazuri excepționale:
- numele nu există
- numele nu e unic (se vor preciza ID-urile angajaților găsiți)
- angajatul nu e manager (se va preciza ce este)
- managerul nu a angajat niciun casier (se va preciza dacă are autorizare și nu a angajat înca, sau nu are deloc)
*/

CREATE OR REPLACE FUNCTION gaseste_casierul_cel_mai_profitabil(nume_angajator VARCHAR2) RETURN angajat.id_angajat%TYPE
IS
    TYPE lista_id IS TABLE OF angajat.id_angajat%TYPE;
    manager_gasit angajat.id_angajat%TYPE;
    casier_gasit angajat.id_angajat%TYPE;
BEGIN
    DECLARE
        rezultate lista_id := lista_id();
        este_manager BINARY_INTEGER;
    BEGIN
        SELECT id_angajat
        BULK COLLECT INTO rezultate
        FROM angajat
        WHERE nume = nume_angajator;
        CASE rezultate.COUNT
            WHEN 0 THEN
                RAISE_APPLICATION_ERROR(-20000, 'Nu a fost găsit un angajat cu numele "'||nume_angajator||'"'||'.');
            WHEN 1 THEN
                manager_gasit := rezultate(1);
            ELSE
                DECLARE
                    err_msg VARCHAR2(255);
                BEGIN
                    err_msg := 'Multiplii angajați au numele "'||nume_angajator||'":';
                    FOR i IN 1..rezultate.COUNT
                    LOOP
                        err_msg := err_msg||' '||rezultate(i);
                    END LOOP;
                    RAISE_APPLICATION_ERROR(-20003, err_msg);
                EXCEPTION
                    WHEN VALUE_ERROR THEN
                        RAISE_APPLICATION_ERROR(-20003, err_msg || '[...]');
                END;
        END CASE;
        SELECT COUNT(id_angajat)
        INTO este_manager
        FROM manager
        WHERE id_angajat = manager_gasit;
        IF este_manager = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Angajatul '||nume_angajator||' (ID '||manager_gasit||') nu este manager.');
        END IF;
    END;
    BEGIN
        /*
        Patru tabele: CASIER -> COMANDA -> COMANDA_INCLUDE_RETETA (asociativ) -> RETETA
        */
        WITH casieri AS (
            SELECT id_angajat, SUM(pret * nr) profit
            FROM angajat
            JOIN comanda
            ON angajat.id_angajat = comanda.id_casier
            JOIN comanda_include_reteta
            USING (id_comanda)
            JOIN reteta
            USING (id_reteta)
            WHERE job_cod = 'CASIER' AND id_angajator = manager_gasit
            GROUP BY id_angajat
            ORDER BY profit
        )
        SELECT id_angajat
        INTO casier_gasit
        FROM casieri
        WHERE rownum = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Managerul '||nume_angajator||' (ID '||manager_gasit||') nu are casieri.');
    END;
    RETURN casier_gasit;
END gaseste_casierul_cel_mai_profitabil;
/

DECLARE
    /*
    Excepțiile nu pot fi declarate global, deoarece nu se poate stoca o excepție în bază da date.
    Deci blocurile care vor să le prindă trebuie să creeze excepțiile și să le știe codurile.
    Când va fi creată versiunea cu pachet a acestei cerințe, vor putea fi declarate în specificația pachetului.
    */
    nume_nu_exista EXCEPTION;
    angajat_nu_e_manager EXCEPTION;
    manager_nu_are_casieri EXCEPTION;
    PRAGMA EXCEPTION_INIT (nume_nu_exista, -20000);
    PRAGMA EXCEPTION_INIT (angajat_nu_e_manager, -20001);
    PRAGMA EXCEPTION_INIT (manager_nu_are_casieri, -20002);
    /*
    Cursorul extrage automat date de test, independent de datele din tabel, fără a hardcoda nume.
    Se vor returna how_many_of_each (sau dacă nu se poate, cât mai mulți) angajați pentru categoriile:
    - manageri cu angajați
    - manageri fără angajați
    - angajați non-manager
    - nume non-existent
    Va funționa chiar dacă seed-ul RNG pentru generarea datelor angajaților este schimbat.
    Excepția de nume ambiguu va fi testată separat deoarece necesită inserarea de date în tabel.
    */
    CURSOR test_data(how_many_of_each NUMBER)
    IS
    WITH are_angajat_da_nu AS (
        /*
        Nu e suficienăm să verificăm dacă e autorizat, nu garantează că a angajat pe cineva încă.
        */
        SELECT id_angajat, nume, (
            SELECT DECODE(COUNT(a2.id_angajat), 0, 0, 1)
            FROM angajat a2
            WHERE id_angajator = a1.id_angajat
        ) AS tip_test
        FROM angajat a1
        WHERE job_cod = 'MANAGER'
    )
    SELECT *
    FROM (
        SELECT are_angajat_da_nu.*, row_number() over (partition by tip_test order by id_angajat) repeat_nr
        FROM are_angajat_da_nu
    )
    WHERE repeat_nr <= how_many_of_each
    UNION
    SELECT id_angajat, nume, 2, rownum
    FROM angajat
    WHERE job_cod != 'MANAGER' AND rownum <= how_many_of_each
    UNION
    SELECT -1, 'NONEXISTENT ' ||LEVEL||' (TEST)', 3, LEVEL FROM DUAL
    CONNECT BY LEVEL <= how_many_of_each;

    test_case_nr BINARY_INTEGER := 1;
    TYPE labels IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
    test_names labels := labels();
BEGIN
    test_names(0) := 'Manager fără angajați';
    test_names(1) := 'Manager cu angajați';
    test_names(2) := 'Non-manager';
    test_names(3) := 'Nume non-existent';

    FOR test_row IN test_data(3)
    LOOP
        dbms_output.PUT('Test '||LPAD(test_case_nr, 2)||
                        ' - '||test_names(test_row.tip_test)||
                        ' - '||test_row.nume||
                        ' - rezultat test: ');
        DECLARE
            casier angajat.id_angajat%TYPE;
        BEGIN
            casier := gaseste_casierul_cel_mai_profitabil(test_row.nume);
            dbms_output.PUT_LINE('ID casier = '||casier);
        EXCEPTION
            WHEN angajat_nu_e_manager THEN
                dbms_output.PUT_LINE('!! eroare angajat_nu_e_manager !! - '||SQLERRM);
            WHEN manager_nu_are_casieri THEN
                dbms_output.PUT_LINE('!! eroare manager_nu_are_casieri !! - '||SQLERRM);
            WHEN nume_nu_exista THEN
                dbms_output.PUT_LINE('!! eroare nume_nu_exista !! - '||SQLERRM);
        END;
        test_case_nr := test_case_nr + 1;
    END LOOP;
END;

/*
 Testare caz nume ambiguu. Se vor insera date ambigue, se va apela funcția, apoi se va face ROLLBACK.
*/

INSERT INTO angajat (id_angajat, id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
SELECT 1000 + LEVEL, 1, NULL, 'MANAGER', 'Test Ambiguu', SYSDATE, 0
FROM DUAL
CONNECT BY LEVEL <= 100;

INSERT INTO manager (id_angajat, autorizat_sa_angajeze)
SELECT id_angajat, 1 FROM angajat
WHERE nume = 'Test Ambiguu';

DECLARE
    nume_ambiguu EXCEPTION;
    PRAGMA EXCEPTION_INIT (nume_ambiguu, -20003);
BEGIN
    dbms_output.PUT('Test ambiguu: ');
    BEGIN
        dbms_output.PUT_LINE('(nu ar trebui să se afișeze asta) ID casier = ' ||
                             gaseste_casierul_cel_mai_profitabil('Test Ambiguu'));
    EXCEPTION
        WHEN nume_ambiguu THEN
            dbms_output.PUT_LINE('!! nume_ambiguu !! - '||SQLERRM);
    END;
END;

ROLLBACK;



DROP PROCEDURE gaseste_casierul_cel_mai_profitabil;
