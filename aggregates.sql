--- AGGREGATES
--- Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.
--- Subquery version
select
	(select count(memid) from cd.members) as count,
	firstname,
	surname
from cd.members
order by joindate;

--- CTE version
with total_count as 
(select
	count(memid) as count
from cd.members
)
select
	(select * from total_count) as count,
	firstname,
	surname
from cd.members
order by joindate;

--- Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
select
	row_number() over(order by memid) as row_number,
 	firstname,
 	surname
from cd.members
order by joindate;



with total_slots_fac as (
 select
  
)

--- Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
with total_slots as (
select
  	facid,
	sum(slots) total
from cd.bookings
group by facid
),
max_slots as(
select
  total
from total_slots
order by total desc
limit 1
)
select
*
from total_slots
where total = (select * from max_slots);
