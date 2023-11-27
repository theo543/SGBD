-- Pentru clientul cu numărul maxim de facturi, sa se afiseze suma plătită la fiecare achiziție a clientului.
-- Dacă există multiplii clienți, se va afișa un avertisment, apoi este nespecificat pentru care client se vor afisa facturile.
DECLARE
    v_client clienti.id_client%TYPE := -1;
    v_max_count BINARY_INTEGER := 0;
    v_este_ambiguu BOOLEAN := false;

    CURSOR c_nr_facturi
    IS
        SELECT id_client, COUNT(*) facturi
        FROM facturi
        GROUP BY id_client;

    CURSOR c_pret_facturi(v_id_client facturi.id_client%TYPE)
    IS
        SELECT id_factura, SUM(pret_facturare) total
        FROM facturi
        JOIN facturi_contin_produse
        USING (id_factura)
        WHERE id_client = v_id_client
        GROUP BY id_factura;
BEGIN
    FOR client IN c_nr_facturi
    LOOP
        DBMS_OUTPUT.PUT_LINE(client.id_client||' '||client.facturi);
        IF client.facturi > v_max_count
        THEN
            v_max_count := client.facturi;
            v_client := client.id_client;
            v_este_ambiguu := FALSE;
        ELSIF client.facturi = v_max_count
        THEN
            v_este_ambiguu := TRUE;
        END IF;
    END LOOP;

    IF v_este_ambiguu THEN
        dbms_output.PUT_LINE('Warning: multiplii clienți cu nr. max de facturi. Rezultatul va fi imprevizibil.');
    END IF;

    dbms_output.PUT_LINE('Clientul '||v_client||' are nr. maxim de facturi: '||v_max_count||'.');

    FOR factura IN c_pret_facturi(v_client)
    LOOP
        dbms_output.PUT_LINE('Factura '||factura.id_factura||' => '||factura.total||' lei');
    END LOOP;
END;
/
