/*
CoderPad provides a basic SQL sandbox with the following schema.
You can also use commands like '\dt;' and '\d employees;'

employees                             projects
+---------------+---------+           +---------------+---------+
| id            | int     |<----+  +->| id            | int     |
| first_name    | varchar |     |  |  | title         | varchar |
| last_name     | varchar |     |  |  | start_date    | date    |
| salary        | int     |     |  |  | end_date      | date    |
| department_id | int     |--+  |  |  | budget        | int     |
+---------------+---------+  |  |  |  +---------------+---------+
                             |  |  |
departments                  |  |  |  employees_projects
+---------------+---------+  |  |  |  +---------------+---------+
| id            | int     |<-+  |  +--| project_id    | int     |
| name          | varchar |     +-----| employee_id   | int     |
+---------------+---------+           +---------------+---------+
*/

--Starter Code
/*SELECT e.first_name, e.last_name, e.salary,
  d.name as department_name
FROM employees   AS e
JOIN departments AS d ON e.department_id = d.id;
*/

--Where clauses
/*
SELECT e.first_name, e.last_name, e.salary,
  d.name as department_name
FROM employees   AS e
JOIN departments AS d ON e.department_id = d.id
where e.first_name like 'John%';
*/

--Group by to show total salary by department
/*
SELECT d.name as department_name, sum(e.salary) as salary_sum
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
group by department_name
order by salary_sum dec;
*/

--Find mean, min, max and count
/*SELECT d.name as department_name, 
sum(e.salary) as salary_sum,
max(e.salary) as salary_max,
min(e.salary) as salary_min,
round(avg(e.salary),0) as salary_mean,
count( distinct e.id) as employees
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
group by department_name;
*/

--Find salary deviation from mean
/*
SELECT 
round(avg(e.salary),0) as salary_mean,
round(stddev(e.salary),0) as salary_stdev
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
;
*/


-- Joins

selct 
  id
from
  employees
