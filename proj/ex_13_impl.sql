CREATE OR REPLACE PACKAGE BODY pizza IS

    /*
    cursoare interne

    Nu sunt publice din 2 motive:
    1. Sunt detalii de implementare, nu sunt necesare utilizatorului.
    2. Obțin erori legate de REF CURSOR dacă le pun în specificație.
    3. Pare că trebuie să returneze RECORD pentru a putea fi în specificație,
       dar când fac asta nu pot returna RECORD-ul din cursul, chiar dacă folosesc constructorul,
       posibil trebuie să returneze un ROWTYPE pentru a putea pune cursul în specificație.
    */
    CURSOR manageri_cu_angajati
        IS
            WITH ids AS (
                SELECT id_angajat
                FROM casier
                WHERE nr_casa_de_marcat IS NULL
                UNION
                SELECT id_angajat
                FROM bucatar
                WHERE data_antrenament_de_siguranta IS NULL
                UNION
                SELECT id_angajat
                FROM manager
                WHERE autorizat_sa_angajeze = 0
            ),
            incomplet_antrenati AS (
                SELECT id_angajat, id_angajator, nume
                FROM ids
                JOIN angajat
                USING (id_angajat)
            )
            SELECT angajat.id_angajat, nume, CURSOR(
                SELECT id_angajat, nume FROM incomplet_antrenati
                WHERE id_angajator = manager.id_angajat
            ) AS angajati_incomplet_antrenati
            FROM angajat
            JOIN manager
            ON angajat.id_angajat = manager.id_angajat;

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

    CURSOR triggeri_autogenerati
    IS
    SELECT trigger_name
    FROM all_triggers
    WHERE trigger_name LIKE 'LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_%';

    -- tipuri de date interne
    TYPE comanda_riscanta IS RECORD(id_comanda id_cmd, risc BINARY_INTEGER, ingrediente BINARY_INTEGER);
    TYPE top3_comenzi IS VARRAY(3) OF comanda_riscanta;
    TYPE top3_restaurant IS RECORD(id_restaurant id_rst, comenzi top3_comenzi);
    TYPE lista_top3 IS TABLE OF top3_restaurant;
    TYPE risc_anterior IS RECORD(numar BINARY_INTEGER, ultimul_scor BINARY_INTEGER);
    TYPE ingrediente_vazute IS TABLE OF risc_anterior INDEX BY BINARY_INTEGER;
    TYPE ingrediente_in_comanda IS TABLE OF id_ing;
    TYPE refc IS REF CURSOR;
    TYPE lista_ang IS TABLE OF id_ang;
    TYPE lista_alg IS TABLE OF nume_alg;
    TYPE labels IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;

    -- subprograme
    PROCEDURE afiseaza_top_3_comenzi_riscante
    IS
        lista_finala lista_top3 := lista_top3();
    BEGIN
        FOR id_restaurant_row IN (
            SELECT id_restaurant
            FROM restaurant
        )
        LOOP
            DECLARE
                blank comanda_riscanta := comanda_riscanta(-1, -1);
                clasament top3_comenzi := top3_comenzi(blank, blank, blank);
            BEGIN
                FOR id_comanda_row IN (
                    SELECT id_comanda
                    FROM comanda
                    WHERE id_restaurant = id_restaurant_row.id_restaurant
                )
                LOOP
                    DECLARE
                        ingrediente ingrediente_in_comanda;
                        vazute ingrediente_vazute;
                        risc_comanda BINARY_INTEGER := 0;
                        PROCEDURE insert_record(i NUMBER)
                        IS
                        BEGIN
                            clasament(i) := comanda_riscanta(id_comanda_row.id_comanda, risc_comanda, ingrediente.count);
                        END;
                    BEGIN
                        WITH ingr AS (
                            SELECT id_ingredient, nr
                            FROM comanda
                            JOIN comanda_include_reteta
                            USING (id_comanda)
                            JOIN reteta_contine_ingredient
                            USING (id_reteta)
                            WHERE id_comanda = id_comanda_row.id_comanda
                        ),
                        numbers AS (
                            SELECT LEVEL AS lvl
                            FROM DUAL
                            CONNECT BY LEVEL <= (SELECT MAX(nr) FROM ingr)
                        )
                        SELECT id_ingredient
                        BULK COLLECT INTO ingrediente
                        FROM ingr
                        JOIN numbers
                        ON (nr <= lvl);

                        FOR i IN 1..ingrediente.LAST
                        LOOP
                            DECLARE
                                igr id_ing := ingrediente(i);
                            BEGIN
                                IF NOT vazute.exists(ingrediente(i))
                                THEN
                                    vazute(igr) := risc_anterior(0, 0);
                                END IF;
                                CASE vazute(igr).numar
                                    WHEN 0 THEN
                                        vazute(igr) := risc_anterior(1, 100);
                                    WHEN 1 THEN
                                        vazute(igr) := risc_anterior(2, 50);
                                    WHEN 2 THEN
                                        vazute(igr) := risc_anterior(3, 50);
                                    ELSE
                                        vazute(igr) := risc_anterior(vazute(igr).numar + 1, vazute(igr).ultimul_scor * 0.6);
                                END CASE;
                                risc_comanda := risc_comanda + vazute(igr).ultimul_scor;
                            END;
                        END LOOP;

                        IF risc_comanda > clasament(1).risc THEN
                            clasament(3) := clasament(2);
                            clasament(2) := clasament(1);
                            insert_record(1);
                        ELSIF risc_comanda > clasament(2).risc THEN
                            clasament(3) := clasament(2);
                            clasament(2) := comanda_riscanta(id_comanda_row.id_comanda, risc_comanda);
                            insert_record(2);
                        ELSIF risc_comanda > clasament(3).risc THEN
                            insert_record(3);
                        END IF;
                    END;
                END LOOP;
                lista_finala.extend(1);
                lista_finala(lista_finala.last) := top3_restaurant(id_restaurant_row.id_restaurant, clasament);
            END;
        END LOOP;

        FOR i IN 1..lista_finala.LAST
        LOOP
            DECLARE
                top3 top3_comenzi := lista_finala(i).comenzi;
                id_rest id_rst := lista_finala(i).id_restaurant;
                FUNCTION str(comanda comanda_riscanta) RETURN VARCHAR2
                IS
                BEGIN
                    RETURN '[Comanda '||comanda.id_comanda||', risc '||comanda.risc||', nr. ingrediente '||comanda.ingrediente||']';
                END;
            BEGIN
                dbms_output.PUT_LINE(
                        'Restaurantul '||id_rest||': '||
                        str(top3(1))||', '||
                        str(top3(2))||', '||
                        str(top3(3))||'.'
                );
            END;
        END LOOP;
    END afiseaza_top_3_comenzi_riscante;

    PROCEDURE afiseaza_angajati_incomplet_antrenati
    IS
        nume_manager nume_ang;
        id_manager id_ang;
        nume_angajat nume_ang;
        id_angajat id_ang;
        ref refc;
    BEGIN
        OPEN manageri_cu_angajati;
        LOOP
            FETCH manageri_cu_angajati INTO id_manager, nume_manager, ref;
            EXIT WHEN manageri_cu_angajati%NOTFOUND;
            dbms_output.PUT_LINE('Manager '||nume_manager||' (ID '||id_manager||') - Angajati care nu sunt complet antrenati:');
            FETCH ref INTO id_angajat, nume_angajat;
            IF ref%NOTFOUND
            THEN
                dbms_output.PUT_LINE('  Niciunul!');
                CONTINUE;
            END IF;
            LOOP
                dbms_output.PUT_LINE('  '||nume_angajat||' (ID '||id_angajat||')');
                FETCH ref INTO id_angajat, nume_angajat;
                EXIT WHEN ref%NOTFOUND;
            END LOOP;
            CLOSE ref;
        END LOOP;
        CLOSE manageri_cu_angajati;
    END afiseaza_angajati_incomplet_antrenati;

    FUNCTION gaseste_casierul_cel_mai_profitabil(nume_angajator VARCHAR2) RETURN id_ang
    IS
        manager_gasit id_ang;
        casier_gasit id_ang;
    BEGIN
        DECLARE
            rezultate lista_ang := lista_ang();
            este_manager BINARY_INTEGER;
        BEGIN
            SELECT id_angajat
            BULK COLLECT INTO rezultate
            FROM angajat
            WHERE nume = nume_angajator;
            CASE rezultate.COUNT
                WHEN 0 THEN
                    RAISE_APPLICATION_ERROR(pizza.cod_nume_nu_exista, 'Nu a fost găsit un angajat cu numele "'||nume_angajator||'"'||'.');
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
                        RAISE_APPLICATION_ERROR(pizza.cod_nume_ambiguu, err_msg);
                    EXCEPTION
                        WHEN VALUE_ERROR THEN
                            RAISE_APPLICATION_ERROR(pizza.cod_nume_ambiguu, err_msg || '[...]');
                    END;
            END CASE;
            SELECT COUNT(id_angajat)
            INTO este_manager
            FROM manager
            WHERE id_angajat = manager_gasit;
            IF este_manager = 0 THEN
                RAISE_APPLICATION_ERROR(pizza.cod_angajat_nu_e_manager, 'Angajatul '||nume_angajator||' (ID '||manager_gasit||') nu este manager.');
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
                RAISE_APPLICATION_ERROR(pizza.cod_manager_nu_are_casieri, 'Managerul '||nume_angajator||' (ID '||manager_gasit||') nu are casieri.');
        END;
        RETURN casier_gasit;
    END gaseste_casierul_cel_mai_profitabil;

    PROCEDURE ruleaza_teste_ex8_1
    IS
        test_case_nr BINARY_INTEGER := 1;
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
                casier id_ang;
            BEGIN
                casier := pizza.gaseste_casierul_cel_mai_profitabil(test_row.nume);
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
    END ruleaza_teste_ex8_1;

    PROCEDURE ruleaza_teste_ex8_2
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO angajat (id_angajat, id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
        SELECT 1000 + LEVEL, 1, NULL, 'MANAGER', 'Test Ambiguu', SYSDATE, 0
        FROM DUAL
        CONNECT BY LEVEL <= 100;

        INSERT INTO manager (id_angajat, autorizat_sa_angajeze)
        SELECT id_angajat, 1 FROM angajat
        WHERE nume = 'Test Ambiguu';

        BEGIN
            dbms_output.PUT('Test ambiguu: ');
            BEGIN
                dbms_output.PUT_LINE('(nu ar trebui să se afișeze asta) ID casier = ' ||
                                     gaseste_casierul_cel_mai_profitabil('Test Ambiguu'));
            EXCEPTION
                WHEN pizza.nume_ambiguu THEN
                    dbms_output.PUT_LINE('!! nume_ambiguu !! - '||SQLERRM);
            END;
        END;

        ROLLBACK;
    END ruleaza_teste_ex8_2;

    PROCEDURE generate_meniu(file_name VARCHAR2)
    IS
        alergii lista_alg := lista_alg();

        output_buffer VARCHAR2(1023);
        LF_CODE BINARY_INTEGER := 10;

        PROCEDURE put(str VARCHAR2)
        IS
        BEGIN
            output_buffer := output_buffer||str;
        EXCEPTION
            WHEN VALUE_ERROR THEN
                RAISE_APPLICATION_ERROR(pizza.cod_need_increased_output_buffer_size,
                                        'Meniu prea mare, trebuie crescuta mărinea lui output_buffer (curent: '||1023||')');
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
                RAISE_APPLICATION_ERROR(pizza.cod_meniu_export_error, REPLACE(template_str, 'FNAME', file_name));
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
    END generate_meniu;

    PROCEDURE ruleaza_teste_ex9_1
    IS
    BEGIN
        pizza.generate_meniu('meniu_pachet.html');
        dbms_output.PUT_LINE('meniu_pachet.html generat cu succes.');
        BEGIN
            pizza.generate_meniu('/');
        EXCEPTION
            WHEN pizza.meniu_export_error THEN
                dbms_output.PUT_LINE(SQLERRM);
        END;
        BEGIN
            pizza.generate_meniu('?');
        EXCEPTION
            WHEN pizza.meniu_export_error THEN
                dbms_output.PUT_LINE(SQLERRM);
        END;
    END ruleaza_teste_ex9_1;

    PROCEDURE ruleaza_teste_ex9_2
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO reteta (id_reteta, nume, pret)
        SELECT 1000 + LEVEL, 'Test row '||LEVEL, 0
        FROM DUAL
        CONNECT BY LEVEL <= 1000;
        pizza.generate_meniu('meniu.html');
        dbms_output.PUT_LINE('!! Nu ar trebui să se ajungă aici !!');
        ROLLBACK;
    EXCEPTION
        WHEN pizza.need_increased_output_buffer_size THEN
            dbms_output.PUT_LINE(SQLERRM);
            ROLLBACK;
    END ruleaza_teste_ex9_2;

    PROCEDURE banner(title VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('============================================');
        DBMS_OUTPUT.PUT_LINE('== ' || title);
        DBMS_OUTPUT.PUT_LINE('============================================');
    END;

    PROCEDURE ruleaza_teste_ex_6_7_8_9
    IS
    BEGIN
        banner('ex6');
        pizza.AFISEAZA_TOP_3_COMENZI_RISCANTE();
        banner('ex7');
        pizza.AFISEAZA_ANGAJATI_INCOMPLET_ANTRENATI();
        banner('ex8');
        pizza.RULEAZA_TESTE_EX8_1();
        EXECUTE IMMEDIATE 'ALTER TRIGGER limita_angajati DISABLE';
        pizza.RULEAZA_TESTE_EX8_2();
        EXECUTE IMMEDIATE 'ALTER TRIGGER limita_angajati ENABLE';
        banner('ex9');
        pizza.RULEAZA_TESTE_EX9_1();
        pizza.RULEAZA_TESTE_EX9_2();
    END;

    PROCEDURE create_modification_log(tabel VARCHAR2)
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
        INSERT INTO log_modificari_anormale (nume_tabel, tip_operatie) VALUES (tabel, tip);
    END create_modification_log;

    PROCEDURE instalare_triggeri_autogenerat
    IS
        template VARCHAR2(1023) := 'CREATE OR REPLACE TRIGGER LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_{{NUMETABEL}}
            BEFORE INSERT OR UPDATE OR DELETE ON {{NUMETABEL}}
        BEGIN
            pizza.create_modification_log(''{{NUMETABEL}}'');
        END;';
        cod VARCHAR2(1023);
    BEGIN
        FOR i IN 1..pizza.lista_tabele_monitorizate.LAST
        LOOP
            cod := REPLACE(template, '{{NUMETABEL}}', pizza.lista_tabele_monitorizate(i));
            EXECUTE IMMEDIATE cod;
        END LOOP;
    END instalare_triggeri_autogenerat;

    PROCEDURE stergere_triggeri_autogenerat
    IS
    BEGIN
        FOR trigger_autogenerat IN triggeri_autogenerati
        LOOP
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_autogenerat.trigger_name;
        END LOOP;
    END stergere_triggeri_autogenerat;

    PROCEDURE impl_trigger_eroare_mutating_per_row(new_id_rst id_rst)
    IS
        v_total NUMBER(10);
    BEGIN
        SELECT COUNT(id_angajat)
        INTO v_total
        FROM angajat
        WHERE id_restaurant = new_id_rst;
        IF v_total > 5 THEN
            RAISE_APPLICATION_ERROR(pizza.cod_limita_angajati_incalcata, 'Nu pot fi peste 5 angajați într-un restaurant!');
        END IF;
    END impl_trigger_eroare_mutating_per_row;

    PROCEDURE impl_trigger_limita_angajati_per_row(old_id_rst id_rst, new_id_rst id_rst)
    IS
        v_nr_angajati BINARY_INTEGER;
    BEGIN
        IF DELETING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati - 1
            WHERE id_restaurant = old_id_rst;
        END IF;
        IF INSERTING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati + 1
            WHERE id_restaurant = new_id_rst
            RETURNING nr_angajati INTO v_nr_angajati;
            IF v_nr_angajati > 5 THEN
                raise_application_error(pizza.cod_limita_angajati_incalcata, 'Nu pot fi mai mult de 5 angajați într-un restaurant!');
            END IF;
        END IF;
    END impl_trigger_limita_angajati_per_row;

    PROCEDURE log_ddl_neanulabil
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO incercari_log (operation, obj_type, obj_name)
        VALUES (sys.sysevent, sys.DICTIONARY_OBJ_TYPE(), sys.DICTIONARY_OBJ_NAME());
        COMMIT;
    END log_ddl_neanulabil;

    PROCEDURE impl_trigger_protectie_tabele_ddl
    IS
    BEGIN
        FOR i IN 1..pizza.lista_tabele_protejate.COUNT
        LOOP
            IF (UPPER(sys.DICTIONARY_OBJ_NAME()) = pizza.lista_tabele_protejate(i))
            THEN
                log_ddl_neanulabil;
                RAISE_APPLICATION_ERROR(pizza.cod_ddl_interzis, 'Nu se poate folosi DDL pe tabelele protejate!');
            END IF;
        END LOOP;
    END impl_trigger_protectie_tabele_ddl;
END pizza;
