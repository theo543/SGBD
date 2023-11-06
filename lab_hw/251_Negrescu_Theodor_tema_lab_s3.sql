/*
16. S? se ob?in? codurile departamentelor �n care nu lucreaza nimeni (nu este introdus nici un
salariat �n tabelul employees).
*/

SELECT department_id FROM DEPARTMENTS
WHERE department_id NOT IN (
  SELECT department_id FROM employees
  WHERE department_id IS NOT NULL
);

/*
17. S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i media salariilor tuturor
angaja?ilor. Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. Sa se rotunjeasca
rezultatele.
*/

SELECT MAX(salary) Maxim,
       MIN(salary) Minim,
       SUM(salary) Suma,
       ROUND(AVG(salary), 2) Media
FROM employees;

/*
18. S? se afi?eze minimul, maximul, suma ?i media salariilor pentru fiecare job.
*/

SELECT job_title Job,
       MAX(salary) Maxim,
       MIN(salary) Minim,
       SUM(salary) Suma,
       ROUND(AVG(salary), 2) Media
FROM employees
JOIN JOBS
USING (job_id)
GROUP BY job_title
ORDER BY job_title;

/*
19. S? se afi?eze num?rul de angaja?i pentru fiecare job.
*/

SELECT job_title Job,
       COUNT(*) Angajati
FROM employees
JOIN JOBS
USING (job_id)
GROUP BY job_title
ORDER BY job_title;

/*
20. Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, num?rul de angaja?i ?i
salariul mediu pentru angaja?ii din acel departament. Coloanele vor fi etichetate
corespunz?tor.
*/
WITH location AS (
    SELECT location_id, street_address || '; ' || city || '; ' || NVL(state_province, '<no state/province>') || '; ' || country_id || ';' location_name
    FROM locations
)
SELECT department_name Departament, location_name Locatie, COUNT(employee_id) Angajati, ROUND(AVG(salary), 2) Media
FROM employees
RIGHT JOIN departments
USING (department_id)
JOIN location
USING (location_id)
GROUP BY (department_name, location_name)
ORDER BY department_name;

/*
21. S? se afi?eze codul ?i numele angaja?ilor care c�stiga mai mult dec�t salariul mediu din
firm?. Se va sorta rezultatul �n ordine descresc?toare a salariilor.
*/

SELECT employee_id, first_name || ' ' || last_name name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

/*
22. Care este salariul mediu minim al job-urilor existente? Salariul mediu al unui job va fi
considerat drept media arirmetic? a salariilor celor care �l practic?.
*/

WITH medii AS (
  SELECT job_id, AVG(salary) medie
  FROM employees
  GROUP BY job_id
  ORDER BY medie
)
SELECT job_title, medie
FROM medii
JOIN jobs
USING (job_id)
WHERE rownum = 1;

/*
23. Modifica?i exerci?iul anterior pentru a afi?a ?i id-ul jobului.
*/

WITH medii AS (
  SELECT job_id, AVG(salary) medie
  FROM employees
  GROUP BY job_id
  ORDER BY medie
)
SELECT job_id, job_title, medie
FROM medii
JOIN jobs
USING (job_id)
WHERE rownum = 1;

/*
24. Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in
acel departament pentru:
a) departamentele in care lucreaza mai putin de 4 angajati;
b) departamentul care are numarul maxim de angajati.
*/

-- a)

WITH counts AS (
  SELECT department_id, COUNT(*) angajati
  FROM employees
  GROUP BY department_id
)
SELECT department_id, department_name, angajati FROM counts
JOIN departments
USING (department_id)
WHERE angajati < 4
ORDER BY angajati DESC;

-- b)

WITH counts AS (
  SELECT department_id, COUNT(*) angajati
  FROM employees
  GROUP BY department_id
  ORDER BY angajati DESC
)
SELECT department_id, department_name, angajati FROM counts
JOIN departments
USING (department_id)
WHERE rownum = 1;

/*
25. S? se ob?in? num?rul departamentelor care au cel pu?in 15 angaja?i
*/

WITH counts AS (
  SELECT department_id, COUNT(*) angajati
  FROM employees
  GROUP BY department_id
)
SELECT department_id, angajati FROM counts
WHERE angajati >= 15;

/*
26. Sa se afiseze salariatii care au fost angajati �n aceea?i zi a lunii �n care cei mai multi dintre
salariati au fost angajati.
*/

WITH hire_days AS (
  SELECT employee_id, EXTRACT(DAY FROM hire_date) hire_day FROM employees
),
hire_days_count AS (
  SELECT hire_day, COUNT(*) hire_count FROM hire_days
  GROUP BY hire_day
  ORDER BY hire_count DESC
)
SELECT employee_id FROM hire_days hd
JOIN (SELECT * FROM hire_days_count WHERE rownum = 1) hdc
USING (hire_day);

/*
27. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament
*/

SELECT e1.first_name || ' ' || e1.last_name name, e1.department_id, e1.salary
FROM employees e1
LEFT JOIN employees e2
ON e1.department_id = e2.department_id AND e1.salary > e2.salary
WHERE e2.salary IS NULL
AND e1.department_id IS NOT NULL
ORDER BY e1.salary;

/*
28. S? se detemine primii 10 cei mai bine pl?ti?i angaja?i
*/

WITH sorted AS (
  SELECT employee_id, salary FROM employees
  ORDER BY salary DESC
)
SELECT * FROM sorted
WHERE rownum <= 10;

/*
29. S? se afi?eze codul, numele departamentului ?i suma salariilor pe departamente
*/

SELECT department_id, department_name, SUM(salary) salary_sum FROM employees
JOIN departments
USING (department_id)
GROUP BY department_id, department_name;

/*
30. S? se afi?eze informa?ii despre angaja?ii al c?ror salariu dep??e?te valoarea medie a
salariilor colegilor s?i de departament.
*/

WITH department_avgs AS (
 SELECT department_id, AVG(salary) avg FROM employees
 GROUP BY department_id
)
SELECT first_name || ' ' || last_name name, salary, department_name FROM employees
JOIN department_avgs
USING (department_id)
JOIN departments
USING (department_id)
WHERE salary > avg;

/*
31. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament.
*/

-- Alta varianta.

WITH min_salaries AS (
  SELECT department_id, MIN(salary) min_salary FROM employees
  GROUP BY (department_id)
)
SELECT first_name || ' ' || last_name name, department_id, salary FROM employees
JOIN min_salaries
USING (department_id)
WHERE salary = min_salary
ORDER BY salary;
