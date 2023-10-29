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
    COMANDA_ID_SEQ = 0

    nr_retete = 5
    nr_orase = 5

    def insert_random_employee(id_restaurant, manageri, job_cod) -> int:
        nonlocal ANGAJAT_ID_SEQ
        nonlocal sql_code
        id_angajator = "NULL"
        if(len(manager) != 0): id_angajator = random.choice(manager)
        ANGAJAT_ID_SEQ += 1
        sql_code += f"INSERT INTO ANGAJAT (id_restaurant, id_angajator, job_cod, nume, data_angajare) VALUES ({id_restaurant}, {id_angajator}, '{job_cod}', '{random.choice(nume)} {random.choice(prenume)}', {start_date});\n"
        return ANGAJAT_ID_SEQ

    RESTAURANT : list[int] = []
    MANAGER = {}
    CASIER  = {}

    for i in range(5):
        RESTAURANT_ID_SEQ += 1
        id_oras = i + 1
        RESTAURANT.append(RESTAURANT_ID_SEQ)
        sql_code += f"INSERT INTO RESTAURANT (id_oras, data_deschidere) VALUES ({id_oras}, {start_date});\n"
        MANAGER[RESTAURANT_ID_SEQ] = []
        CASIER[RESTAURANT_ID_SEQ] = []
        manager = MANAGER[RESTAURANT_ID_SEQ]
        casier = CASIER[RESTAURANT_ID_SEQ]
        for i in range(random.randint(1, 2)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "MANAGER")
            autorizat_sa_angajeze = int(i == 0)
            sql_code += f"INSERT INTO MANAGER (id_angajat, autorizat_sa_angajeze) VALUES ({id_angajat}, {autorizat_sa_angajeze});\n"
            if autorizat_sa_angajeze == 1:
                manager.append(id_angajat)
        casa_de_marcat = 0
        for i in range (random.randint(1, 3)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "CASIER")
            nr_casa_de_marcat = "NULL"
            if i == 0 or random.choice([False, True, True]):
                casa_de_marcat += 1
                nr_casa_de_marcat = casa_de_marcat
                casier.append(id_angajat)
            sql_code += f"INSERT INTO CASIER (id_angajat, nr_casa_de_marcat) VALUES ({id_angajat}, {nr_casa_de_marcat});\n"
        for _ in range (random.randint(1, 1)):
            id_angajat = insert_random_employee(RESTAURANT_ID_SEQ, manager, "BUCATAR")
            data_antrenament_de_siguranta = random.choice([start_date, "NULL"])
            sql_code += f"INSERT INTO BUCATAR (id_angajat, data_antrenament_de_siguranta) VALUES ({id_angajat}, {data_antrenament_de_siguranta});\n"

    def random_comanda(id_restaurant, id_casier):
        nonlocal COMANDA_ID_SEQ
        nonlocal sql_code
        COMANDA_ID_SEQ += 1
        sql_code += f"INSERT INTO COMANDA (id_restaurant, id_casier) VALUES ({id_restaurant}, {id_casier});\n"
        for reteta in random.sample(range(1, nr_retete + 1), k=random.choice([1, 1, 2, 2, 2, 3, 4])):
            nr = random.choice([1, 1, 1, 1, 2, 2, 3])
            sql_code += f'INSERT INTO COMANDA_include_RETETA (id_comanda, id_reteta, nr) VALUES ({COMANDA_ID_SEQ}, {reteta}, {nr});\n'
        if random.choice([True, False]):
            adresa = f"Str. {random.choice(nume)} nr. {random.randint(1, 100)}"
            if random.choice([True, False]):
                adresa += f" bl. {random.randint(1, 50)}"
            cost = random.randint(10, 20)
            sql_code += f"INSERT INTO LIVRARE (id_comanda, adresa, pret) VALUES ({COMANDA_ID_SEQ}, '{adresa}', {cost});\n"

    for i in RESTAURANT:
        for c in CASIER[i]:
            for _ in range(random.randint(1, 10)):
                random_comanda(i, c)
    TABELE = ['ORAS', 'RESTAURANT', 'JOB_are_SALARIU', 'ANGAJAT', 'CASIER', 'BUCATAR', 'MANAGER', 'INGREDIENT', 'RETETA', 'ALERGIE', 'COMANDA', 'LIVRARE', 'INGREDIENT_provoaca_ALERGIE', 'RETETA_contine_INGREDIENT', 'COMANDA_include_RETETA']
    for table in TABELE:
        sql_code += f"SELECT COUNT(*) FROM {table};\n"

    with open("generate_data.sql", "w") as f:
        f.write(sql_code)

if __name__ == "__main__":
    main()
