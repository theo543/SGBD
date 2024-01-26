CREATE FUNCTION gen_cursor RETURN SYS_REFCURSOR
IS
    ret SYS_REFCURSOR;
BEGIN
    OPEN ret FOR
        'SELECT id_restaurant, nume FROM restaurant JOIN oras USING (id_oras)';
    RETURN ret;
END;
/

DECLARE
    v_cursor SYS_REFCURSOR := gen_cursor();
    v_id_rest BINARY_INTEGER;
    v_nume_oras oras.nume%TYPE;
BEGIN
    LOOP
        FETCH v_cursor INTO v_id_rest, v_nume_oras;
        EXIT WHEN v_cursor%NOTFOUND;
        dbms_output.PUT_LINE(v_id_rest|| ' se afla in orasul: '||v_nume_oras);
    END LOOP;
    CLOSE v_cursor;
END;
