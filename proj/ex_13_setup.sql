/*
Unele obiecte nu pot fi definite în pachet.
*/

CREATE SEQUENCE id_modificari_anormale_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE incercari_log_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE log_modificari_anormale (
    id_modificari_anormale NUMBER(10) DEFAULT id_modificari_anormale_seq.nextval PRIMARY KEY,
    username VARCHAR2(255) DEFAULT USER NOT NULL,
    nume_tabel VARCHAR2(255) NOT NULL,
    tip_operatie VARCHAR2(15) NOT NULL,
    data_modificare DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE aux_lim_ang AS
    SELECT id_restaurant, COUNT(id_angajat) AS nr_angajati
    FROM angajat
    GROUP BY id_restaurant;

CREATE TABLE incercari_log (
    id_incercare NUMBER(10) DEFAULT incercari_log_seq.nextval PRIMARY KEY,
    username VARCHAR2(127) DEFAULT user NOT NULL,
    data date DEFAULT sysdate NOT NULL,
    operation VARCHAR2(127) NOT NULL,
    obj_type VARCHAR2(127) NOT NULL,
    obj_name VARCHAR2(127) NOT NULL
);
