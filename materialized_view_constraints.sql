-- discussed in PHP class

-- this makes it faster... but I'm not sure if it works
-- CREATE MATERIALIZED VIEW LOG ON employees
--     WITH PRIMARY KEY, ROWID (department_id)
--     INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW dpt_count
REFRESH -- FAST
ON COMMIT
AS
    SELECT department_id, COUNT(employee_id) as department_count
    FROM employees
    GROUP BY department_id;

ALTER TABLE dpt_count
ADD CONSTRAINT no_more_than_50
CHECK (department_count <= 50);

-- from session 1...
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
SELECT LEVEL + 1000, 'a', 'b', 'c@c.c'||LEVEL, 10, SYSDATE, 'IT_PROG', 100, 0, NULL, 30 FROM DUAL
CONNECT BY LEVEL < 30;

-- from session 2...
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
SELECT LEVEL + 3000, 'a', 'b', 'c@c.c'||(1000 + LEVEL), 10, SYSDATE, 'IT_PROG', 100, 0, NULL, 30 FROM DUAL
CONNECT BY LEVEL < 30;

DELETE FROM employees WHERE employee_id > 1000;

DROP MATERIALIZED VIEW dpt_count;
-- DROP MATERIALIZED VIEW LOG ON employees;
