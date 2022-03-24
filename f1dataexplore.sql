--View 10 rows of data
select * 
from formula1.f1laptimes limit 10;

--Sum lap times by driver
select 
concat(drivers."forename",drivers."surname") as name, 
time.driverid, 
sum(time.milliseconds)/1000 as totalseconds,
count (distinct raceid) as races,
count (lap) as laps,
sum(time.milliseconds/1000) /count (lap) as avglaptime
from formula1.f1laptimes time
inner join drivers on time.driverid = drivers.driverid 
group by 1,2
