-- SELF-JOIN DEMO

\pset footer off

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    empl_id INTEGER,
    boss_id INTEGER,
    fname TEXT,
    lname TEXT
);

INSERT INTO employees VALUES 
(11,NULL,'Jane','Smith'),
(12,11,'John','Smith'),
(12,11,'Joe','Smith'),
(13,11,'Jerry','Smith'),
(14,13,'James','Johnson'),
(15,13,'Jimmy','Johnson')
;


\echo '\n\nRaw, unmodified table.\n'
select * from employees;


\echo '\n\nSelect each employee along with the name of their boss.\n'
SELECT 
    b.empl_id,
    b.fname,
    b.lname,
    a.fname as boss_fname,
    a.lname as boss_lname
FROM employees a
    INNER JOIN employees b
        ON a.empl_id = b.boss_id
;
