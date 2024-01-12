------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------- create_proiect.sql ---------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
CREATE SEQUENCE ID_ORAS_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_RESTAURANT_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_ANGAJAT_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_INGREDIENT_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_RETETA_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_ALERGIE_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ID_COMANDA_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE ORAS (
  id_oras NUMBER(10) DEFAULT ID_ORAS_SEQ.nextval PRIMARY KEY,
  nume VARCHAR2(50) NOT NULL
);
CREATE TABLE RESTAURANT (
  id_restaurant NUMBER(10) DEFAULT ID_RESTAURANT_SEQ.nextval PRIMARY KEY,
  id_oras NUMBER(10) NOT NULL,
  data_deschidere DATE NOT NULL,
  FOREIGN KEY (id_oras) REFERENCES ORAS(id_oras)
);
CREATE TABLE JOB (
  job_cod VARCHAR2(10) PRIMARY KEY,
  salariu_baza NUMBER(10) NOT NULL,
  bonus_maxim NUMBER(10) NOT NULL
);
CREATE TABLE ANGAJAT (
  id_angajat NUMBER(10) DEFAULT ID_ANGAJAT_SEQ.nextval PRIMARY KEY,
  id_restaurant NUMBER(10) NOT NULL,
  id_angajator NUMBER(10),
  job_cod VARCHAR2(10) NOT NULL,
  nume VARCHAR2(50) NOT NULL,
  data_angajare DATE NOT NULL,
  salariu NUMBER(10) NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES RESTAURANT(id_restaurant),
  FOREIGN KEY (job_cod) REFERENCES JOB(job_cod)
);
CREATE TABLE CASIER (
  id_angajat NUMBER(10) PRIMARY KEY,
  nr_casa_de_marcat NUMBER(10),
  FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat) ON DELETE CASCADE
);
CREATE TABLE BUCATAR (
  id_angajat NUMBER(10) PRIMARY KEY,
  data_antrenament_de_siguranta DATE,
  FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat) ON DELETE CASCADE
);
CREATE TABLE MANAGER (
  id_angajat NUMBER(10) PRIMARY KEY,
  autorizat_sa_angajeze NUMBER(1) DEFAULT 0 NOT NULL CHECK (autorizat_sa_angajeze = 0 OR autorizat_sa_angajeze = 1),
  FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat) ON DELETE CASCADE
);
ALTER TABLE ANGAJAT ADD CONSTRAINT ANGAJATOR_E_MANAGER FOREIGN KEY (id_angajator) REFERENCES MANAGER(id_angajat);
CREATE TABLE INGREDIENT (
  id_ingredient NUMBER(10) DEFAULT ID_INGREDIENT_SEQ.nextval PRIMARY KEY,
  nume VARCHAR2(50) NOT NULL
);
CREATE TABLE RETETA (
  id_reteta NUMBER(10) DEFAULT ID_RETETA_SEQ.nextval PRIMARY KEY,
  nume VARCHAR2(50) NOT NULL,
  pret NUMBER(10,2) NOT NULL
);
CREATE TABLE ALERGIE (
  id_alergie NUMBER(10) DEFAULT ID_ALERGIE_SEQ.nextval PRIMARY KEY,
  nume VARCHAR2(50) NOT NULL
);
CREATE TABLE COMANDA (
  id_comanda NUMBER(10) DEFAULT ID_COMANDA_SEQ.nextval PRIMARY KEY,
  id_casier NUMBER(10) NOT NULL,
  id_restaurant NUMBER(10) NOT NULL,
  data_comanda DATE DEFAULT SYSDATE NOT NULL,
  FOREIGN KEY (id_casier) REFERENCES CASIER(id_angajat),
  FOREIGN KEY (id_restaurant) REFERENCES RESTAURANT(id_restaurant)
);
CREATE TABLE LIVRARE (
  id_comanda NUMBER(10) PRIMARY KEY,
  adresa VARCHAR(100) NOT NULL,
  pret NUMBER(10,2) NOT NULL,
  FOREIGN KEY (id_comanda) REFERENCES COMANDA(id_comanda) ON DELETE CASCADE
);

CREATE TABLE INGREDIENT_provoaca_ALERGIE (
  id_ingredient NUMBER(10) NOT NULL,
  id_alergie NUMBER(10) NOT NULL,
  PRIMARY KEY (id_ingredient, id_alergie),
  FOREIGN KEY (id_ingredient) REFERENCES INGREDIENT(id_ingredient),
  FOREIGN KEY (id_alergie) REFERENCES ALERGIE(id_alergie)
);
CREATE TABLE RETETA_contine_INGREDIENT (
  id_reteta NUMBER(10) NOT NULL,
  id_ingredient NUMBER(10) NOT NULL,
  PRIMARY KEY (id_reteta, id_ingredient),
  FOREIGN KEY (id_reteta) REFERENCES RETETA(id_reteta),
  FOREIGN KEY (id_ingredient) REFERENCES INGREDIENT(id_ingredient)
);
CREATE TABLE COMANDA_include_RETETA (
  id_comanda NUMBER(10) NOT NULL,
  id_reteta NUMBER(10) NOT NULL,
  nr NUMBER(10) NOT NULL CHECK (nr != 0),
  PRIMARY KEY (id_comanda, id_reteta)
);

INSERT INTO JOB
VALUES ('CASIER', 2000, 500);
INSERT INTO JOB
VALUES ('BUCATAR', 4000, 1000);
INSERT INTO JOB
VALUES ('MANAGER', 4500, 2500);

INSERT INTO ORAS (nume)
VALUES ('Bucuresti');
INSERT INTO ORAS (nume)
VALUES ('Cluj-Napoca');
INSERT INTO ORAS (nume)
VALUES ('Craiova');
INSERT INTO ORAS (nume)
VALUES ('Iasi');
INSERT INTO ORAS (nume)
VALUES ('Timisoara');

INSERT INTO INGREDIENT (nume) VALUES ('carne');
INSERT INTO INGREDIENT (nume) VALUES ('cartofi');
INSERT INTO INGREDIENT (nume) VALUES ('rosii');
INSERT INTO INGREDIENT (nume) VALUES ('faina');
INSERT INTO INGREDIENT (nume) VALUES ('drojdie');
INSERT INTO INGREDIENT (nume) VALUES ('sare');
INSERT INTO INGREDIENT (nume) VALUES ('aluat congelat de pizza');
INSERT INTO INGREDIENT (nume) VALUES ('ulei');

INSERT INTO ALERGIE (nume) VALUES ('gluten');
INSERT INTO ALERGIE (nume) VALUES ('rosii');
INSERT INTO ALERGIE (nume) VALUES ('drojdie');

INSERT INTO INGREDIENT_provoaca_ALERGIE (id_ingredient, id_alergie) VALUES (4, 1);
INSERT INTO INGREDIENT_provoaca_ALERGIE (id_ingredient, id_alergie) VALUES (7, 1);
INSERT INTO INGREDIENT_provoaca_ALERGIE (id_ingredient, id_alergie) VALUES (7, 3);
INSERT INTO INGREDIENT_provoaca_ALERGIE (id_ingredient, id_alergie) VALUES (3, 2);
INSERT INTO INGREDIENT_provoaca_ALERGIE (id_ingredient, id_alergie) VALUES (5, 3);

INSERT INTO RETETA (nume, pret) VALUES ('pizza', 20.99);
INSERT INTO RETETA (nume, pret) VALUES ('pizza rapida', 15.99);
INSERT INTO RETETA (nume, pret) VALUES ('cartofi prajiti', 10.99);
INSERT INTO RETETA (nume, pret) VALUES ('paine proaspata', 5.99);
INSERT INTO RETETA (nume, pret) VALUES ('cartofi prajiti cu sos', 12.99);

INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 1);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 3);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 4);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 5);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 6);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (1, 8);

INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (2, 1);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (2, 3);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (2, 7);

INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (3, 2);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (3, 8);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (3, 6);

INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (4, 4);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (4, 5);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (4, 6);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (4, 8);

INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (5, 3);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (5, 2);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (5, 8);
INSERT INTO RETETA_contine_INGREDIENT (id_reteta, id_ingredient) VALUES (5, 6);


-- Randomly generated data


INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (1, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, NULL, 'MANAGER', 'Olariu Adrian', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 5973);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (1, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'MANAGER', 'Murariu Corina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 6314);
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (2, 0);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'CASIER', 'Iorga Irina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2331);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (3, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'CASIER', 'Paduraru Alina', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2197);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (4, 2);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (1, 1, 'BUCATAR', 'Nechifor Valentin', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4434);
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
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (4, 13, 'CASIER', 'Costea Viorel', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2360);
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (14, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (4, 13, 'BUCATAR', 'Iordache Anamaria', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 4285);
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (15, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (5, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu) VALUES (5, NULL, 'MANAGER', 'Ciocan Iulia', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 5448);
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
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------ ex_6.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------ ex_7.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
Pentru fiecare manager, să se afișeze angajații angajați de el care nu sunt complet antrenați.
Se consideră incomplet antrenați:
casierii fără casă de marcat,
bucătarii care nu au primit încă noul antrenament de siguranță al companiei,
și managerii care nu sunt autorizați să angajeze.
*/

CREATE OR REPLACE PROCEDURE afiseaza_angajati_incomplet_antrenati
IS
    CURSOR manageri_cu_angajati
    IS
        WITH ids AS (
            SELECT id_angajat
            FROM casier
            WHERE nr_casa_de_marcat IS NULL
            UNION
            SELECT id_angajat
            FROM bucatar
            WHERE data_antrenament_de_siguranta IS NULL
            UNION
            SELECT id_angajat
            FROM manager
            WHERE autorizat_sa_angajeze = 0
        ),
        incomplet_antrenati AS (
            SELECT id_angajat, id_angajator, nume
            FROM ids
            JOIN angajat
            USING (id_angajat)
        )
        SELECT angajat.id_angajat, nume, CURSOR(
            SELECT id_angajat, nume FROM incomplet_antrenati
            WHERE id_angajator = manager.id_angajat
        ) AS angajati_incomplet_antrenati
        FROM angajat
        JOIN manager
        ON angajat.id_angajat = manager.id_angajat;
    TYPE refc IS REF CURSOR;
    ref refc;
    nume_manager angajat.nume%TYPE;
    id_manager angajat.id_angajat%TYPE;
    nume_angajat angajat.nume%TYPE;
    id_angajat angajat.id_angajat%TYPE;
BEGIN
    OPEN manageri_cu_angajati;
    LOOP
        FETCH manageri_cu_angajati INTO id_manager, nume_manager, ref;
        EXIT WHEN manageri_cu_angajati%NOTFOUND;
        dbms_output.PUT_LINE('Manager '||nume_manager||' (ID '||id_manager||') - Angajati care nu sunt complet antrenati:');
        FETCH ref INTO id_angajat, nume_angajat;
        IF ref%NOTFOUND
        THEN
            dbms_output.PUT_LINE('  Niciunul!');
            CONTINUE;
        END IF;
        LOOP
            dbms_output.PUT_LINE('  '||nume_angajat||' (ID '||id_angajat||')');
            FETCH ref INTO id_angajat, nume_angajat;
            EXIT WHEN ref%NOTFOUND;
        END LOOP;
        CLOSE ref;
    END LOOP;
    CLOSE manageri_cu_angajati;
END afiseaza_angajati_incomplet_antrenati;
/

BEGIN
    afiseaza_angajati_incomplet_antrenati();
END;
/

DROP PROCEDURE afiseaza_angajati_incomplet_antrenati;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------ ex_8.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
Să se afle care dintre casierii angajați de un manager au adus cel mai mult profit companiei.
Managerul se precizează prin nume.
Se vor raporta următoarele cazuri excepționale:
- numele nu există
- numele nu e unic (se vor preciza ID-urile angajaților găsiți)
- angajatul nu e manager (se va preciza ce este)
- managerul nu a angajat niciun casier
*/

CREATE OR REPLACE FUNCTION gaseste_casierul_cel_mai_profitabil(nume_angajator VARCHAR2) RETURN angajat.id_angajat%TYPE
IS
    TYPE lista_id IS TABLE OF angajat.id_angajat%TYPE;
    manager_gasit angajat.id_angajat%TYPE;
    casier_gasit angajat.id_angajat%TYPE;
BEGIN
    DECLARE
        rezultate lista_id := lista_id();
        este_manager BINARY_INTEGER;
    BEGIN
        SELECT id_angajat
        BULK COLLECT INTO rezultate
        FROM angajat
        WHERE nume = nume_angajator;
        CASE rezultate.COUNT
            WHEN 0 THEN
                RAISE_APPLICATION_ERROR(-20000, 'Nu a fost găsit un angajat cu numele "'||nume_angajator||'"'||'.');
            WHEN 1 THEN
                manager_gasit := rezultate(1);
            ELSE
                DECLARE
                    err_msg VARCHAR2(255);
                BEGIN
                    err_msg := 'Multiplii angajați au numele "'||nume_angajator||'":';
                    FOR i IN 1..rezultate.COUNT
                    LOOP
                        err_msg := err_msg||' '||rezultate(i);
                    END LOOP;
                    RAISE_APPLICATION_ERROR(-20003, err_msg);
                EXCEPTION
                    WHEN VALUE_ERROR THEN
                        RAISE_APPLICATION_ERROR(-20003, err_msg || '[...]');
                END;
        END CASE;
        SELECT COUNT(id_angajat)
        INTO este_manager
        FROM manager
        WHERE id_angajat = manager_gasit;
        IF este_manager = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Angajatul '||nume_angajator||' (ID '||manager_gasit||') nu este manager.');
        END IF;
    END;
    BEGIN
        /*
        Patru tabele: CASIER -> COMANDA -> COMANDA_INCLUDE_RETETA (asociativ) -> RETETA
        */
        WITH casieri AS (
            SELECT id_angajat, SUM(pret * nr) profit
            FROM angajat
            JOIN comanda
            ON angajat.id_angajat = comanda.id_casier
            JOIN comanda_include_reteta
            USING (id_comanda)
            JOIN reteta
            USING (id_reteta)
            WHERE job_cod = 'CASIER' AND id_angajator = manager_gasit
            GROUP BY id_angajat
            ORDER BY profit
        )
        SELECT id_angajat
        INTO casier_gasit
        FROM casieri
        WHERE rownum = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Managerul '||nume_angajator||' (ID '||manager_gasit||') nu are casieri.');
    END;
    RETURN casier_gasit;
END gaseste_casierul_cel_mai_profitabil;
/

DECLARE
    /*
    Excepțiile nu pot fi declarate global, deoarece nu se poate stoca o excepție în bază da date.
    Deci blocurile care vor să le prindă trebuie să creeze excepțiile și să le știe codurile.
    Când va fi creată versiunea cu pachet a acestei cerințe, vor putea fi declarate în specificația pachetului.
    */
    nume_nu_exista EXCEPTION;
    angajat_nu_e_manager EXCEPTION;
    manager_nu_are_casieri EXCEPTION;
    PRAGMA EXCEPTION_INIT (nume_nu_exista, -20000);
    PRAGMA EXCEPTION_INIT (angajat_nu_e_manager, -20001);
    PRAGMA EXCEPTION_INIT (manager_nu_are_casieri, -20002);
    /*
    Cursorul extrage automat date de test, independent de datele din tabel, fără a hardcoda nume.
    Se vor returna how_many_of_each (sau dacă nu se poate, cât mai mulți) angajați pentru categoriile:
    - manageri cu angajați
    - manageri fără angajați
    - angajați non-manager
    - nume non-existent
    Va funționa chiar dacă seed-ul RNG pentru generarea datelor angajaților este schimbat.
    Excepția de nume ambiguu va fi testată separat deoarece necesită inserarea de date în tabel.
    */
    CURSOR test_data(how_many_of_each NUMBER)
    IS
    WITH are_angajat_da_nu AS (
        /*
        Nu e suficienăm să verificăm dacă e autorizat, nu garantează că a angajat pe cineva încă.
        */
        SELECT id_angajat, nume, (
            SELECT DECODE(COUNT(a2.id_angajat), 0, 0, 1)
            FROM angajat a2
            WHERE id_angajator = a1.id_angajat
        ) AS tip_test
        FROM angajat a1
        WHERE job_cod = 'MANAGER'
    )
    SELECT *
    FROM (
        SELECT are_angajat_da_nu.*, row_number() over (partition by tip_test order by id_angajat) repeat_nr
        FROM are_angajat_da_nu
    )
    WHERE repeat_nr <= how_many_of_each
    UNION
    SELECT id_angajat, nume, 2, rownum
    FROM angajat
    WHERE job_cod != 'MANAGER' AND rownum <= how_many_of_each
    UNION
    SELECT -1, 'NONEXISTENT ' ||LEVEL||' (TEST)', 3, LEVEL FROM DUAL
    CONNECT BY LEVEL <= how_many_of_each;

    test_case_nr BINARY_INTEGER := 1;
    TYPE labels IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
    test_names labels := labels();
BEGIN
    test_names(0) := 'Manager fără angajați';
    test_names(1) := 'Manager cu angajați';
    test_names(2) := 'Non-manager';
    test_names(3) := 'Nume non-existent';

    FOR test_row IN test_data(3)
    LOOP
        dbms_output.PUT('Test '||LPAD(test_case_nr, 2)||
                        ' - '||test_names(test_row.tip_test)||
                        ' - '||test_row.nume||
                        ' - rezultat test: ');
        DECLARE
            casier angajat.id_angajat%TYPE;
        BEGIN
            casier := gaseste_casierul_cel_mai_profitabil(test_row.nume);
            dbms_output.PUT_LINE('ID casier = '||casier);
        EXCEPTION
            WHEN angajat_nu_e_manager THEN
                dbms_output.PUT_LINE('!! eroare angajat_nu_e_manager !! - '||SQLERRM);
            WHEN manager_nu_are_casieri THEN
                dbms_output.PUT_LINE('!! eroare manager_nu_are_casieri !! - '||SQLERRM);
            WHEN nume_nu_exista THEN
                dbms_output.PUT_LINE('!! eroare nume_nu_exista !! - '||SQLERRM);
        END;
        test_case_nr := test_case_nr + 1;
    END LOOP;
END;

/*
 Testare caz nume ambiguu. Se vor insera date ambigue, se va apela funcția, apoi se va face ROLLBACK.
*/

INSERT INTO angajat (id_angajat, id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
SELECT 1000 + LEVEL, 1, NULL, 'MANAGER', 'Test Ambiguu', SYSDATE, 0
FROM DUAL
CONNECT BY LEVEL <= 100;

INSERT INTO manager (id_angajat, autorizat_sa_angajeze)
SELECT id_angajat, 1 FROM angajat
WHERE nume = 'Test Ambiguu';

DECLARE
    nume_ambiguu EXCEPTION;
    PRAGMA EXCEPTION_INIT (nume_ambiguu, -20003);
BEGIN
    dbms_output.PUT('Test ambiguu: ');
    BEGIN
        dbms_output.PUT_LINE('(nu ar trebui să se afișeze asta) ID casier = ' ||
                             gaseste_casierul_cel_mai_profitabil('Test Ambiguu'));
    EXCEPTION
        WHEN nume_ambiguu THEN
            dbms_output.PUT_LINE('!! nume_ambiguu !! - '||SQLERRM);
    END;
END;

ROLLBACK;



DROP PROCEDURE gaseste_casierul_cel_mai_profitabil;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------ ex_9.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
Să se genereze un meniu pentru restaurant.
Trebuie listate rețetele, prețul lor, ingredientele și alergiile asociate fiecărei rețete.
Se va genera în format HTML și se va exporta automat.
*/

/*
!!! Aceste comenzi necesita privilegii de administrator. Trebuie executate din SQL*Plus folosind un cont de administrator. !!!

CREATE OR REPLACE DIRECTORY dir_meniu AS 'C:\pl_sql_meniu';
GRANT READ, WRITE ON DIRECTORY dir_meniu TO PUBLIC;
*/

CREATE OR REPLACE PROCEDURE generate_menu(file_name VARCHAR2)
IS
    TYPE lista_alergii IS VARRAY(3) OF alergie.nume%TYPE;
    alergii lista_alergii := lista_alergii();

    output_buffer VARCHAR2(1023);
    LF_CODE BINARY_INTEGER := 10;

    PROCEDURE put(str VARCHAR2)
    IS
    BEGIN
        output_buffer := output_buffer||str;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20005, 'Meniu prea mare, trebuie crescuta mărinea lui output_buffer (curent: '||1023||')');
    END;

    PROCEDURE putln(str VARCHAR2)
    IS
    BEGIN
        put(str||CHR(LF_CODE));
    END;
BEGIN
    putln('<html lang="ro">'||
            '<head><meta charset="UTF-8"></head>'||
            '<body>'||
            '<h1>Bine ați venit la restaurantul nostru!</h1>'||
            '<p>Oferim următoarele rețete:</p>'||
            '<ul>'
    );
    FOR row_reteta IN (SELECT id_reteta, nume, pret FROM reteta)
    LOOP
        putln('<li><p>'||INITCAP(row_reteta.nume)||' - '||row_reteta.pret||' RON</p>');
        /*
        Cinci tablele: RETETA -> RETETA_CONTINE_INGREDIENT -> INGREDIENT -> INGREDIENT_PROVOACA_ALERGIE -> ALERGIE
        */
        alergii.DELETE;
        SELECT DISTINCT INITCAP(alergie.nume)
        BULK COLLECT INTO alergii
        FROM reteta
        JOIN reteta_contine_ingredient
        USING (id_reteta)
        JOIN ingredient
        USING (id_ingredient)
        JOIN ingredient_provoaca_alergie
        USING (id_ingredient)
        JOIN alergie
        USING (id_alergie)
        WHERE id_reteta = row_reteta.id_reteta;
        IF alergii.count > 0
        THEN
            put('<p><em>Informații alergii: '||alergii(1));
            FOR i IN 2..alergii.last
            LOOP
                put(', '||alergii(i));
            END LOOP;
            putln('.</em></p>');
        END IF;
        putln('</li>');
    END LOOP;
    putln('</body></html>');
    DECLARE
        f UTL_FILE.file_type;
        PROCEDURE rs(template_str VARCHAR2) /* prescurtare pentru raise */
        IS
        BEGIN
            RAISE_APPLICATION_ERROR(-20006, REPLACE(template_str, 'FNAME', file_name));
        END;
    BEGIN
        f := UTL_FILE.fopen('DIR_MENIU', file_name, 'W');
        UTL_FILE.put(f, output_buffer);
        UTL_FILE.FCLOSE(f);
    EXCEPTION
        WHEN UTL_FILE.access_denied THEN
            rs('Serverul Oracle nu are access pentru a crea fișierul FNAME. Posibil locația DIRECTORY DIR_MENIU trebuie schimbată.');
        WHEN UTL_FILE.file_open THEN
            rs('Fișierul FNAME este deja deschis. Nu se poate suprascrie.');
        WHEN UTL_FILE.internal_error THEN
            rs('Eroare necunoscută PL/SQL. Nu se poate genera fișierul FNAME.');
        WHEN UTL_FILE.invalid_filename THEN
            rs('Numele FNAME pentru fișier este invalid.');
        WHEN UTL_FILE.invalid_operation THEN
            rs('Operația pe fișierul FNAME nu a putut fi procesată din motive necunoscute. Verfică dacă folderul lui DIRECTORY DIR_MENIU există, și permisiunile la folder.');
        WHEN UTL_FILE.invalid_path THEN
            rs('Numele sau locația fișiserului FNAME invalid. Este posibil că DIRECTORY DIR_MENIU este configurat incorect.');
        WHEN UTL_FILE.write_error THEN
            rs('Nu s-a putut genera FNAME din cauza unei erori de sistem de operare la scrierea fișierului.');
    END;
END;
/

/*
Majoritatea erorilor UTL_FILE nu pot fi testate într-un bloc:
- access_denied: Nu pare că există pe sistemul Windows, ci eroarea invalid_operation se ridică când fișierul nu poate fi modificat.
                 E posibil că access_denied există doar pe sisteme Linux.
- file_open: Similar, nu pare că există. Când încerc să produc eroarea pe sistem Windows, obțin invalid_operation.
- internal_error: Deoarece această eroare este pentru erori nespecificate în implementarea lui UTL_FILE,
                  nu știu cum să o produc.
- invalid_filename: Se produce ușor, însă pare că doar nume ce conțin / produc eroarea.
                    Bănuiesc că UTL_FILE presupune că Windows permite orice nume ce nu conține /, ca pe un sistem Linux.
                    Alte nume invalide produc invalid_operation, probabil deoarece UTL_FILE întelege răspunsul de la Windows.
- invalid_operation: Pe Windows, dacă fișierul e deschis sau nu avem permisiuni, invalid_operation este ridicat.
                     Deasemenea, pare că unele nume invalide produc invalid_operation în loc de invalid_filename.
- invalid_path: Se produce dacă DIRECTORY nu există, sau dacă nu a fost folosită comanda GRANT pentru a permite acces.
- write_error: Deoarece eroarea este legată de erori de sistem de operare, nu am cum să o forțez să apară.
               Probabil ar fi nevoie de hardware defect sau de un filesystem virtual care simulează erori.
*/

BEGIN
    -- nicio eroare
    generate_menu('meniu.html');
    dbms_output.PUT_LINE('meniu.html generat cu succes!');
END;
/

DECLARE
    file_error EXCEPTION;
    PRAGMA EXCEPTION_INIT (file_error, -20006);
BEGIN
    BEGIN
        generate_menu('/');
    EXCEPTION
        WHEN file_error THEN
            dbms_output.PUT_LINE(SQLERRM);
    END;
    BEGIN
        generate_menu('?');
    EXCEPTION
        WHEN file_error THEN
            dbms_output.PUT_LINE(SQLERRM);
    END;
END;

/*
Eroarea needs_increased_output_buffer se generează ușor prin umplerea tabelului RETETA cu date extra.
*/
INSERT INTO reteta (id_reteta, nume, pret)
SELECT 1000 + LEVEL, 'Test row '||LEVEL, 0
FROM DUAL
CONNECT BY LEVEL <= 1000;

DECLARE
    needs_increased_output_buffer EXCEPTION;
    PRAGMA EXCEPTION_INIT (needs_increased_output_buffer, -20005);
BEGIN
    generate_menu('meniu.html');
EXCEPTION
    WHEN needs_increased_output_buffer THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

ROLLBACK;

DROP PROCEDURE generate_menu;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
----------------------------------- ex_10.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
S-a decis că deoarece unele tabele din baza de date se vor schimba rar, ar trebui monitorizate modificări ale lor.
Acele tabele sunt:
ALERGIE, INGREDIENT_provoaca_ALERGIE, INGREDIENT, RETETA_contine_INGREDIENT, RETETA, JOB
Să se stocheze log-ul tuturor modificărilor la aceste tabele.
Log-ul va include: username, nume tabel, tip operatie, data modificare.
*/

CREATE SEQUENCE id_modificari_anormale_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE log_modificari_anormale (
    id_modificari_anormale NUMBER(10) DEFAULT id_modificari_anormale_seq.nextval PRIMARY KEY,
    username VARCHAR2(255) DEFAULT USER NOT NULL,
    nume_tabel VARCHAR2(255) NOT NULL,
    tip_operatie VARCHAR2(15) NOT NULL,
    data_modificare DATE DEFAULT SYSDATE NOT NULL
);

CREATE OR REPLACE PROCEDURE create_modification_log(nume_tabel VARCHAR2)
IS
    tip VARCHAR2(15) := 'UNKNOWN';
BEGIN
    IF INSERTING THEN
        tip := 'INSERT';
    ELSIF UPDATING THEN
        tip := 'UPDATE';
    ELSIF DELETING THEN
        tip := 'DELETE';
    END IF;
    INSERT INTO log_modificari_anormale (nume_tabel, tip_operatie) VALUES (nume_tabel, tip);
END;
/

CREATE OR REPLACE PROCEDURE instalare_triggeri_autogenerat
IS
    template VARCHAR2(1023) := 'CREATE OR REPLACE TRIGGER LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_{{NUMETABEL}}
        BEFORE INSERT OR UPDATE OR DELETE ON {{NUMETABEL}}
    BEGIN
        create_modification_log(''{{NUMETABEL}}'');
    END;';
    cod VARCHAR2(1023);
    TYPE lista IS TABLE OF VARCHAR2(31);
    tabele_monitorizate lista :=
        lista('ALERGIE', 'INGREDIENT_provoaca_ALERGIE', 'INGREDIENT', 'RETETA_contine_INGREDIENT', 'RETETA', 'JOB');
BEGIN
    FOR i IN 1..tabele_monitorizate.LAST
    LOOP
        cod := REPLACE(template, '{{NUMETABEL}}', tabele_monitorizate(i));
        EXECUTE IMMEDIATE cod;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE stergere_triggeri_autogenerat
IS
    CURSOR triggeri_autogenerati
    IS
    SELECT trigger_name
    FROM all_triggers
    WHERE trigger_name LIKE 'LOG_MODIFICARI_ANORMALE_TRIGGER_AUTOGENERAT_%';
BEGIN
    FOR trigger_autogenerat IN triggeri_autogenerati
    LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_autogenerat.trigger_name;
    END LOOP;
END;
/

BEGIN
    instalare_triggeri_autogenerat();
END;
/

SELECT * FROM all_triggers;

INSERT INTO alergie (nume) VALUES ('alergie1');
UPDATE alergie SET nume = 'alergie2' WHERE id_alergie = 1;
UPDATE reteta SET pret = pret * pret;
DELETE FROM alergie WHERE nume = 'alergie1';
UPDATE reteta_contine_ingredient SET id_ingredient = 1 WHERE id_ingredient = 2;
INSERT INTO job (job_cod, salariu_baza, bonus_maxim)
SELECT 'job '||LEVEL, LEVEL * 1000, LEVEL * 100
FROM DUAL
CONNECT BY LEVEL <= 10000;

SELECT * FROM log_modificari_anormale;

ROLLBACK;

BEGIN
    stergere_triggeri_autogenerat();
END;

DROP TABLE log_modificari_anormale;
DROP SEQUENCE id_modificari_anormale_seq;
DROP PROCEDURE create_modification_log;
DROP PROCEDURE instalare_triggeri_autogenerat;
DROP PROCEDURE stergere_triggeri_autogenerat;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
----------------------------------- ex_11.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
Din cauza unor griji că managerii nu sunt antrenați să organizeze numere mari de angajați,
s-a decis să se limiteze numărul de angajați la 5 pe restaurant.
Să se creeze un trigger care să nu permită peste 5 angajați pe restaurant.
Se va arăta și un exemplu de trigger _incorect_, care nu funcționează din cauze erorii mutating.
*/

/**
  Exemplu de trigger cu eroare mutating.
*/

CREATE OR REPLACE TRIGGER limita_angajati
    AFTER INSERT OR UPDATE ON angajat
    FOR EACH ROW
DECLARE
    v_total NUMBER(10);
BEGIN
    SELECT COUNT(id_angajat)
    INTO v_total
    FROM angajat
    WHERE id_restaurant = :NEW.id_restaurant;
    IF v_total > 5 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Nu pot fi peste 5 angajați într-un restaurant!');
    END IF;
END;
/

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

DROP TRIGGER limita_angajati;

/**
  Rezolvarea erorii mutating cu un tabel auxiliar, siguranța multi-sesiune e asigurată cu LOCK TABLE prin trigger compus.
*/

CREATE TABLE aux_lim_ang AS
    SELECT id_restaurant, COUNT(id_angajat) AS nr_angajati
    FROM angajat
    GROUP BY id_restaurant;

CREATE OR REPLACE TRIGGER limita_angajati
    FOR INSERT OR DELETE OR UPDATE ON angajat
    COMPOUND TRIGGER

    v_nr_angajati NUMBER(10);

    BEFORE STATEMENT
    IS
    BEGIN
        LOCK TABLE aux_lim_ang IN EXCLUSIVE MODE;
    END BEFORE STATEMENT;

    BEFORE EACH ROW
    IS
    BEGIN
        IF DELETING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati - 1
            WHERE id_restaurant = :OLD.id_restaurant;
        END IF;
        IF INSERTING OR UPDATING THEN
            UPDATE aux_lim_ang
            SET nr_angajati = nr_angajati + 1
            WHERE id_restaurant = :NEW.id_restaurant
            RETURNING nr_angajati INTO v_nr_angajati;
            IF v_nr_angajati > 5 THEN
                raise_application_error(-20010, 'Nu pot fi mai mult de 5 angajați într-un restaurant!');
            END IF;
        END IF;
    END BEFORE EACH ROW;
END;
/

INSERT INTO angajat (id_restaurant, id_angajator, job_cod, nume, data_angajare, salariu)
VALUES (1, 1, 'CASIER', 'Ion', SYSDATE, 1000);

DROP TRIGGER limita_angajati;
DROP TABLE aux_lim_ang;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
----------------------------------- ex_12.sql --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
Să se interzică ștergerea și alterarea tabelelor din baza de date.
Încercările de ștergere sau alterare a tabelelor vor fi înregistrate într-o tabelă log.
Log-ul trebuie protejat la fel ca și restul tabelelor.
*/

CREATE SEQUENCE incercari_log_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE incercari_log (
    id_incercare NUMBER(10) DEFAULT incercari_log_seq.nextval PRIMARY KEY,
    username VARCHAR2(127) DEFAULT user NOT NULL,
    data date DEFAULT sysdate NOT NULL,
    operation VARCHAR2(127) NOT NULL,
    obj_type VARCHAR2(127) NOT NULL,
    obj_name VARCHAR2(127) NOT NULL
);

CREATE OR REPLACE PROCEDURE log_ddl_neanulabil
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO incercari_log (operation, obj_type, obj_name)
    VALUES (sys.sysevent, sys.DICTIONARY_OBJ_TYPE(), sys.DICTIONARY_OBJ_NAME());
    COMMIT;
END;
/

CREATE OR REPLACE TRIGGER protectie_tabele
    BEFORE DDL ON THEO.SCHEMA
DECLARE
    TYPE lista_protejate IS TABLE OF VARCHAR2(127);
    lista lista_protejate := lista_protejate('ALERGIE', 'ANGAJAT', 'BUCATAR', 'CASIER', 'COMANDA',
        'COMANDA_INCLUDE_RETETA', 'INGREDIENT', 'INGREDIENT_PROVOACA_ALERGIE', 'JOB', 'LIVRARE',
        'MANAGER', 'ORAS', 'RESTAURANT', 'RETETA', 'RETETA_CONTINE_INGREDIENT', 'INCERCARI_LOG');
BEGIN
    FOR i IN 1..lista.COUNT
    LOOP
        IF (UPPER(sys.DICTIONARY_OBJ_NAME()) = lista(i))
        THEN
            log_ddl_neanulabil;
            RAISE_APPLICATION_ERROR(-20011, 'Nu se poate folosi DDL pe tabelele protejate!');
        END IF;
    END LOOP;
END;
/

ALTER TABLE alergie ADD CONSTRAINT tmp CHECK (nume != '');
CREATE TABLE test (id NUMBER(10) PRIMARY KEY, nume VARCHAR2(127));
DROP TABLE test;
DROP TABLE incercari_log;
SELECT * FROM incercari_log;

DROP TRIGGER protectie_tabele;
DROP PROCEDURE log_ddl_neanulabil;
DROP TABLE incercari_log;
DROP SEQUENCE incercari_log_seq;
