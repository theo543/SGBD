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
