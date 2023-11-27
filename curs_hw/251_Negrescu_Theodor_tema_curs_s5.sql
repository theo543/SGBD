-- Pentru fiecare casă, să se afle, pentru fiecare client care a folosit-o,
-- totalul sumelor din facturi achitate și neachitate, și id-urile acelor facturi.

-- Notă: această operație este o denormalizare a bazei de date.
-- Acest lucru este inevitabil, deoarece cerința specifică să se actualizeze
-- noua coloana cu informații din schema, deci este calculată
-- din date deja existente in tabel, deci introduce redundanță.

-- O listă de ID-uri de facturi. Keyword-ul %TYPE nu pare să meargă aici.
CREATE TYPE lista_facturi IS TABLE OF NUMBER(20);
/
-- Activitatea unui client la o anumită casă - facturile achitate și neachitate, si sumele.
CREATE TYPE activitate_client IS OBJECT (id_client NUMBER(10), suma_achitate NUMBER(10), suma_neachitate NUMBER(10), achitate lista_facturi, neachitate lista_facturi);
/
-- Lista activităților tuturor clienților la o casă.
CREATE TYPE lista_activitate IS TABLE OF activitate_client;

ALTER TABLE CASE
ADD activitate_clienti lista_activitate
DEFAULT lista_activitate()
NESTED TABLE activitate_clienti STORE AS NESTED_case_lista_activitate
(NESTED TABLE achitate STORE AS NESTED_case_lista_activitate_NESTED_achitate,
 NESTED TABLE neachitate STORE AS NESTED_case_lista_activitate_NESTED_neachitate);

DECLARE
    SUBTYPE st_id_client IS FACTURI.id_client%TYPE;
    SUBTYPE st_id_casa IS FACTURI.id_casa%TYPE;
    TYPE info_factura IS RECORD ( id_factura FACTURI.id_factura%TYPE,
                                  id_casa st_id_casa,
                                  id_client st_id_client,
                                  status FACTURI.status%TYPE,
                                  suma_facturare FACTURI_CONTIN_PRODUSE.pret_facturare%TYPE);
    v_factura info_factura;
    v_casa_curenta st_id_casa := NULL;
    v_activitate activitate_client := NULL;
    PROCEDURE init_activitate(casa IN st_id_casa, client IN st_id_client) IS
    BEGIN
        v_casa_curenta := casa;
        v_activitate := activitate_client(client, 0, 0, lista_facturi(), lista_facturi());
    END;
    PROCEDURE save_activitate IS
    BEGIN
        IF v_activitate IS NULL
        THEN
            RETURN;
        END IF;
        INSERT INTO TABLE(SELECT ACTIVITATE_CLIENTI FROM CASE WHERE ID_CASA = v_casa_curenta)
        VALUES (v_activitate);
        v_activitate := NULL;
        v_casa_curenta := NULL;
    END;
BEGIN
    FOR v_factura IN (SELECT id_factura, id_casa, id_client, status, SUM(pret_facturare) suma_facturare
                      FROM FACTURI
                      JOIN FACTURI_CONTIN_PRODUSE
                      USING (id_factura)
                      GROUP BY (id_factura, id_casa, id_client, status)
                      ORDER BY id_casa, id_client, id_factura)
    LOOP
        IF v_activitate IS NULL OR v_activitate.ID_CLIENT != v_factura.ID_CLIENT OR v_casa_curenta != v_factura.ID_CASA
        THEN
            save_activitate();
            init_activitate(v_factura.ID_CASA, v_factura.ID_CLIENT);
        END IF;
        IF v_factura.STATUS = 'achitat'
        THEN
            v_activitate.suma_achitate := v_activitate.suma_achitate + v_factura.suma_facturare;
            v_activitate.ACHITATE.EXTEND;
            v_activitate.ACHITATE(v_activitate.ACHITATE.LAST) := v_factura.ID_FACTURA;
        ELSIF v_factura.STATUS = 'neachitat'
        THEN
            v_activitate.suma_neachitate := v_activitate.suma_neachitate + v_factura.suma_facturare;
            v_activitate.NEACHITATE.EXTEND;
            v_activitate.NEACHITATE(v_activitate.NEACHITATE.LAST) := v_factura.ID_FACTURA;
        ELSE
            DBMS_OUTPUT.PUT_LINE('WARNING: status factura "'||v_factura.STATUS||'" necunoscut');
        END IF;
    END LOOP;
    save_activitate();
END;
/

SELECT * FROM CASE; 

ALTER TABLE CASE
DROP COLUMN activitate_clienti;

DROP TYPE lista_activitate;
DROP TYPE activitate_client;
DROP TYPE lista_facturi;
