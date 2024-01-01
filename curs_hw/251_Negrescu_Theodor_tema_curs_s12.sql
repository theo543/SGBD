/*
 1. Să se ilustreze printr-un exemplu de program PL/SQL multi-bloc modul de propagare al excepțiilor.
Vor fi ilustrate cel putin situațiile în care o excepție este tratată sau nu în blocul curent și în care controlul programului va fi transmis blocului următor din secvență sau blocului exterior.
*/

BEGIN
    BEGIN
        BEGIN
            BEGIN
                BEGIN
                    BEGIN
                        BEGIN
                            dbms_output.PUT_LINE('Împărțirea la zero ridică o excepție predefinită TOO_MANY_ROWS.');
                            dbms_output.PUT_LINE(1 / 0);
                        END;
                    END;
                END;
            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    dbms_output.PUT_LINE('Nu se va rula acest handler deoarece excepția nu este de tipul TOO_MANY_ROWS. Excepția se va propaga în blocurile părinte.');
            END;
        END;
    END;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        dbms_output.PUT_LINE('Excepțiile se progagă până la primul handler potrivit, indiferent de adâncimea imbricării.');
END;

BEGIN
    DECLARE
        v_data BINARY_INTEGER;
    BEGIN
        dbms_output.PUT_LINE('Excepția predefinită NO_DATA_FOUND este ridicată când un SELECT INTO returnează 0 rânduri.');
        SELECT 1
        INTO v_data
        FROM DUAL
        WHERE rownum = 2;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.PUT_LINE('După ce o excepție este tratată, execuția iese din bloc. Codul din afara blocului nu este afectat de excepții ridicate și tratate în bloc.');
    END;
    DECLARE
        v_data BINARY_INTEGER;
    BEGIN
        dbms_output.PUT_LINE('Acest text va fi printat deoarece excepția NO_DATA_FOUND a fost tratată, deci nu va afecta acest bloc.');
        SELECT 1
        INTO v_data
        FROM DUAL
        UNION
        SELECT 2
        FROM DUAL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.PUT_LINE('Nu se va printa acest text deoarece excepția nu este NO_DATA_FOUND. Următorul handler va fi rulat deoarece excepția este TOO_MANY_ROWS.');
        WHEN TOO_MANY_ROWS THEN
            dbms_output.PUT_LINE('Excepția predefinită TOO_MANY_ROWS este ridicată când un SELECT INTO returnează multiple rânduri.');
    END;
END;

/*
 2. Să se ilustreze prin exemple folosirea instrucțiunii RAISE pentru a ridica atât o excepție predefinită cât și o excepție definită de utilizator.
În cazul excepțiilor predefinite, să se explice cum anume folosirea instrucțiunii RAISE schimbă funcționalitatea programului (față de cazul când această instrucțiune nu există).
*/

BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'RAISE_APPLICATION_ERROR folosește pentru a ridica excepții cu un cod și mesaj personalizat.');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.PUT_LINE('Orice se prinde cu WHEN OTHERS, chiar și un cod care nu are o excepție asociată. SQLCODE = '||SQLCODE||', SQLERRM = '||SQLERRM);
END;

DECLARE
    custom_exception EXCEPTION;
    custom_exception_with_custom_code EXCEPTION;
    row_overflow EXCEPTION;
    too_many_varray_values EXCEPTION;
    PRAGMA EXCEPTION_INIT (custom_exception_with_custom_code, -20000);
    PRAGMA EXCEPTION_INIT (row_overflow, -01422);
    PRAGMA EXCEPTION_INIT (too_many_varray_values, -22165);
BEGIN
    BEGIN
        dbms_output.PUT_LINE('Expecțiile definite de utilizatori se definesc similar cu variabilele.');
        dbms_output.PUT_LINE('Se poate asocia un cod de eroare folosing PRAGMA EXCEPTION_INIT');
        RAISE custom_exception_with_custom_code;
    EXCEPTION
        WHEN custom_exception_with_custom_code THEN
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
    BEGIN
        RAISE_APPLICATION_ERROR(-20000, 'Dacă excepția are un cod asociat, se poate folosi RAISE_APPLICATION_ERROR pentru a ridica eroarea, și WHEN o va prinde.');
    EXCEPTION
        WHEN custom_exception_with_custom_code THEN
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
    BEGIN
        dbms_output.PUT_LINE('Implicit, excepțiile definite de utilizator nu au un cod asociat.');
        RAISE custom_exception;
    EXCEPTION
        WHEN custom_exception THEN
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
    BEGIN
        BEGIN
            dbms_output.PUT_LINE(1 / 0);
        EXCEPTION
            WHEN ZERO_DIVIDE THEN
                dbms_output.PUT_LINE('Excepțiile pot fi re-ridicate pentru a continua propagarea. Se poate folosi pentru a raporta detalii despre o eroare, apoi a trimite excepția mai sus.');
                RAISE;
        END;
        dbms_output.PUT_LINE('Deși excepția a fost tratată, nu se va printa acest text deoarece a fost re-ridicată.');
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            dbms_output.PUT_LINE('Excepția va fi propagată, la fel ca o excepție netratată.');
    END;
    DECLARE
        v_data BINARY_INTEGER;
    BEGIN
        SELECT 1
        INTO v_data
        FROM DUAL
        UNION
        SELECT 2
        FROM DUAL;
    EXCEPTION
        WHEN row_overflow THEN
            dbms_output.PUT_LINE('Se poate defini un nume nou pentru excepțiile predefinite.');
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
    DECLARE
        TYPE int_varray IS VARRAY(10) OF BINARY_INTEGER;
        array int_varray := int_varray();
    BEGIN
        SELECT LEVEL
        BULK COLLECT INTO array
        FROM DUAL
        CONNECT BY LEVEL <= 11;
    EXCEPTION
        WHEN too_many_varray_values THEN
            dbms_output.PUT_LINE('Unele excepții predefinite nu au un nume asociat predefinit. Totuși, se poate defini un nume folosing EXCEPTION_INIT.');
            dbms_output.PUT_LINE('Când o excepție predefinită este ridicată automat, se generează un mesaj de eroare în limba utilizatorului.');
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
    BEGIN
        RAISE too_many_varray_values;
    EXCEPTION
        WHEN too_many_varray_values THEN
            dbms_output.PUT_LINE('Când se folosește RAISE pentru a ridica o excepție predefinită, mesajul de eroare nu se va crea corect.');
            dbms_output.PUT_LINE('SQLCODE: '||SQLCODE||' SQLERRM:'||SQLERRM);
    END;
END;
