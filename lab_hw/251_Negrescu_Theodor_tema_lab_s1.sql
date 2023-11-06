/*
9 - Negrescu Theodor
S? se listeze numele tuturor angajatilor care au a treia liter? din nume ‘A’.
*/
SELECT last_name
FROM employees
WHERE upper(last_name) LIKE '__A%';

/*
10 - Negrescu Theodor
S? se listeze numele tuturor angajatilor care au 2 litere ‘L’ in nume ?i lucreaz? în
departamentul 30 sau managerul lor este 102.
*/
SELECT last_name
FROM employees
WHERE (upper(last_name) LIKE '%L%L%' AND department_id = 30) OR manager_id = 102;

/*
11 - Negrescu Theodor
S? se afiseze numele, job-ul si salariul pentru toti salariatii al caror job con?ine ?irul
“CLERK” sau “REP” ?i salariul nu este egal cu 1000, 2000 sau 3000. (operatorul NOT IN)
*/
SELECT last_name, job_id, salary
FROM employees
WHERE (job_id LIKE '%CLERK%' OR job_id LIKE '%REP%') AND salary NOT IN (1000, 2000, 3000);
