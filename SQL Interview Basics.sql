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
SELECT e.first_name, e.last_name, e.salary,
  d.name as department_name
FROM employees   AS e
JOIN departments AS d ON e.department_id = d.id
where e.first_name like 'John%';

--Group by to show total salary by department
SELECT d.name as department_name, sum(e.salary) as salary_sum
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
group by department_name
order by salary_sum dec;

--Find mean, min, max and count
SELECT d.name as department_name, 
sum(e.salary) as salary_sum,
max(e.salary) as salary_max,
min(e.salary) as salary_min,
round(avg(e.salary),0) as salary_mean,
count( distinct e.id) as employees
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
group by department_name;

--Find salary deviation from mean

SELECT 
round(avg(e.salary),0) as salary_mean,
round(stddev(e.salary),0) as salary_stdev
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
;


-- Joins
-- left join shows 1 employee doesn't have a project
--shows all
select 
  e.id,
  ep.employee_id
from
  employees  e
left join 
  employees_projects ep on e.id = ep.employee_id;


--shows just employee missing a project
select 
  e.id,
  ep.employee_id
from
  employees  e
left join 
  employees_projects ep on e.id = ep.employee_id
where ep.employee_id is null;

--department
select 
  e.id,
  d.name
from
  employees  e
left join 
  departments d on e.department_id = d.id;


  --check for employees missing a department
select 
  e.id,
  d.name
from
  employees  e
left join 
  departments d on e.department_id = d.id
  where d.id is null;


--Join up all the data to explore
  select 
  e.id,
  e.first_name,
  e.last_name,
  d.name,
  p.title
from
  employees  e
left join 
  departments d on e.department_id = d.id
left JOIN
  employees_projects ep on e.id = ep.employee_id
left join 
  projects p on ep.project_id = p.id
  ;




--Find most expensive projects
with employees_projects_aggregation as (
select 
  ep.project_id,
  count(distinct employee_id) as num_employees
  from employees_projects ep
  group by ep.project_id
  having   count(distinct employee_id) > 1
)


select 
p.id,
p.title,
case 
  when p.title = 'Build a cool site' then 'Best Project Ever!'
  when p.title = 'Update TPS Reports' then 'bummer'
  else p.title
  end
  as project_opinion,

p.budget,
epa.num_employees
from
  projects p
left join
  employees_projects_aggregation epa on epa.project_id = p.id
where epa.num_employees>1
order by budget desc
;
