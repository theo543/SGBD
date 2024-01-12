/*
Să se genereze un meniu pentru restaurant.
Trebuie listate rețetele, prețul lor, ingredientele și alergiile asociate fiecărei rețete.
Se va genera în format HTML și se va exporta automat.
*/

/*
!!! Aceste comenzi necesita privilegii de administrator. Trebuie executate din SQL*Plus folosind un cont de administrator. !!!

CREATE OR REPLACE DIRECTORY dir_meniu AS 'C:\pl_sql_meniu';
GRANT READ, WRITE ON DIRECTORY dir_meniu TO PUBLIC;
*/

CREATE OR REPLACE PROCEDURE generate_menu(file_name VARCHAR2)
IS
    TYPE lista_alergii IS VARRAY(3) OF alergie.nume%TYPE;
    alergii lista_alergii := lista_alergii();

    output_buffer VARCHAR2(1023);
    LF_CODE BINARY_INTEGER := 10;

    PROCEDURE put(str VARCHAR2)
    IS
    BEGIN
        output_buffer := output_buffer||str;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20005, 'Meniu prea mare, trebuie crescuta mărinea lui output_buffer (curent: '||1023||')');
    END;

    PROCEDURE putln(str VARCHAR2)
    IS
    BEGIN
        put(str||CHR(LF_CODE));
    END;
BEGIN
    putln('<html lang="ro">'||
            '<head><meta charset="UTF-8"></head>'||
            '<body>'||
            '<h1>Bine ați venit la restaurantul nostru!</h1>'||
            '<p>Oferim următoarele rețete:</p>'||
            '<ul>'
    );
    FOR row_reteta IN (SELECT id_reteta, nume, pret FROM reteta)
    LOOP
        putln('<li><p>'||INITCAP(row_reteta.nume)||' - '||row_reteta.pret||' RON</p>');
        /*
        Cinci tablele: RETETA -> RETETA_CONTINE_INGREDIENT -> INGREDIENT -> INGREDIENT_PROVOACA_ALERGIE -> ALERGIE
        */
        alergii.DELETE;
        SELECT DISTINCT INITCAP(alergie.nume)
        BULK COLLECT INTO alergii
        FROM reteta
        JOIN reteta_contine_ingredient
        USING (id_reteta)
        JOIN ingredient
        USING (id_ingredient)
        JOIN ingredient_provoaca_alergie
        USING (id_ingredient)
        JOIN alergie
        USING (id_alergie)
        WHERE id_reteta = row_reteta.id_reteta;
        IF alergii.count > 0
        THEN
            put('<p><em>Informații alergii: '||alergii(1));
            FOR i IN 2..alergii.last
            LOOP
                put(', '||alergii(i));
            END LOOP;
            putln('.</em></p>');
        END IF;
        putln('</li>');
    END LOOP;
    putln('</body></html>');
    DECLARE
        f UTL_FILE.file_type;
        PROCEDURE rs(template_str VARCHAR2) /* prescurtare pentru raise */
        IS
        BEGIN
            RAISE_APPLICATION_ERROR(-20006, REPLACE(template_str, 'FNAME', file_name));
        END;
    BEGIN
        f := UTL_FILE.fopen('DIR_MENIU', file_name, 'W');
        UTL_FILE.put(f, output_buffer);
        UTL_FILE.FCLOSE(f);
    EXCEPTION
        WHEN UTL_FILE.access_denied THEN
            rs('Serverul Oracle nu are access pentru a crea fișierul FNAME. Posibil locația DIRECTORY DIR_MENIU trebuie schimbată.');
        WHEN UTL_FILE.file_open THEN
            rs('Fișierul FNAME este deja deschis. Nu se poate suprascrie.');
        WHEN UTL_FILE.internal_error THEN
            rs('Eroare necunoscută PL/SQL. Nu se poate genera fișierul FNAME.');
        WHEN UTL_FILE.invalid_filename THEN
            rs('Numele FNAME pentru fișier este invalid.');
        WHEN UTL_FILE.invalid_operation THEN
            rs('Operația pe fișierul FNAME nu a putut fi procesată din motive necunoscute. Verfică dacă folderul lui DIRECTORY DIR_MENIU există, și permisiunile la folder.');
        WHEN UTL_FILE.invalid_path THEN
            rs('Numele sau locația fișiserului FNAME invalid. Este posibil că DIRECTORY DIR_MENIU este configurat incorect.');
        WHEN UTL_FILE.write_error THEN
            rs('Nu s-a putut genera FNAME din cauza unei erori de sistem de operare la scrierea fișierului.');
    END;
END;
/

/*
Majoritatea erorilor UTL_FILE nu pot fi testate într-un bloc:
- access_denied: Nu pare că există pe sistemul Windows, ci eroarea invalid_operation se ridică când fișierul nu poate fi modificat.
                 E posibil că access_denied există doar pe sisteme Linux.
- file_open: Similar, nu pare că există. Când încerc să produc eroarea pe sistem Windows, obțin invalid_operation.
- internal_error: Deoarece această eroare este pentru erori nespecificate în implementarea lui UTL_FILE,
                  nu știu cum să o produc.
- invalid_filename: Se produce ușor, însă pare că doar nume ce conțin / produc eroarea.
                    Bănuiesc că UTL_FILE presupune că Windows permite orice nume ce nu conține /, ca pe un sistem Linux.
                    Alte nume invalide produc invalid_operation, probabil deoarece UTL_FILE întelege răspunsul de la Windows.
- invalid_operation: Pe Windows, dacă fișierul e deschis sau nu avem permisiuni, invalid_operation este ridicat.
                     Deasemenea, pare că unele nume invalide produc invalid_operation în loc de invalid_filename.
- invalid_path: Se produce dacă DIRECTORY nu există, sau dacă nu a fost folosită comanda GRANT pentru a permite acces.
- write_error: Deoarece eroarea este legată de erori de sistem de operare, nu am cum să o forțez să apară.
               Probabil ar fi nevoie de hardware defect sau de un filesystem virtual care simulează erori.
*/

BEGIN
    -- nicio eroare
    generate_menu('meniu.html');
    dbms_output.PUT_LINE('meniu.html generat cu succes!');
END;
/

DECLARE
    file_error EXCEPTION;
    PRAGMA EXCEPTION_INIT (file_error, -20006);
BEGIN
    BEGIN
        generate_menu('/');
    EXCEPTION
        WHEN file_error THEN
            dbms_output.PUT_LINE(SQLERRM);
    END;
    BEGIN
        generate_menu('?');
    EXCEPTION
        WHEN file_error THEN
            dbms_output.PUT_LINE(SQLERRM);
    END;
END;

/*
Eroarea needs_increased_output_buffer se generează ușor prin umplerea tabelului RETETA cu date extra.
*/
INSERT INTO reteta (id_reteta, nume, pret)
SELECT 1000 + LEVEL, 'Test row '||LEVEL, 0
FROM DUAL
CONNECT BY LEVEL <= 1000;

DECLARE
    needs_increased_output_buffer EXCEPTION;
    PRAGMA EXCEPTION_INIT (needs_increased_output_buffer, -20005);
BEGIN
    generate_menu('meniu.html');
EXCEPTION
    WHEN needs_increased_output_buffer THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

ROLLBACK;

DROP PROCEDURE generate_menu;
