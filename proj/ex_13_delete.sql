BEGIN
    pizza.STERGERE_TRIGGERI_AUTOGENERAT();
END;
/

DROP TRIGGER limita_angajati;
DROP TRIGGER protectie_tabele;

DROP SEQUENCE id_modificari_anormale_seq;
DROP SEQUENCE incercari_log_seq;
DROP TABLE log_modificari_anormale;
DROP TABLE aux_lim_ang;
DROP TABLE incercari_log;

DROP PACKAGE pizza;
