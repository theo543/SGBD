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

CREATE TYPE lista_orase IS TABLE OF VARCHAR2(20);
CREATE TABLE excursie (
    cod_excursie NUMBER(4) PRIMARY KEY,
    denumire VARCHAR2(20),
    orase lista_orase
)
NESTED TABLE orase STORE AS NESTED_excursie_lista_orase;

INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (1, 'Excursie 1', lista_orase('Bucuresti', 'Timisoara'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (2, 'Excursie 2', lista_orase('Craiova', 'Timisoara'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (3, 'Excursie 3', lista_orase('Craiova', 'Cluj'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (4, 'Excursie 4', lista_orase('Bucuresti', 'Cluj'));
INSERT INTO excursie (cod_excursie, denumire, orase) VALUES (5, 'Excursie 5', lista_orase('Craiova', 'Bucuresti', 'Cluj'));

DROP TABLE excursie;
DROP TYPE lista_orase;
