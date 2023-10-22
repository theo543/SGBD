import random;
def main():
    random.seed(0)
    sql_code = "\n\n"
    # http://www.name-statistics.org/ro/prenumecomune.php

    prenume = ["Ana Maria", "Alexandru", "Mihaela", "Andreea", "Elena", "Adrian", "Andrei", "Alexandra", "Mihai", "Ionut", "Cristina", "Florin", "Daniel", "Marian", "Marius", "Cristian", "Daniela", "Alina", "Maria", "Ioana", "Constantin", "Nicoleta", "Georgiana", "Mariana", "Bogdan", "Vasile", "Gabriel", "Gabriela", "Nicolae", "Gheorghe", "George", "Ioan", "Valentin", "Adriana", "Ionela", "Catalin", "Stefan", "Ion", "Florentina", "Anca", "Anamaria", "Simona", "Iulian", "Roxana", "Oana", "Irina", "Diana", "Mirela", "Iuliana", "Madalina", "Raluca", "Ionel", "Lucian", "Cosmin", "Sorin", "Loredana", "Claudia", "Monica", "Ramona", "Dumitru", "Ana", "Ciprian", "Corina", "Laura", "Vlad", "Razvan", "Radu", "Liliana", "Valentina", "Viorel", "Iulia", "Ovidiu", "Florina", "Robert", "Catalina", "Carmen", "Claudiu", "Alin", "Oana Maria", "Camelia", "Andreea Elena", "Dan", "Costel", "Alina Elena", "Elena Cristina", "Mircea", "Laurentiu", "Georgeta", "Maria Cristina", "Paul", "Alina Maria", "Dragos", "Silviu"];
    # https://numedefamilie.eu/romania
    nume = ["Popa", "Popescu", "Pop", "Radu", "Dumitru", "Stan", "Stoica", "Gheorghe", "Matei", "Rusu", "Mihai", "Ciobanu", "Constantin", "Marin", "Ionescu", "Florea", "Ilie", "Toma", "Stanciu", "Munteanu", "Vasile", "Oprea", "Tudor", "Sandu", "Moldovan", "Ion", "Ungureanu", "Dinu", "Andrei", "Barbu", "Serban", "Neagu", "Cristea", "Anghel", "Lazar", "Dragomir", "Enache", "Badea", "Stefan", "Vlad", "Mocanu", "Iordache", "Coman", "Cojocaru", "Grigore", "Voicu", "Dobre", "Petre", "Nagy", "Lupu", "Lungu", "Ivan", "Ene", "Preda", "Roman", "Ionita", "Iancu", "Nicolae", "Balan", "Manea", "Nistor", "Stoian", "Avram", "Pavel", "Simion", "Rus", "Iacob", "Bucur", "Luca", "Olteanu", "Filip", "Tanase", "Costea", "Craciun", "David", "Stancu", "Dumitrescu", "Marcu", "Muresan", "Diaconu", "Nedelcu", "Rotaru", "Baciu", "Szabo", "Zaharia", "Costache", "Alexandru", "Suciu", "Dan", "Anton", "Bogdan", "Rosu", "Moraru", "Toader", "Paraschiv", "Sava", "Nica", "Kovacs", "Nita", "Muntean", "Constantinescu", "Albu", "Cretu", "Calin", "Olaru", "Varga", "Georgescu", "Dragan", "Popovici", "Ardelean", "Dumitrache", "Chiriac", "Petcu", "Miron", "Dima", "Mihalache", "Zamfir", "Paun", "Marinescu", "Petrescu", "Niculae", "Ghita", "Neacsu", "Soare", "Moise", "Bratu", "Damian", "Ursu", "Croitoru", "Istrate", "Sirbu", "Pascu", "Savu", "Manole", "Dinca", "Apostol", "Micu", "Stroe", "Nitu", "Draghici", "Crisan", "Tudorache", "Cozma", "Grosu", "Rosca", "Oancea", "Ignat", "Radulescu", "Adam", "Mihaila", "Sima", "Irimia", "Molnar", "Necula", "Ciocan", "Manolache", "Balint", "Grecu", "Burlacu", "Nastase", "Macovei", "Pirvu", "Turcu", "Simon", "Kiss", "Marian", "Chirila", "Panait", "Cazacu", "Teodorescu", "Trandafir", "Militaru", "Oltean", "Stanescu", "Negru", "Farcas", "Maxim", "Toth", "Gabor", "Florescu", "Dumitrascu", "Pintilie", "Tamas", "Morar", "Visan", "Cosma", "Chirita", "Danciu", "Dogaru", "Gavrila", "Tudose", "Voinea", "Dascalu", "Moldoveanu", "Lazăr", "Pana", "Mihalcea", "Patrascu", "Negrea", "Trif", "Mircea", "Ichim", "Alexe", "Grigoras", "Costin", "Iliescu", "Bejan", "Nechita", "Mirea", "Neagoe", "Cucu", "Puiu", "Musat", "Prodan", "Banu", "Stefanescu", "Olariu", "Ispas", "Szekely", "Blaga", "Danila", "Trifan", "Gal", "Groza", "Bota", "Boboc", "Maftei", "Vaduva", "Vasilescu", "Gherman", "Szasz", "Antal", "Petrea", "Martin", "Cornea", "Ganea", "Gheorghiu", "Chivu", "Pintea", "Staicu", "Niculescu", "Tănase", "Burcea", "Solomon", "Botezatu", "Miu", "Iorga", "Sabau", "Nicola", "Duta", "Pal", "Alexa", "Cirstea", "Man", "Udrea", "Aldea", "Cojocariu", "Crăciun", "Rotariu", "Negoita", "Ciobotaru", "Paduraru", "Biro", "Leonte", "Murariu", "Covaci", "Fodor", "Pricop", "Dragu", "Diaconescu", "Bodea", "Milea", "Pasca", "Carp", "Catana", "Onofrei", "Petrache", "Busuioc", "Moga", "Codreanu", "Buzatu", "Vasiliu", "Chis", "Tomescu", "Jianu", "Dragoi", "Tataru", "Ghinea", "Alecu", "Iosif", "Sandor", "Tanasa", "Epure", "şerban", "Scarlat", "Dobrin", "Radoi", "Gheorghita", "Filimon", "Veres", "Savin", "Iordan", "Nae", "Timofte", "Buta", "Duma", "ştefan", "Călin", "Achim", "Peter", "Boca", "Mitroi", "Dumitriu", "Mazilu", "Vieru", "Bunea", "Butnaru", "Ifrim", "Cristian", "Gherasim", "Mitu", "Ardeleanu", "Nechifor", "Chira", "Feraru", "Balazs", "Cazan", "Giurgiu", "Spiridon", "Marginean", "Vintila", "Palade", "Farkas", "Tofan", "Demeter", "Scurtu", "Chelaru", "Apetrei", "Vasilache", "Gradinaru", "Nicoara", "State", "Oros", "Dicu", "Ivascu", "Timis", "Marton", "Deaconu", "Robu", "Pantea"]; # from https://numedefamilie.eu/romania
    def isascii(s): return len(s) == len(s.encode())
    prenume = [x for x in prenume if isascii(x)]
    nume = [x for x in nume if isascii(x)]

    start_date = "TO_DATE('2020-01-01', 'YYYY-MM-DD')"

    ANGAJAT_ID_SEQ = 0
    RESTAURANT_ID_SEQ = 0
    FURNIZORI_ID_SEQ = 0
    CONTURI_ID_SEQ = 0
    COMANDA_ID_SEQ = 0

    nr_retete = 5
    nr_meniuri = 5
    nr_ingrediente = 8
    nr_orase = 5

    def insert_random_employee(id_restaurant, manageri, job_cod) -> int:
        nonlocal ANGAJAT_ID_SEQ
        nonlocal sql_code
        id_angajator = "NULL"
        if(len(manager) != 0): id_angajator = random.choice(manager)
        ANGAJAT_ID_SEQ += 1
        sql_code += f"INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES ({id_restaurant}, {id_angajator}, '{job_cod}', '{random.choice(nume)} {random.choice(prenume)}', {start_date});\n"
        return ANGAJAT_ID_SEQ

    RESTAURANT : list[tuple[str, int]] = []
    MANAGER = {}
    CASIER = {}
    BUCATAR = {}
    FURNIZORI = {}
    CONTURI : list[tuple[int, int]] = []
    RESTAURANT_cumpara_INGREDIENT_de_la_FURNIZOR = {}

    while len(CONTURI) < 20:
        CONTURI_ID_SEQ += 1
        email = random.choice(prenume).lower() + random.choice(nume).lower() + "@gmail.com"
        pwd_hash = "".join([random.choice("0123456789abcdef") for _ in range(50)])
        id_oras = random.randint(1, nr_orase)
        adresa_livrare = f'Strada {random.choice(nume)} Nr. {random.randint(1, 100)}'
        CONTURI.append((CONTURI_ID_SEQ, id_oras))
        sql_code += f"INSERT INTO CONT (email, pwd_hash, id_oras, adresa_livrare) VALUES ('{email}', '{pwd_hash}', {id_oras}, '{adresa_livrare}');\n"


    while len(FURNIZORI) < 20:
        FURNIZORI_ID_SEQ += 1
        FURNIZORI[FURNIZORI_ID_SEQ] = []
        furnizor = FURNIZORI[FURNIZORI_ID_SEQ]
        sql_code += f"INSERT INTO FURNIZOR (nume) VALUES ('{random.choice(nume)} SRL');\n"
        for ing in range(nr_ingrediente):
            if random.randint(0, 5) == 0: continue
            furnizor.append(ing + 1)
            sql_code += f"INSERT INTO FURNIZOR_ofera_INGREDIENT (id_furnizor, id_ingredient, pret) VALUES ({FURNIZORI_ID_SEQ}, {ing + 1}, {random.randint(1, 100)});\n"

    while len(RESTAURANT) < 30:
        RESTAURANT_ID_SEQ += 1
        id_oras = random.randint(1, nr_orase)
        RESTAURANT.append((RESTAURANT_ID_SEQ, id_oras))
        sql_code += f"INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES ({id_oras}, {start_date});\n"
        MANAGER[RESTAURANT_ID_SEQ] = []
        CASIER[RESTAURANT_ID_SEQ] = []
        BUCATAR[RESTAURANT_ID_SEQ] = []
        manager = MANAGER[RESTAURANT_ID_SEQ]
        casier = CASIER[RESTAURANT_ID_SEQ]
        bucatar = BUCATAR[RESTAURANT_ID_SEQ]
        for _ in range(random.randint(2, 3)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "MANAGER")
            autorizat_sa_angajeze = random.choice([1, 1, 0])
            sql_code += f"INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES ({id_angajat}, {autorizat_sa_angajeze});\n"
            if autorizat_sa_angajeze == 1: manager.append(id_angajat)
        casa_de_marcat = 0
        for _ in range (random.randint(1, 6)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "CASIER")
            nr_casa_de_marcat = "NULL"
            if random.randint(0, 1) == 1:
                casa_de_marcat += 1
                nr_casa_de_marcat = casa_de_marcat
            sql_code += f"INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES ({id_angajat}, {nr_casa_de_marcat});\n"
            casier.append(id_angajat)
        for _ in range (random.randint(2, 6)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "BUCATAR")
            data_antrenament_de_siguranta = random.choice([start_date, "NULL"])
            sql_code += f"INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES ({id_angajat}, {data_antrenament_de_siguranta});\n"
            bucatar.append(id_angajat)
        for month in range(1, 6):
            date_code = f"TO_DATE('2020-{month}-01', 'YYYY-MM-DD')"
            for ingredient in range(nr_ingrediente):
                if ingredient == 0 and random.randint(0, 1) == 1: continue # sometimes skip the first ingredient
                suplinitori_posibili = [x for x in FURNIZORI.keys() if ingredient + 1 in FURNIZORI[x]]
                if len(suplinitori_posibili) == 0: raise Exception("No suppliers for ingredient")
                id_furnizor = random.choice(suplinitori_posibili)
                sql_code += f"INSERT INTO RESTAURANT_cumpara_INGREDIENT_de_la_FURNIZOR (id_restaurant, id_ingredient, id_furnizor, data_comanda) VALUES ({RESTAURANT_ID_SEQ}, {ingredient + 1}, {id_furnizor}, {date_code});\n"

    for (cont, id_oras) in CONTURI:
        for _ in range(50):
            restaurante_in_oras = [x for x in RESTAURANT if x[1] == id_oras]
            if len(restaurante_in_oras) == 0: raise Exception("No restaurants in city")
            id_restaurant = random.choice(restaurante_in_oras)[0]
            comanda_via_casier = random.choice([1, 0, 0])
            id_casier = "NULL" if not comanda_via_casier else random.choice(CASIER[id_restaurant])
            id_cont = "NULL" if comanda_via_casier else f"'{cont}'"
            COMANDA_ID_SEQ += 1
            sql_code += f"INSERT INTO COMANDA (id_restaurant, id_casier, id_cont) VALUES ({id_restaurant}, {id_casier}, {id_cont});\n"
            for meniu in range(1, nr_meniuri + 1):
                if random.randint(0, 1) == 0: continue
                sql_code += f'INSERT INTO COMANDA_include_MENIU (id_comanda, id_meniu) VALUES ({COMANDA_ID_SEQ}, {meniu});\n'
            for reteta in range(1, nr_retete + 1):
                if random.randint(0, 1) == 0: continue
                sql_code += f'INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta) VALUES ({COMANDA_ID_SEQ}, {reteta});\n'

    TABELE = ['ORAS', 'RESTAURANT', 'ANGAJAT', 'CASIER', 'BUCATAR', 'MANAGER', 'INGREDIENT', 'RETETA', 'MENIU', 'ALERGIE', 'CONT', 'COMANDA', 'FURNIZOR', 'JOB_are_SALARIU', 'INGREDIENT_provoaca_ALERGIE', 'RETETA_contine_INGREDIENT', 'MENIU_contine_RETETA', 'FURNIZOR_ofera_INGREDIENT', 'RESTAURANT_cumpara_INGREDIENT_de_la_FURNIZOR', 'COMANDA_include_MENIU', 'COMANDA_include_RETETA']
    for table in TABELE:
        sql_code += f"SELECT COUNT(*) FROM {table};\n"

    with open("generate_data.sql", "w") as f:
        f.write(sql_code)

if __name__ == "__main__":
    main()
