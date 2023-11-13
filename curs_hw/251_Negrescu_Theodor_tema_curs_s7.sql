-- 2. Definiți un bloc PL/SQL în care procedura proc_ex2 (Exemplul 6.2 din SGBD6 - PLSQL Subprograme.pdf)
-- este apelată pentru fiecare produs din categoria 'it' (nivel 1).
-- Prețul acestor produse va fi micșorat cu 5%.

CREATE PROCEDURE proc_ex1 (v_id produse.id_produs%TYPE, v_procent NUMBER)
AS
BEGIN
    UPDATE produse
    SET pret_unitar = pret_unitar + pret_unitar * v_procent
    WHERE id_produs = v_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR (-20000,'Nu exista produsul');
END;

BEGIN
    FOR produs IN (
        SELECT id_produs
        FROM PRODUSE
        WHERE id_categorie = 1
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Scădere preț - produs '||produs.id_produs);
        proc_ex1(produs.id_produs, -0.05);
    END LOOP;
END;

ROLLBACK;

DROP PROCEDURE proc_ex1;
