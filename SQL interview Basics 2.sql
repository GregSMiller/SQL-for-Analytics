--Given the tables above, find the following:

--a. The names of all salespeople that have an order with Samsonic.
/*
select 
    sls.name as salesname,
    cst.name as custname  --added to valiudate we are getting correct results
from 
    salesperson sls
inner join orders ord  
    on ord.salesperson_id = sls.id
inner join customer cst
    on cst.id = ord.cust_id
where
    cst.name = 'Samsonic'  -- could use upper and like if uncertain about data integrity
group by  sls.name, cst.name  --used to eliminate dup[licates if any]
*/

--b. The names of all salespeople that do not have any order with Samsonic.
/*
select 
    sls.name as salesname
--    ,cst.name as custname  --added to valiudate we are getting correct results
from 
    salesperson sls
inner join orders ord  
    on ord.salesperson_id = sls.id
inner join customer cst
    on cst.id = ord.cust_id
where
    cst.name not in ( 'Samsonic')  -- could use upper and like if uncertain about data integrity
group by  sls.name
--, cst.name  --used to eliminate dup[licates if any]
*/
    

--c. The names of salespeople that have 2 or more orders.
/*
select 
    sls.name as salesname,
    count( distinct ord.number) as ordercount
from 
    salesperson sls
inner join orders ord  
    on ord.salesperson_id = sls.id
group by  sls.name  
having count( distinct ord.number) >=2
*/
--d. Write a SQL statement to insert rows into a table called highAchiever(Name, Age), where a salesperson must have a salary of 100,000 or greater to be included in the table.
select 
    sls.name as salesname,
    sls.age ,
    sls.salary
from 
    salesperson sls
where 
sls.salary>=100000
