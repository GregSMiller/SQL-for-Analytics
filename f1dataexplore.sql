--View 10 rows of data
select * 
from formula1.f1laptimes limit 10;

--Sum lap times by driver
select driverid, sum(milliseconds)/1000 as totalseconds
from formula1.f1laptimes
group by driverid
order by totalseconds asc
