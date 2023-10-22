DROP SEQUENCE ID_ORAS_SEQ;
DROP SEQUENCE ID_RESTAURANT_SEQ;
DROP SEQUENCE ID_ANGAJAT_SEQ;
DROP SEQUENCE ID_INGREDIENT_SEQ;
DROP SEQUENCE ID_RETETA_SEQ;
DROP SEQUENCE ID_ALERGIE_SEQ;
DROP SEQUENCE ID_COMANDA_SEQ;
DROP TABLE ORAS CASCADE CONSTRAINTS;
DROP TABLE RESTAURANT CASCADE CONSTRAINTS;
DROP TABLE ANGAJAT CASCADE CONSTRAINTS;
DROP TABLE CASIER CASCADE CONSTRAINTS;
DROP TABLE BUCATAR CASCADE CONSTRAINTS;
DROP TABLE MANAGER CASCADE CONSTRAINTS;
DROP TABLE INGREDIENT CASCADE CONSTRAINTS;
DROP TABLE RETETA CASCADE CONSTRAINTS;
DROP TABLE ALERGIE CASCADE CONSTRAINTS;
DROP TABLE COMANDA CASCADE CONSTRAINTS;
DROP TABLE LIVRARE CASCADE CONSTRAINTS;
DROP TABLE JOB_are_SALARIU CASCADE CONSTRAINTS;
DROP TABLE INGREDIENT_provoaca_ALERGIE CASCADE CONSTRAINTS;
DROP TABLE RETETA_contine_INGREDIENT CASCADE CONSTRAINTS;
DROP TABLE COMANDA_include_RETETA CASCADE CONSTRAINTS;


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
CREATE TABLE JOB_are_SALARIU (
  job_cod VARCHAR2(10) PRIMARY KEY,
  salariu NUMBER(10) NOT NULL
);
CREATE TABLE ANGAJAT (
  id_angajat NUMBER(10) DEFAULT ID_ANGAJAT_SEQ.nextval PRIMARY KEY,
  id_restaurant NUMBER(10) NOT NULL,
  id_angajator NUMBER(10),
  job_cod VARCHAR2(10) NOT NULL,
  nume VARCHAR2(50) NOT NULL,
  data_angajare DATE NOT NULL,
  FOREIGN KEY (id_restaurant) REFERENCES RESTAURANT(id_restaurant),
  FOREIGN KEY (job_cod) REFERENCES JOB_are_SALARIU(job_cod)
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
  PRIMARY KEY (id_comanda, id_reteta)
);

INSERT INTO JOB_are_SALARIU
VALUES ('CASIER', 2000);
INSERT INTO JOB_are_SALARIU
VALUES ('BUCATAR', 4000);
INSERT INTO JOB_are_SALARIU
VALUES ('MANAGER', 4500);

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












-- GENERATED WITH generate_data.py



INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (1, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (1, NULL, 'MANAGER', 'Olariu Adrian', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (1, False);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (1, NULL, 'MANAGER', 'Savu Razvan', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (2, True);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (1, 2, 'CASIER', 'Manolache Ciprian', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (3, NULL);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (1, 2, 'CASIER', 'Nae Gabriela', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (4, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (1, 2, 'BUCATAR', 'Tanase Daniel', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (5, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (2, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (2, NULL, 'MANAGER', 'Burlacu Daniel', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (6, False);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (2, NULL, 'CASIER', 'Teodorescu Ana', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (7, NULL);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (2, NULL, 'BUCATAR', 'Pintilie Loredana', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (8, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (3, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (3, NULL, 'MANAGER', 'Dragoi Ciprian', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (9, False);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (3, NULL, 'CASIER', 'Diaconescu Adriana', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (10, NULL);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (3, NULL, 'CASIER', 'Neagu Iulia', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (11, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (3, NULL, 'BUCATAR', 'Petre Silviu', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (12, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (4, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (4, NULL, 'MANAGER', 'Gherasim Laura', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (13, False);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (4, NULL, 'CASIER', 'Moise Simona', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (14, NULL);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (4, NULL, 'CASIER', 'Cristea Bogdan', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (15, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (4, NULL, 'BUCATAR', 'Neacsu Maria', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (16, NULL);
INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES (5, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (5, NULL, 'MANAGER', 'Iordache Anamaria', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES (17, False);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (5, NULL, 'CASIER', 'Ionita Florentina', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (18, NULL);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (5, NULL, 'CASIER', 'Dragoi Ion', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES (19, 1);
INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES (5, NULL, 'BUCATAR', 'Tomescu Iulian', TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES (20, TO_DATE('2020-01-01', 'YYYY-MM-DD'));
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (1, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (1, 4);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (2, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (2, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (2, 'Str. Ilie nr. 79', 17);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (3, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (3, 'Str. Dumitrescu nr. 5 bl. 45', 18);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (1, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (4, 2);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (4, 4);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (4, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (4, 'Str. Dumitrache nr. 87', 19);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (5, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (5, 4);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (6, 2);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (6, 'Str. Alexa nr. 76', 13);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (7, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (3, 11);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (8, 4);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 15);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (9, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (9, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (9, 'Str. Petcu nr. 6 bl. 2', 11);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 15);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (10, 1);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (10, 5);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (10, 1);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (10, 'Str. Gavrila nr. 15 bl. 39', 10);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (4, 15);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (11, 5);
INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES (11, 'Str. Pavel nr. 62 bl. 47', 10);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 19);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (12, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (12, 1);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 19);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (13, 2);
INSERT INTO COMANDA (id_restaurant, id_casier) VALUES (5, 19);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (14, 3);
INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES (14, 1);
SELECT COUNT(*) FROM ORAS;
SELECT COUNT(*) FROM RESTAURANT;
SELECT COUNT(*) FROM JOB_are_SALARIU;
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
