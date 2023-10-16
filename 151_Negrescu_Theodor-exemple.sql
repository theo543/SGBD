-- 12. Formulati in limbaj natural si implementati 5 cereri SQL complexe ce vor
-- utiliza, in ansamblul lor, urmatoarele elemente:

-- • subcereri sincronizate in care intervin cel putin 3 tabele

-- • subcereri nesincronizate in clauza FROM

-- • grupari de date cu subcereri nesincronizate in care intervin cel putin 3
-- tabele, functii grup, filtrare la nivel de grupuri (in cadrul aceleiasi cereri)

-- • ordonari si utilizarea functiilor NVL si DECODE (in cadrul aceleiasi
-- cereri)

-- • utilizarea a cel putin 2 functii pe siruri de caractere, 2 functii pe date
-- calendaristice, a cel putin unei expresii CASE

-- • utilizarea a cel putin 1 bloc de cerere (clauza WITH)


-- sa se afiseze restaurantele in care nu exista inca niciun casier asociat unei case de marcat

SELECT id_restaurant FROM RESTAURANT r -- subcerere sincronizata cu tabelul r, tabelul c2, tabelul a2
WHERE (
    SELECT COUNT(c2.id_angajat) FROM CASIER c2
    JOIN ANGAJAT a2 ON (c2.id_angajat = a2.id_angajat)
    WHERE a2.id_restaurant = r.id_restaurant AND nr_casa_de_marcat IS NOT NULL
) = 0;

-- sa se afiseze venitul total pentru fiecare restaurant din orasul cu ID 1

WITH total_cost_meniu AS (
    SELECT id_meniu, SUM(pret) * procent_pret / 100 pret FROM MENIU_contine_RETETA
    JOIN MENIU USING (id_meniu)
    JOIN RETETA USING (id_reteta)
    GROUP BY id_meniu, procent_pret
),
total_cost_meniuri_comanda AS (
    SELECT id_comanda, SUM(pret) pret FROM COMANDA_include_MENIU
    JOIN total_cost_meniu USING (id_meniu)
    GROUP BY id_comanda
), total_cost_retete_comanda AS (
    SELECT id_comanda, SUM(pret) pret FROM COMANDA_include_RETETA
    JOIN RETETA USING (id_reteta)
    GROUP BY id_comanda
)
SELECT id_restaurant, SUM(NVL(mc.pret, 0) + DECODE(rc.pret, NULL, 0, rc.pret)) "Total Vanzari" -- nvl si decode
FROM restaurant
JOIN COMANDA USING (id_restaurant)
LEFT JOIN total_cost_meniuri_comanda mc USING (id_comanda) -- subcereri nesincronizate in grupare (prin clauza WITH), intervin COMANDA, RETETA, MENIU
LEFT JOIN total_cost_retete_comanda rc USING (id_comanda)
GROUP BY id_restaurant, id_oras
HAVING id_oras = 1; -- filtrare la nivel de grupuri



-- pentru fiecare angajat din Bucuresti, sa se afiseze urmatorul raport: "{nume} castiga {salariu}"

SELECT CONCAT(CONCAT(a.nume, ' castiga '), TO_CHAR(j.salariu)) "Raport" FROM (SELECT a.nume, id_restaurant, job_cod FROM ANGAJAT a -- subcerere nesincronizata in clauza FROM
    JOIN RESTAURANT USING (id_restaurant)
    JOIN ORAS o USING (id_oras)
    WHERE LOWER(o.nume) = 'bucuresti'
) a
JOIN JOB_are_SALARIU j USING (job_cod);


-- pentru fiecare restaurant afiseaza cate luni au trecut de la deschidere

SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, data_deschidere)) "Luni de la deschidere" FROM RESTAURANT; -- MONTHS_BETWEEN, SYSDATE

-- pentru fiecare restaurant afiseaza nr. de angajati care nu sunt complet antrenati, definit astefel: casieri fara casa de marcat, bucatari fara antrenament de siguranta sau manageri neautorizati sa angajeze

SELECT id_restaurant, SUM(CASE
    WHEN job_cod = 'MANAGER' THEN (SELECT CASE WHEN autorizat_sa_angajeze = 1 THEN 0 ELSE 1 END FROM MANAGER m WHERE m.id_angajat = a.id_angajat)
    WHEN job_cod = 'CASIER' THEN (SELECT CASE WHEN nr_casa_de_marcat IS NULL THEN 0 ELSE 1 END FROM CASIER c WHERE a.id_angajat = c.id_angajat)
    WHEN job_cod = 'BUCATAR' THEN (SELECT CASE WHEN data_antrenament_de_siguranta IS NULL THEN 0 ELSE 1 END FROM BUCATAR b WHERE b.id_angajat = a.id_angajat)
    END) "Angajati cu antrenare incompleta"
FROM RESTAURANT r
JOIN ANGAJAT a USING (id_restaurant)
GROUP BY id_restaurant;


-- 3 actualizare si suprimare

-- toti casierii din Bucuresti fara casa de marcat vor fi transferati la restaurantul cu ID 7 pentru a fi instruiti

UPDATE ANGAJAT a
SET id_restaurant = 7 WHERE id_angajat IN (
    SELECT id_angajat FROM CASIER c
    JOIN ANGAJAT USING (id_angajat)
    JOIN RESTAURANT r USING (id_restaurant)
    JOIN ORAS o USING (id_oras)
    WHERE LOWER(o.nume) = 'bucuresti'
    AND c.nr_casa_de_marcat IS NULL
);

-- toti managerii din Timisoara vor pierde autorizatia de angajare din cauza suspiciunilor de coruptie in zona

UPDATE MANAGER m
SET autorizat_sa_angajeze = 0 WHERE id_angajat IN (
    SELECT id_angajat FROM ANGAJAT a
    JOIN RESTAURANT r USING (id_restaurant)
    JOIN ORAS o USING (id_oras)
    WHERE LOWER(o.nume) = 'timisoara'
);

-- toti bucatarii fara antrenament de siguranta vor fi concediati

DELETE FROM ANGAJAT
WHERE id_angajat IN (
    SELECT id_angajat FROM BUCATAR
    WHERE data_antrenament_de_siguranta IS NULL
);

ROLLBACK;


-- Formulati in limbaj natural si implementati in SQL: o cerere ce utilizeaza
-- operatia outer-join pe minimum 4 tabele, o cerere ce utilizeaz� operatia
-- division si o cerere care implementeaz� analiza top-n.

-- sa se afle fara subcereri pentru fiecare angajat daca este fara antrenament terminat (la fel ca la cererea 12)

SELECT CASE WHEN (nr_casa_de_marcat IS NOT NULL) OR (data_antrenament_de_siguranta IS NOT NULL) OR (autorizat_sa_angajeze = 1) THEN 'DA' ELSE 'NU' END
FROM ANGAJAT
FULL OUTER JOIN CASIER sc USING (id_angajat)
FULL OUTER JOIN BUCATAR sb USING (id_angajat)
FULL OUTER JOIN MANAGER sm USING (id_angajat);

-- pentru fiecare restaurant sa se afle in ce luni acel restaurant a achizitionat fiecare ingredient necesar pentru a face meniul 1, ordonat dupa luna si id

WITH necesare AS (
    SELECT DISTINCT id_ingredient FROM MENIU_contine_RETETA
    JOIN RETETA_contine_INGREDIENT USING (id_reteta)
    WHERE id_meniu = 1
)
SELECT luna, id_restaurant FROM (SELECT TRUNC(data_comanda, 'MONTH') luna, id_restaurant, id_ingredient FROM restaurant_cumpara_ingredient_de_la_furnizor)
WHERE id_ingredient IN (SELECT id_ingredient FROM necesare)
GROUP BY luna, id_restaurant
HAVING COUNT(id_ingredient) = (SELECT COUNT(id_ingredient) FROM necesare)
ORDER BY luna, id_restaurant;

-- sa se afle primele 10 restaurantele ordonate dupa cost total al ingredientelor

WITH costuri AS (
    SELECT id_restaurant, SUM(pret) cost FROM restaurant_cumpara_ingredient_de_la_furnizor
    JOIN furnizor_ofera_ingredient USING (id_furnizor, id_ingredient)
    GROUP BY id_restaurant
    ORDER BY cost DESC
)
SELECT id_restaurant, cost FROM costuri
WHERE ROWNUM <= 10;
