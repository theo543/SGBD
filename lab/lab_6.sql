-- Cu doi vectori de %TYPE

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_ids IS VARRAY(10) OF employees.employee_id%TYPE;
    TYPE t_salaries IS VARRAY(10) OF employees.salary%TYPE;
    v_ids t_ids;
    v_salaries t_salaries;
    v_index BINARY_INTEGER;
    TOO_MANY_VARRAY_VALUES EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOO_MANY_VARRAY_VALUES, -22165); -- varray overflow error code
BEGIN
    WITH ordered_salaries AS (
        SELECT employee_id, salary
        FROM EMPLOYEES
        WHERE ((commission_pct = 0) OR  (commission_pct IS NULL))
        ORDER BY salary
    )
    SELECT employee_id, salary
    BULK COLLECT INTO v_ids, v_salaries
    FROM ordered_salaries
    WHERE ROWNUM <= 10;

    DBMS_OUTPUT.PUT_LINE('Worst paid:');
    FOR v_index IN v_ids.FIRST..v_ids.LAST
    LOOP
        DBMS_OUTPUT.PUT('ID '||v_ids(v_index)||' - '||v_salaries(v_index)||'$');
        v_salaries(v_index) := v_salaries(v_index) * 1.05;
        DBMS_OUTPUT.PUT_LINE(' - will update to '||v_salaries(v_index)||'$');
    END LOOP;

    FORALL v_index IN v_ids.FIRST..v_ids.LAST
    UPDATE employees
    SET salary = v_salaries(v_index)
    WHERE employee_id = v_ids(v_index);

    ROLLBACK;
EXCEPTION
    WHEN TOO_MANY_VARRAY_VALUES THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: '||SQLERRM||' - trebuie crescuta dimensiunea maxima a vectorului!');
END;
/

-- E2. Definiți un tip colecție denumit tip_orase_***. Creați tabelul excursie_*** cu următoarea structură:
-- cod_excursie NUMBER(4), denumire VARCHAR2(20), orase tip_orase_*** (ce va conține lista
-- orașelor care se vizitează într-o excursie, într-o ordine stabilită; de exemplu, primul oraș din listă va fi
-- primul oraș vizitat), status (disponibilă sau anulată).
-- a. Inserați 5 înregistrări în tabel.
-- b. Actualizați coloana orase pentru o excursie specificată:
--    - adăugați un oraș nou în listă, ce va fi ultimul vizitat în excursia respectivă;
--    - adăugați un oraș nou în listă, ce va fi al doilea oraș vizitat în excursia respectivă;
--    - inversați ordinea de vizitare a două dintre orașe al căror nume este specificat;
--    - eliminați din listă un oraș al cărui nume este specificat.
-- c. Pentru o excursie al cărui cod este dat, afișați numărul de orașe vizitate, respectiv numele orașelor.
-- d. Pentru fiecare excursie afișați lista orașelor vizitate.
-- e. Anulați excursiile cu cele mai puține orașe vizitate.

-- a

CREATE TYPE lista_orase IS TABLE OF VARCHAR2(20);
CREATE TABLE excursie (
    cod_excursie NUMBER(4) PRIMARY KEY,
    denumire VARCHAR2(20),
    orase lista_orase,
    status VARCHAR(20) DEFAULT 'disponibila'
)
NESTED TABLE orase STORE AS NESTED_excursie_lista_orase;

INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (1, 'Excursie 1', lista_orase('Bucuresti', 'Timisoara'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (2, 'Excursie 2', lista_orase('Craiova', 'Timisoara'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (3, 'Excursie 3', lista_orase('Craiova', 'Cluj'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (4, 'Excursie 4', lista_orase('Bucuresti', 'Cluj'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (5, 'Excursie 5', lista_orase('Craiova', 'Bucuresti', 'Cluj'));

-- b

DECLARE
    SUBTYPE cod_excursie IS excursie.cod_excursie%TYPE;
    SUBTYPE oras IS VARCHAR2(20);
    v_excursie_de_modificat cod_excursie := &p_excursive_de_modificat;
    v_oras_add_la_sfarsit oras := &p_oras_add_la_sfarsit;
    v_oras_add_pozitie_2 oras := &p_oras_add_pozitie_2;
    v_oras_swap_1 oras := &p_oras_swap_1;
    v_oras_swap_2 oras := &p_oras_swap_2;
    v_oras_delete oras := &p_oras_delete;
    v_lista_orase lista_orase;
    v_lista_orase_crescuta lista_orase := lista_orase();
    v_oras oras;
BEGIN
    SELECT orase
    INTO v_lista_orase
    FROM excursie
    WHERE cod_excursie = v_excursie_de_modificat
    FOR UPDATE OF orase;

    DBMS_OUTPUT.PUT('Updating: {');
    FOR i IN 1..v_lista_orase.LAST
    LOOP
        DBMS_OUTPUT.PUT(' '||v_lista_orase(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' }');

    v_lista_orase.EXTEND;
    v_lista_orase(v_lista_orase.LAST) := v_oras_add_la_sfarsit;

    v_lista_orase_crescuta.EXTEND(v_lista_orase.COUNT + 1);
    v_lista_orase_crescuta(1) := v_lista_orase(1);
    v_lista_orase_crescuta(2) := v_oras_add_pozitie_2;
    FOR i IN 2..v_lista_orase.LAST
    LOOP
        -- DataGrip a insistat sa folosesc DECODE, nu CASE
        v_lista_orase_crescuta(i + 1) := v_lista_orase(i);
    END LOOP;

    v_lista_orase.DELETE;
    FOR i IN 1..v_lista_orase_crescuta.LAST
    LOOP
        CONTINUE WHEN v_lista_orase_crescuta(i) = v_oras_delete;

        v_oras := CASE v_lista_orase_crescuta(i)
            WHEN v_oras_swap_1 THEN v_oras_swap_2
            WHEN v_oras_swap_2 THEN v_oras_swap_1
            ELSE v_lista_orase_crescuta(i)
        END;

        v_lista_orase.EXTEND;
        v_lista_orase(v_lista_orase.LAST) := v_oras;
    END LOOP;

    UPDATE excursie
    SET orase = v_lista_orase
    WHERE cod_excursie = v_excursie_de_modificat;

    DBMS_OUTPUT.PUT('Updated: {');
    FOR i IN 1..v_lista_orase.LAST
    LOOP
        DBMS_OUTPUT.PUT(' '||v_lista_orase(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' }');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cod excursie '||v_excursie_de_modificat||' nu exista');
END;
/

DROP TABLE excursie;
DROP TYPE lista_orase;
