-- Ex. 9 adaptat pentru schema de lanț de pizze.
-- Definiți tipul subordonati (vector, dimensiune maximă 10, menține numere).
-- Creați tabelul manageri cu următoarele câmpuri: cod_mgr NUMBER(10), nume VARCHAR2(20), subordonati.
-- Completați tabelul cu managerii din tabelul ANGAJAT. Afișați informațiile din tabel.
-- Ștergeți tabelul creat, apoi tipul.
-- Dacă un manager are peste 10 subordonati, se va raporta eroarea.
-- Notă: Tabelul manageri este o denormalizare a relației de tip many-to-one din tabelul ANGAJAT.

SET SERVEROUT ON;

CREATE TYPE subordonati IS VARRAY(10) OF NUMBER(10);
/

CREATE TABLE manageri (
    cod_mgr NUMBER(10) PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL, -- marimea numelui in ANGAJAT este 50
    subordonati subordonati,
    FOREIGN KEY (cod_mgr) REFERENCES MANAGER(id_angajat)
);

DECLARE
    TYPE ang_data IS RECORD(id MANAGER.id_angajat%TYPE, nume ANGAJAT.nume%TYPE);
    TYPE ang_tab IS TABLE OF ang_data;

    v_ang ang_tab;
    v_index BINARY_INTEGER;
    v_ang_id ANGAJAT.id_angajat%TYPE;
    v_subord subordonati;

    TOO_MANY_VARRAY_VALUES EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOO_MANY_VARRAY_VALUES, -22165); -- varray overflow error code
BEGIN
    -- insereaza suficiente date pentru a cauza o exceptie, pentru a testa daca e prinsa corect
    FOR v_index IN 1..100
    LOOP
        INSERT INTO ANGAJAT (ID_RESTAURANT, ID_ANGAJATOR, JOB_COD, NUME, DATA_ANGAJARE) VALUES (1, 13, 'CASIER', 'test peste 10 subordonati - '||v_index, SYSDATE)
        RETURNING ID_ANGAJAT INTO v_ang_id;
        INSERT INTO CASIER (ID_ANGAJAT) VALUES (v_ang_id);
    END LOOP;

    SELECT ID_ANGAJAT, NUME
    BULK COLLECT INTO v_ang
    FROM ANGAJAT
    JOIN MANAGER
    USING (ID_ANGAJAT);

    FOR v_index IN v_ang.FIRST..v_ang.LAST
    LOOP
        BEGIN
            SELECT ID_ANGAJAT
            BULK COLLECT INTO v_subord
            FROM ANGAJAT
            WHERE ID_ANGAJATOR = v_ang(v_index).id;
        EXCEPTION
            WHEN TOO_MANY_VARRAY_VALUES THEN
                DBMS_OUTPUT.PUT_LINE('Nu se poate stoca managerul '||v_ang(v_index).id||' fiindca are prea multi subordonati.');
                CONTINUE;
        END;

        DBMS_OUTPUT.PUT('Inserare manager '||v_ang(v_index).id||': { ');
        DECLARE
            v_index_varray BINARY_INTEGER;
        BEGIN
            FOR v_index_varray IN 1..v_subord.COUNT
            LOOP
                DBMS_OUTPUT.PUT(v_subord(v_index_varray)||' ');
            END LOOP;
        END;
        DBMS_OUTPUT.PUT_LINE('}');

        INSERT INTO manageri (cod_mgr, nume, subordonati) VALUES (v_ang(v_index).id, v_ang(v_index).nume, v_subord);
    END LOOP;
END;
/

SELECT * FROM manageri;

ROLLBACK;

DROP TABLE manageri;
DROP TYPE subordonati;
