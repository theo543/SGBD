

INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (1, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, NULL, 'MANAGER', 'Olariu Adrian', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 5973);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (1, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'MANAGER', 'Murariu Corina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 6314);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (2, 0);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'CASIER', 'Iorga Irina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2331);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (3, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'CASIER', 'Paduraru Alina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2197);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (4, 2);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'BUCATAR', 'Nechifor Valentin', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 5050.0);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (5, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (2, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (2, NULL, 'MANAGER', 'Lungu Ionut', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 6741);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (6, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (2, 6, 'MANAGER', 'Solomon Ovidiu', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 5800);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (7, 0);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (2, 6, 'CASIER', 'Groza Anamaria', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2143);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (8, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (2, 6, 'BUCATAR', 'Vaduva Radu', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4478);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (9, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (3, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (3, NULL, 'MANAGER', 'Tomescu Alexandru', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 6305);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (10, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (3, 10, 'CASIER', 'Robu Andreea Elena', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2266);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (11, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (3, 10, 'BUCATAR', 'Trandafir Ioan', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4505);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (12, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (4, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (4, NULL, 'MANAGER', 'Kovacs Florina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 6369);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (13, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (4, 13, 'CASIER', 'Costea Viorel', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 1900.0);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (14, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (4, 13, 'BUCATAR', 'Iordache Anamaria', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4285);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (15, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (5, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (5, NULL, 'MANAGER', 'Ciocan Iulia', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 7125.0);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (16, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (5, 16, 'CASIER', 'Tomescu Iulian', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2236);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (17, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (5, 16, 'CASIER', 'Vieru Iulia', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2132);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (18, 2);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (5, 16, 'BUCATAR', 'Dobre Claudiu', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4937);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (19, NULL);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (1, 2, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (1, 3, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (1, 'Str. Ilie nr. 79', 17);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (2, 1, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (2, 'Str. Dumitrescu nr. 5 bl. 45', 18);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (3, 4, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (3, 3, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (3, 5, 3);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (3, 'Str. Duma nr. 54', 17);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (4, 3, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (4, 1, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (4, 'Str. Alexa nr. 76', 13);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (5, 1, 2);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (6, 2, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (6, 'Str. Trandafir nr. 55 bl. 7', 12);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (7, 5, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (7, 'Str. Marin nr. 16 bl. 39', 19);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (8, 4, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (9, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (9, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (9, 3, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (9, 4, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (10, 1, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (10, 'Str. Vasiliu nr. 55 bl. 17', 11);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (2, 8);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (11, 3, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (2, 8);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (12, 1, 2);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (2, 8);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (13, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (2, 8);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (14, 3, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (15, 2, 3);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (15, 'Str. Rotaru nr. 21', 18);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (16, 1, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (16, 4, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (16, 'Str. Solomon nr. 88', 19);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (17, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (17, 3, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (17, 4, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (17, 2, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (17, 'Str. Sandor nr. 89 bl. 30', 11);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (18, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (18, 3, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (19, 5, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (19, 3, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (19, 'Str. Burlacu nr. 50', 20);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (20, 1, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (20, 'Str. Militaru nr. 21 bl. 15', 20);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (21, 4, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (21, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (22, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (22, 2, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (22, 4, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (22, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (23, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (23, 1, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (24, 4, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (24, 1, 3);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 14);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (25, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (25, 2, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 14);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (26, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (26, 2, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (26, 'Str. Carp nr. 79 bl. 13', 11);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 14);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (27, 2, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (27, 3, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (27, 'Str. Ivan nr. 61', 20);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 14);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (28, 1, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 17);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (29, 3, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (29, 2, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (29, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (29, 4, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (29, 'Str. Oprea nr. 6 bl. 44', 14);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 17);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (30, 3, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (30, 5, 3);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (30, 'Str. Ifrim nr. 84', 20);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (31, 4, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (31, 3, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (31, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (32, 2, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (33, 3, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (33, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (34, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (34, 1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (34, 4, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (34, 2, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (35, 5, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (35, 2, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (36, 2, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (36, 1, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (36, 5, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (36, 'Str. Ciocan nr. 52', 14);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (37, 1, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (37, 5, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 18);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (38, 3, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES (38, 1, 1);
SELECT COUNT(*) FROM ORAS;
SELECT COUNT(*) FROM RESTAURANT;
SELECT COUNT(*) FROM JOB;
SELECT COUNT(*) FROM ANGAJAT;
SELECT COUNT(*) FROM CASIER;
SELECT COUNT(*) FROM BUCATAR;
SELECT COUNT(*) FROM MANAGER;
SELECT COUNT(*) FROM INGREDIENT;
SELECT COUNT(*) FROM RETETA;
SELECT COUNT(*) FROM ALERGIE;
SELECT COUNT(*) FROM COMANDA;
SELECT COUNT(*) FROM LIVRARE;
SELECT COUNT(*) FROM INGREDIENT_provoaca_ALERGIE;
SELECT COUNT(*) FROM RETETA_contine_INGREDIENT;
SELECT COUNT(*) FROM COMANDA_include_RETETA;
