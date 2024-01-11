/*
Pentru fiecare manager, să se afișeze angajații angajați de el care nu sunt complet antrenați.
Se consideră incomplet antrenați:
casierii fără casă de marcat,
bucătarii care nu au primit încă noul antrenament de siguranță al companiei,
și managerii care nu sunt autorizați să angajeze.
*/

CREATE OR REPLACE PROCEDURE afiseaza_angajati_incomplet_antrenati
IS
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
    TYPE refc IS REF CURSOR;
    ref refc;
    nume_manager angajat.nume%TYPE;
    id_manager angajat.id_angajat%TYPE;
    nume_angajat angajat.nume%TYPE;
    id_angajat angajat.id_angajat%TYPE;
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
/

BEGIN
    afiseaza_angajati_incomplet_antrenati();
END;
/

DROP PROCEDURE afiseaza_angajati_incomplet_antrenati;
