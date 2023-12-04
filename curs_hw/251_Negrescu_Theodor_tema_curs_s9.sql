CREATE OR REPLACE PACKAGE hw_s9 AS
    SUBTYPE id_client_t IS clienti.id_client%TYPE;
    SUBTYPE id_factura_t IS facturi.id_factura%TYPE;
    SUBTYPE id_casa_t IS NUMBER(38); -- tabelul se numeste 'case'...
    SUBTYPE id_categorie_t IS categorii.id_categorie%TYPE;

    TYPE lista_facturi IS TABLE OF id_factura_t;
    -- Activitatea unui client la o anumită casă - facturile achitate și neachitate, si sumele.
    TYPE activitate_client IS RECORD (id_client id_client_t,suma_achitate NUMBER(10),suma_neachitate NUMBER(10),achitate lista_facturi,neachitate lista_facturi);
    -- Lista activităților tuturor clienților la o casă.
    TYPE lista_activitate IS TABLE OF activitate_client;
    TYPE lista_activitate_case IS TABLE OF lista_activitate INDEX BY BINARY_INTEGER;
    FUNCTION get_activitate_case RETURN lista_activitate_case;

    TYPE nr_facturi_client IS RECORD (id_client id_client_t, facturi BINARY_INTEGER);
    CURSOR c_nr_facturi RETURN nr_facturi_client;
    TYPE total_factura IS RECORD (id_factura id_factura_t, total BINARY_INTEGER);
    CURSOR c_pret_facturi(v_id_client id_client_t) RETURN total_factura;
    PROCEDURE print_achizitii_client_facturi_max;

    input_invalid_pt_sql_dinamic EXCEPTION;
    PRAGMA EXCEPTION_INIT (input_invalid_pt_sql_dinamic, -20000);
    /* 1 = salariu, 2 = job, 3 = proiecte */
    /* 1 = ASC, 2 = DESC */
    PROCEDURE print_employees_dynamic_sorting(v_alegere NUMBER, v_directie NUMBER);

    produs_nu_exista EXCEPTION;
    PRAGMA EXCEPTION_INIT (produs_nu_exista, -20001);
    PROCEDURE proc_ex1 (v_id produse.id_produs%TYPE, v_procent NUMBER);
    PROCEDURE forall_in_category_proc_ex1(id_categorie_ales id_categorie_t);
END hw_s9;

CREATE OR REPLACE PACKAGE BODY hw_s9 AS
    CURSOR c_nr_facturi RETURN nr_facturi_client
    IS
        SELECT id_client, COUNT(*) facturi
        FROM facturi
        GROUP BY id_client;

    CURSOR c_pret_facturi(v_id_client id_client_t) RETURN total_factura
    IS
        SELECT id_factura, SUM(pret_facturare) total
        FROM facturi
        JOIN facturi_contin_produse
        USING (id_factura)
        WHERE id_client = v_id_client
        GROUP BY id_factura;

    FUNCTION get_activitate_case
    RETURN lista_activitate_case
    IS
        TYPE info_factura IS RECORD ( id_factura id_factura_t,
                                      id_casa id_casa_t,
                                      id_client id_client_t,
                                      status FACTURI.status%TYPE,
                                      suma_facturare FACTURI_CONTIN_PRODUSE.pret_facturare%TYPE);
        v_factura info_factura;
        v_casa_curenta id_casa_t := -1;
        v_activitate activitate_client := activitate_client();
        v_retval lista_activitate_case;
        PROCEDURE init_activitate(casa IN id_casa_t, client IN id_client_t) IS
        BEGIN
            v_casa_curenta := casa;
            v_activitate := activitate_client(client, 0, 0, lista_facturi(), lista_facturi());
        END;
        PROCEDURE save_activitate IS
        BEGIN
            IF v_casa_curenta = -1
            THEN
                RETURN;
            END IF;
            IF NOT v_retval.exists(v_casa_curenta)
            THEN
                v_retval(v_casa_curenta) := lista_activitate();
            END IF;
            v_retval(v_casa_curenta).extend(1);
            v_retval(v_casa_curenta)(v_retval(v_casa_curenta).last) := v_activitate;
            v_activitate := activitate_client();
            v_casa_curenta := -1;
        END;
    BEGIN
        FOR v_factura IN (SELECT id_factura, id_casa, id_client, status, SUM(pret_facturare) suma_facturare
                          FROM FACTURI
                          JOIN FACTURI_CONTIN_PRODUSE
                          USING (id_factura)
                          GROUP BY (id_factura, id_casa, id_client, status)
                          ORDER BY id_casa, id_client, id_factura)
        LOOP
            IF v_casa_curenta = -1 OR v_activitate.ID_CLIENT != v_factura.ID_CLIENT OR v_casa_curenta != v_factura.ID_CASA
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
        RETURN v_retval;
    END get_activitate_case;

    PROCEDURE print_achizitii_client_facturi_max
    IS
        v_client id_client_t := -1;
        v_max_count BINARY_INTEGER := 0;
        v_este_ambiguu BOOLEAN := false;

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
    END print_achizitii_client_facturi_max;

    PROCEDURE print_employees_dynamic_sorting(v_alegere NUMBER, v_directie NUMBER)
    IS
        v_cursor SYS_REFCURSOR;
        v_emp_id EMPLOYEES.employee_id%TYPE;
        v_emp_name VARCHAR2(100);
        v_emp_salary EMPLOYEES.salary%TYPE;
        v_emp_job EMPLOYEES.job_id%TYPE;
        v_nr_proiecte BINARY_INTEGER;
        v_order_by VARCHAR(20);
        v_order_asc_desc VARCHAR(5);
        input_invalid_pt_sql_dinamic EXCEPTION;
    BEGIN
        CASE v_alegere
            WHEN 1 THEN v_order_by := 'salary';
            WHEN 2 THEN v_order_by := 'job_id';
            WHEN 3 THEN v_order_by := 'nr_proiecte';
            ELSE raise_application_error(-20000, 'v_alegere invalid');
        END CASE;
        CASE v_directie
            WHEN 1 THEN v_order_asc_desc := 'ASC';
            WHEN 2 THEN v_order_asc_desc := 'DESC';
            ELSE raise_application_error(-20000, 'v_directie invalid');
        END CASE;
        OPEN v_cursor FOR
            'WITH project_counts AS (
                SELECT employee_id, COUNT(*) nr_proiecte FROM works_on
                GROUP BY employee_id
            )
            SELECT employee_id, first_name || '' '' || last_name emp_name, salary, job_id, nr_proiecte
            FROM employees
            JOIN project_counts
            USING (employee_id)
            ORDER BY ' || v_order_by || ' ' || v_order_asc_desc;
        LOOP
            FETCH v_cursor INTO v_emp_id, v_emp_name, v_emp_salary, v_emp_job, v_nr_proiecte;
            EXIT WHEN v_cursor%NOTFOUND;
            dbms_output.PUT_LINE(v_emp_id||': '||v_emp_salary||', cu salariu '||v_emp_salary||', cu job '||v_emp_job||', nr. proiecte la care lucreaza: '||v_nr_proiecte);
        END LOOP;
        CLOSE v_cursor;
    END print_employees_dynamic_sorting;

    PROCEDURE proc_ex1(v_id produse.id_produs%TYPE, v_procent NUMBER)
    IS
    BEGIN
        UPDATE produse
        SET pret_unitar = pret_unitar + pret_unitar * v_procent
        WHERE id_produs = v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20001,'Nu exista produsul');
    END;

    PROCEDURE forall_in_category_proc_ex1(id_categorie_ales id_categorie_t)
    IS
    BEGIN
        FOR produs IN (
            SELECT id_produs
            FROM PRODUSE
            WHERE id_categorie = id_categorie_ales
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('Scădere preț - produs '||produs.id_produs);
            proc_ex1(produs.id_produs, -0.05);
        END LOOP;
    END;

END hw_s9;

DECLARE
    v_activitati_case hw_s9.lista_activitate_case;
BEGIN
    v_activitati_case := hw_s9.get_activitate_case();
    FOR v_row IN (
        SELECT id_casa FROM case
    )
    LOOP
        IF NOT v_activitati_case.exists(v_row.id_casa)
        THEN
            dbms_output.PUT_LINE('Fara date pt. casa '||v_row.id_casa);
            CONTINUE;
        END IF;
        dbms_output.PUT_LINE('--- Casa '||v_row.id_casa||': ---');
        FOR i IN 1..v_activitati_case(v_row.id_casa).last
        LOOP
            DECLARE
                v_act hw_s9.activitate_client := v_activitati_case(v_row.id_casa)(i);
            BEGIN
                dbms_output.PUT_LINE('    Client '||v_act.id_client||': '||v_act.achitate.count||' achitate ('||v_act.suma_achitate||' lei'
                    ||'), '||v_act.neachitate.count||' neachitate ('||v_act.suma_neachitate||' lei)');
            END;
        END LOOP;
    END LOOP;
END;

BEGIN
    hw_s9.print_achizitii_client_facturi_max();
END;

BEGIN
    hw_s9.print_employees_dynamic_sorting(1, 1);
    hw_s9.print_employees_dynamic_sorting(1, 999);
END;

BEGIN
    FOR i IN 1..10
    LOOP
        hw_s9.forall_in_category_proc_ex1(i);
    END LOOP;
END;

ROLLBACK;
DROP PACKAGE hw_s9;
