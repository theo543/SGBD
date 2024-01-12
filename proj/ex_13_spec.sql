CREATE OR REPLACE PACKAGE pizza AS
    SUBTYPE id_ang IS angajat.id_angajat%TYPE;
    SUBTYPE id_rst IS restaurant.id_restaurant%TYPE;
    SUBTYPE id_cmd IS comanda.id_comanda%TYPE;
    SUBTYPE id_ing IS ingredient.id_ingredient%TYPE;
    SUBTYPE id_alg IS alergie.id_alergie%TYPE;
    SUBTYPE nume_ang IS angajat.nume%TYPE;
    SUBTYPE nume_alg IS alergie.nume%TYPE;

    TYPE lista_nume_tabel IS TABLE OF VARCHAR2(127);

    nume_nu_exista EXCEPTION;
    nume_ambiguu EXCEPTION;
    angajat_nu_e_manager EXCEPTION;
    manager_nu_are_casieri EXCEPTION;
    meniu_export_error EXCEPTION;
    need_increased_output_buffer_size EXCEPTION;
    limita_angajati_incalcata EXCEPTION;
    ddl_interzis EXCEPTION;
    PRAGMA EXCEPTION_INIT (nume_nu_exista, -20000);
    PRAGMA EXCEPTION_INIT (nume_ambiguu, -20001);
    PRAGMA EXCEPTION_INIT (angajat_nu_e_manager, -20002);
    PRAGMA EXCEPTION_INIT (manager_nu_are_casieri, -20003);
    PRAGMA EXCEPTION_INIT (meniu_export_error, -20004);
    PRAGMA EXCEPTION_INIT (need_increased_output_buffer_size, -20005);
    PRAGMA EXCEPTION_INIT (limita_angajati_incalcata, -20006);
    PRAGMA EXCEPTION_INIT (ddl_interzis, -20007);
    cod_nume_nu_exista CONSTANT BINARY_INTEGER := -20000;
    cod_nume_ambiguu CONSTANT BINARY_INTEGER := -20001;
    cod_angajat_nu_e_manager CONSTANT BINARY_INTEGER := -20002;
    cod_manager_nu_are_casieri CONSTANT BINARY_INTEGER := -20003;
    cod_meniu_export_error CONSTANT BINARY_INTEGER := -20004;
    cod_need_increased_output_buffer_size CONSTANT BINARY_INTEGER := -20005;
    cod_limita_angajati_incalcata CONSTANT BINARY_INTEGER := -20006;
    cod_ddl_interzis CONSTANT BINARY_INTEGER := -20007;

    -- ex 6
    PROCEDURE afiseaza_top_3_comenzi_riscante;

    -- ex 7
    PROCEDURE afiseaza_angajati_incomplet_antrenati;

    -- ex 8
    -- similar, nu am putut defini cursorul în specificație
    FUNCTION gaseste_casierul_cel_mai_profitabil(nume_angajator VARCHAR2) RETURN id_ang;
    -- teastează succesul și erorile de nume neexistent, non-manager, și manager fără angajați.
    PROCEDURE ruleaza_teste_ex8_1;
    -- testează eroarea de nume ambiguu, necesită AUTONOMOUS_TRANSACTION pentru a introduce nume identice
    PROCEDURE ruleaza_teste_ex8_2;

    -- ex 9
    PROCEDURE generate_meniu(file_name VARCHAR2);
    -- erorile UTL_FILE invalid_filename și invalid_operation
    PROCEDURE ruleaza_teste_ex9_1;
    -- eroarea needs_increased_output_buffer - necesită AUTONOMOUS_TRANSACTION pentru a introduce foarte multe date
    PROCEDURE ruleaza_teste_ex9_2;

    PROCEDURE ruleaza_teste_ex_6_7_8_9;

    -- ex 10
    lista_tabele_monitorizate CONSTANT lista_nume_tabel :=
        lista_nume_tabel('ALERGIE', 'INGREDIENT_provoaca_ALERGIE', 'INGREDIENT', 'RETETA_contine_INGREDIENT', 'RETETA', 'JOB');
    PROCEDURE create_modification_log(tabel VARCHAR2);
    PROCEDURE instalare_triggeri_autogenerat;
    PROCEDURE stergere_triggeri_autogenerat;

    -- ex 11
    PROCEDURE impl_trigger_eroare_mutating_per_row(new_id_rst id_rst);
    PROCEDURE impl_trigger_limita_angajati_per_row(old_id_rst id_rst, new_id_rst id_rst);

    -- ex 12
    lista_tabele_protejate CONSTANT lista_nume_tabel :=
        lista_nume_tabel('ALERGIE', 'ANGAJAT', 'BUCATAR', 'CASIER', 'COMANDA',
        'COMANDA_INCLUDE_RETETA', 'INGREDIENT', 'INGREDIENT_PROVOACA_ALERGIE', 'JOB', 'LIVRARE',
        'MANAGER', 'ORAS', 'RESTAURANT', 'RETETA', 'RETETA_CONTINE_INGREDIENT', 'INCERCARI_LOG');
    PROCEDURE log_ddl_neanulabil;
    PROCEDURE impl_trigger_protectie_tabele_ddl;
END pizza;
/
