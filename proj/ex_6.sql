/*
Gradul de risc al unei comenzi e determinat de numarul de ingrediente ce provoaca alergie.
Formula pentru risc este non-liniară, deoarece pentru o persoană cu alergii nu e mare diferență
dacă sunt 4 sau 5 pachete de roșii în pizza, vor avea reacție alergică oricum, iar dacă
sunt 20 de pachete de roșii atunci sigur nu e pentru o singură persoană mâncarea oricum.
Regula este:
- prima incluziune a unui ingredient periculos are 100 puncte de rist,
- următoarele 2 incluziuni au 50 de puncte de risc
- mai departe, fiecare incluziune are cu 60% mai puțin risc (rotunjit) decât cea anterioară
Să se afișeze top 3 cele mai riscante comenzi făcute la fiecare restaurant.
*/

CREATE OR REPLACE PROCEDURE afiseaza_top_3_comenzi_riscante
IS
    TYPE comanda_riscanta IS RECORD(id_comanda comanda.id_comanda%TYPE, risc BINARY_INTEGER, ingrediente BINARY_INTEGER);
    TYPE top3_comenzi IS VARRAY(3) OF comanda_riscanta;
    TYPE top3_restaurant IS RECORD(id_restaurant restaurant.id_restaurant%TYPE, comenzi top3_comenzi);
    TYPE lista_top3 IS TABLE OF top3_restaurant;
    TYPE risc_anterior IS RECORD(numar BINARY_INTEGER, ultimul_scor BINARY_INTEGER);
    TYPE ingrediente_vazute IS TABLE OF risc_anterior INDEX BY BINARY_INTEGER;
    TYPE ingrediente_in_comanda IS TABLE OF ingredient.id_ingredient%TYPE;
    lista_finala lista_top3 := lista_top3();
BEGIN
    FOR id_restaurant_row IN (
        SELECT id_restaurant
        FROM restaurant
    )
    LOOP
        DECLARE
            blank comanda_riscanta := comanda_riscanta(-1, -1);
            clasament top3_comenzi := top3_comenzi(blank, blank, blank);
        BEGIN
            FOR id_comanda_row IN (
                SELECT id_comanda
                FROM comanda
                WHERE id_restaurant = id_restaurant_row.id_restaurant
            )
            LOOP
                DECLARE
                    ingrediente ingrediente_in_comanda;
                    vazute ingrediente_vazute;
                    risc_comanda BINARY_INTEGER := 0;
                    PROCEDURE insert_record(i NUMBER)
                    IS
                    BEGIN
                        clasament(i) := comanda_riscanta(id_comanda_row.id_comanda, risc_comanda, ingrediente.count);
                    END;
                BEGIN
                    WITH ingr AS (
                        SELECT id_ingredient, nr
                        FROM comanda
                        JOIN comanda_include_reteta
                        USING (id_comanda)
                        JOIN reteta_contine_ingredient
                        USING (id_reteta)
                        WHERE id_comanda = id_comanda_row.id_comanda
                    ),
                    numbers AS (
                        SELECT LEVEL AS lvl
                        FROM DUAL
                        CONNECT BY LEVEL <= (SELECT MAX(nr) FROM ingr)
                    )
                    SELECT id_ingredient
                    BULK COLLECT INTO ingrediente
                    FROM ingr
                    JOIN numbers
                    ON (nr <= lvl);

                    FOR i IN 1..ingrediente.LAST
                    LOOP
                        DECLARE
                            igr ingredient.id_ingredient%TYPE := ingrediente(i);
                        BEGIN
                            IF NOT vazute.exists(ingrediente(i))
                            THEN
                                vazute(igr) := risc_anterior(0, 0);
                            END IF;
                            CASE vazute(igr).numar
                                WHEN 0 THEN
                                    vazute(igr) := risc_anterior(1, 100);
                                WHEN 1 THEN
                                    vazute(igr) := risc_anterior(2, 50);
                                WHEN 2 THEN
                                    vazute(igr) := risc_anterior(3, 50);
                                ELSE
                                    vazute(igr) := risc_anterior(vazute(igr).numar + 1, vazute(igr).ultimul_scor * 0.6);
                            END CASE;
                            risc_comanda := risc_comanda + vazute(igr).ultimul_scor;
                        END;
                    END LOOP;

                    IF risc_comanda > clasament(1).risc THEN
                        clasament(3) := clasament(2);
                        clasament(2) := clasament(1);
                        insert_record(1);
                    ELSIF risc_comanda > clasament(2).risc THEN
                        clasament(3) := clasament(2);
                        clasament(2) := comanda_riscanta(id_comanda_row.id_comanda, risc_comanda);
                        insert_record(2);
                    ELSIF risc_comanda > clasament(3).risc THEN
                        insert_record(3);
                    END IF;
                END;
            END LOOP;
            lista_finala.extend(1);
            lista_finala(lista_finala.last) := top3_restaurant(id_restaurant_row.id_restaurant, clasament);
        END;
    END LOOP;

    FOR i IN 1..lista_finala.LAST
    LOOP
        DECLARE
            top3 top3_comenzi := lista_finala(i).comenzi;
            id_rest restaurant.id_restaurant%TYPE := lista_finala(i).id_restaurant;
            FUNCTION str(comanda comanda_riscanta) RETURN VARCHAR2
            IS
            BEGIN
                RETURN '[Comanda '||comanda.id_comanda||', risc '||comanda.risc||', nr. ingrediente '||comanda.ingrediente||']';
            END;
        BEGIN
            dbms_output.PUT_LINE(
                    'Restaurantul '||id_rest||': '||
                    str(top3(1))||', '||
                    str(top3(2))||', '||
                    str(top3(3))||'.'
            );
        END;
    END LOOP;
END afiseaza_top_3_comenzi_riscante;
/

BEGIN
    afiseaza_top_3_comenzi_riscante();
END;
/

DROP PROCEDURE afiseaza_top_3_comenzi_riscante;
