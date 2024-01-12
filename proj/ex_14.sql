/*
 Compania are niște probleme:
 1. Regulile de salarii de bază și bonus maxim nu au fost comunicate corect.
    Acum sunt niște angajați care au salarii care nu se încadrează în limitele
 2. Sunt dificultăți la antrenarea angajaților.
    Unii sunt incomplet antrenați.

 Compania trebuie să urmărească aceste probleme cu atenție.
 E nevoie de un raport pentru a ține evidența acestor probleme.
 Raportul trebuie să poate fi generat doar pentru anumite probleme.
 Trebui să fie extensibil pentru a putea fi adăugate noi tipuri de probleme.
 Așadar codul va fi modular.
*/

CREATE OR REPLACE PACKAGE rapoarte AS
    TYPE angajat_asociat_problemei IS RECORD (
        id_angajat angajat.id_angajat%TYPE,
        nume_angajat angajat.nume%TYPE
    );
    TYPE problema IS RECORD (
        angajat angajat_asociat_problemei,
        tip BINARY_INTEGER,
        descriere VARCHAR2(127)
    );
    TYPE lista_probeme IS TABLE OF problema;
    TYPE probleme_restaurant IS RECORD (
        nume_oras oras.nume%TYPE,
        probleme lista_probeme := lista_probeme()
    );
    TYPE raport IS TABLE OF probleme_restaurant INDEX BY BINARY_INTEGER;
    SUBTYPE raport_html_buffer IS VARCHAR2(32767);
    FUNCTION init_raport RETURN raport;
    PROCEDURE adauga_problema_in_lista(p_lista IN OUT lista_probeme, p_problema IN problema);
    PROCEDURE adauga_anomalii_salarii(p_raport IN OUT raport);
    PROCEDURE adauga_angajati_incomplet_antrenati(p_raport IN OUT raport);
    FUNCTION render_html(p_raport IN raport) RETURN VARCHAR2;
    FUNCTION quick_generate_raport(enable_1 BOOLEAN, enable_2 BOOLEAN) RETURN VARCHAR2;
END rapoarte;

CREATE OR REPLACE PACKAGE BODY rapoarte AS
    FUNCTION init_raport RETURN raport IS
        ret raport;
    BEGIN
        FOR rest IN (
            SELECT id_restaurant, nume AS nume_oras
            FROM restaurant
            JOIN oras USING (id_oras)
        )
        LOOP
            ret(rest.id_restaurant) := probleme_restaurant(
                rest.nume_oras,
                lista_probeme()
            );
        END LOOP;
        RETURN ret;
    END init_raport;
    PROCEDURE adauga_problema_in_lista(p_lista IN OUT lista_probeme, p_problema IN problema) IS
    BEGIN
        p_lista.EXTEND;
        p_lista(p_lista.LAST) := p_problema;
    END adauga_problema_in_lista;
    PROCEDURE adauga_anomalii_salarii(p_raport IN OUT raport) IS
    BEGIN
        FOR anomalie IN (
            WITH limite_salarii AS (
                SELECT job_cod, salariu_baza AS salariu_minim, salariu_baza + bonus_maxim AS salariu_maxim
                FROM job
            )
            SELECT id_angajat, salariu_minim, salariu_maxim, salariu, id_restaurant
            FROM angajat
            JOIN limite_salarii USING (job_cod)
            WHERE salariu NOT BETWEEN salariu_minim AND salariu_maxim
        )
        LOOP
            adauga_problema_in_lista(p_raport(anomalie.id_restaurant).probleme,problema(
                angajat_asociat_problemei(anomalie.id_angajat, NULL),
                1,
                'Salariul angajatului este incorect: ' || anomalie.salariu || ' nu este intre ' || anomalie.salariu_minim || ' si ' || anomalie.salariu_maxim
               )
            );
        END LOOP;
    END;
    PROCEDURE adauga_angajati_incomplet_antrenati(p_raport IN OUT raport) IS
    BEGIN
        FOR anomalie IN (
            WITH anomalii AS (
                SELECT id_angajat FROM manager
                WHERE autorizat_sa_angajeze = 0
                UNION
                SELECT id_angajat FROM bucatar
                WHERE data_antrenament_de_siguranta IS NULL
                UNION
                SELECT id_angajat FROM casier
                WHERE nr_casa_de_marcat IS NULL
            )
            SELECT id_angajat, id_restaurant, job_cod
            FROM angajat
            JOIN anomalii USING (id_angajat)
        )
        LOOP
            adauga_problema_in_lista(p_raport(anomalie.id_restaurant).probleme,problema(
                angajat_asociat_problemei(anomalie.id_angajat, NULL),
                2,
                'Angajatul cu job ' || LOWER(anomalie.job_cod) || ' nu este complet antrenat.'
               )
            );
        END LOOP;
    END;
    FUNCTION render_html(p_raport IN raport) RETURN VARCHAR2
    IS
        -- la fel ca la meniu
        output_buffer raport_html_buffer := '';
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
        putln('<html lang="ro"><head><meta charset="utf-8"><title>Raport</title></head><body>');
        putln('<h1>Raport</h1>');
        DECLARE
            i BINARY_INTEGER := p_raport.FIRST;
        BEGIN
            WHILE i IS NOT NULL
            LOOP
                putln('<h2>Restaurantul cu ID ' || i || ' (localizat in ' || p_raport(i).nume_oras || ')</h2><ul>');
                IF p_raport(i).probleme.COUNT = 0 THEN
                    putln('<li>Nu are probleme</li>');
                    i := p_raport.NEXT(i);
                    CONTINUE;
                END IF;
                FOR j IN p_raport(i).probleme.FIRST..p_raport(i).probleme.LAST
                LOOP
                    putln('<li>Angajatul '||
                        p_raport(i).probleme(j).angajat.nume_angajat||
                        ' (ID '||p_raport(i).probleme(j).angajat.id_angajat||') '||
                        'are o problema de tip '||p_raport(i).probleme(j).tip||
                        ': '||p_raport(i).probleme(j).descriere||
                        '</li>'
                    );
                END LOOP;
                putln('</ul>');
                i := p_raport.NEXT(i);
            END LOOP;
        END;
        putln('</body></html>');
        RETURN output_buffer;
    END;
    FUNCTION quick_generate_raport(enable_1 BOOLEAN, enable_2 BOOLEAN) RETURN VARCHAR2
    IS
        raport rapoarte.raport := rapoarte.init_raport;
    BEGIN
        IF enable_1 THEN
            rapoarte.adauga_anomalii_salarii(raport);
        END IF;
        IF enable_2 THEN
            rapoarte.adauga_angajati_incomplet_antrenati(raport);
        END IF;
        RETURN rapoarte.render_html(raport);
    END;
END rapoarte;


CREATE OR REPLACE PROCEDURE gen_raport_to_file(file_name VARCHAR2, enable_1 BOOLEAN DEFAULT TRUE, enable_2 BOOLEAN DEFAULT TRUE)
IS
    handle UTL_FILE.FILE_TYPE;
BEGIN
    IF file_name IS NULL THEN
        handle := UTL_FILE.FOPEN('RAPORT', 'Raport ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24.MI.SS') || '.html', 'w');
    ELSE
        handle := UTL_FILE.FOPEN('RAPORT', file_name, 'w');
    END IF;
    UTL_FILE.PUT(handle, rapoarte.quick_generate_raport(TRUE, TRUE));
    UTL_FILE.FCLOSE(handle);
END;

BEGIN
    gen_raport_to_file('test_raport.html');
    gen_raport_to_file(NULL);
    gen_raport_to_file('test_raport_doar_2.html', FALSE, TRUE);
    gen_raport_to_file('test_raport_doar_1.html', TRUE, FALSE);
END;
