--- AGGREGATES
--- For our first foray into aggregates, we're going to stick to something simple. 
--- We want to know how many facilities exist - simply produce a total count.
select
	count(facid) as count
from cd.facilities;

--- Produce a count of the number of facilities that have a cost to guests of 10 or more.
select
	count(facid) as count
from cd.facilities
where guestcost >=10;

--- Produce a count of the number of recommendations each member has made. Order by member ID.
select
	recommendedby,
	count(memid) as count
from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby;

--- Produce a list of the total number of slots booked per facility. 
--- For now, just produce an output table consisting of facility id and slots, sorted by facility id.
select
	facid,
	sum(slots) as "Total Slots"
from cd.bookings
group by facid
order by facid;

--- Produce a list of the total number of slots booked per facility in the month of September 2012. 
--- Produce an output table consisting of facility id and slots, sorted by the number of slots.
select
	facid,
	sum(slots) as "Total Slots"
from cd.bookings
where 
	starttime >= '2012-09-01' and
	starttime < '2012-10-01'
group by facid
order by "Total Slots";

--- Produce a list of the total number of slots booked per facility per month in the year of 2012. 
--- Produce an output table consisting of facility id and slots, sorted by the id and month.
select
	facid,
	extract(month from starttime) as month,
	sum(slots) as "Total Slots"
from cd.bookings
where starttime >= '2012-01-01' and starttime < '2013-01-01'
group by facid, month
order by facid, month;

--- Find the total number of members (including guests) who have made at least one booking.
select
	count(distinct mem.memid) as count
from cd.members mem
inner join cd.bookings boo
on mem.memid = boo.memid;

--- Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting 
--- of facility id and slots, sorted by facility id.
select
	facid,
	sum(slots) as "Total Slots"
from cd.bookings
group by facid
having sum(slots) > 1000
order by facid;

--- Produce a list of facilities along with their total revenue. The output table should consist of facility 
--- name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
with fac_revenue as(
 	select
		fac.name,
		case
			when boo.memid = 0 then boo.slots*fac.guestcost
			else boo.slots*fac.membercost
		end as revenue
	from cd.bookings boo
	inner join cd.facilities fac
	on boo.facid = fac.facid
)
select
	name,
	sum(revenue) as revenue
from fac_revenue
group by name
order by revenue;

--- Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of 
--- facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
select
	fac.name,
	sum(boo.slots * case when boo.memid = 0 then fac.guestcost
	   else fac.membercost end) as revenue
from cd.bookings boo
inner join cd.facilities fac
on boo.facid = fac.facid
group by fac.name
having sum(boo.slots * case when boo.memid = 0 then fac.guestcost
	   else fac.membercost end) < 1000
order by revenue;

--- Output the facility id that has the highest number of slots booked. For bonus points, try a version 
--- without a LIMIT clause. This version will probably look messy!
select
	facid,
	sum(slots) as "Total Slots"
from cd.bookings
group by facid
order by "Total Slots" desc
limit 1;

--- Produce a list of the total number of slots booked per facility per month in the year of 2012. 
--- In this version, include output rows containing totals for all months per facility, and a total 
--- for all months for all facilities. The output table should consist of facility id, month and slots, 
--- sorted by the id and month. When calculating the aggregated values for all months and all facids, 
--- return null values in the month and facid columns.
with facid_month_slots as (
  select
	facid,
	extract(month from starttime) as month,
	sum(slots) as slots
from cd.bookings
where starttime >= '2012-01-01' and starttime < '2013-01-01'
group by facid, month
order by facid, month
),
total_slots as (
 select
	sum(slots) as slots
from facid_month_slots
),
facid_slots as (
 select
	facid,
	sum(slots) as slots
from facid_month_slots
group by facid
)
select
	facid,
	month,
	slots
from facid_month_slots
union
select
	facid,
	null as month,
	slots
from facid_slots
union
select
	null as facid,
	null as month,
	slots
from total_slots
order by facid, month;

--- Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. 
--- The output table should consist of the facility id, name, and hours booked, sorted by facility id. 
--- Try formatting the hours to two decimal places.
select
	fac.facid,
	fac.name,
	round(sum(boo.slots)/2.0,2) as "Total Hours"
from cd.bookings boo
inner join cd.facilities fac
on boo.facid = fac.facid
group by fac.facid
order by facid, name, "Total Hours";

--- Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
select
	mem.surname,
	mem.firstname,
	mem.memid,
	min(boo.starttime)
from cd.members mem
inner join cd.bookings boo
on mem.memid = boo.memid
where boo.starttime >= '2012-09-01'
group by mem.surname, mem.firstname, mem.memid
order by mem.memid;

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

--- Produce a list of members (including guests), along with the number of hours they've booked in facilities, 
--- rounded to the nearest ten hours. Rank them by this rounded figure, producing output of first name, surname, 
--- rounded hours, rank. Sort by rank, surname, and first name.
with member_hours as (
  	select
		mem.firstname,
		mem.surname,
		round(sum(slots)/20.0)*10 as hours
	from cd.bookings boo
	inner join cd.members mem
	on boo.memid = mem.memid
	group by mem.firstname, mem.surname
)
select
	firstname,
	surname,
	hours,
	rank() over(order by hours desc) as rank
from member_hours
order by rank, surname, firstname;

--- Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank, 
--- sorted by rank and facility name.
with fac_name_revenue as (
 select
 	fac.name,
  	sum(boo.slots * (case
		when boo.memid = 0 then fac.guestcost
		else fac.membercost end)) as total_revenue
 from cd.bookings boo
 inner join cd.facilities fac
 on fac.facid = boo.facid
 group by fac.name
 ), fac_name_rank as (
 select
 	name,
	rank() over(order by total_revenue desc) as rank
 from fac_name_revenue
 )
 select
 	name,
	rank
 from fac_name_rank
 where rank <= 3;

--- Classify facilities into equally sized groups of high, average, and low based on their revenue. 
--- Order by classification and facility name.
--- HINT Investigate the NTILE window function.
with fac_name_revenue as (
 select
 	fac.name,
  	sum(boo.slots * (case
		when boo.memid = 0 then fac.guestcost
		else fac.membercost end)) as total_revenue
 from cd.bookings boo
 inner join cd.facilities fac
 on fac.facid = boo.facid
 group by fac.name
 order by total_revenue desc
 ), fac_group_revenue as (
 select 
 	name,
	ntile(3) over() as group_revenue
 from fac_name_revenue
 order by group_revenue, name
 )
 select 
 	name,
	case
		when group_revenue = 1 then 'high'
		when group_revenue = 2 then 'average'
		when group_revenue = 3 then 'low'
	end as revenue
 from fac_group_revenue
 ;


--- Based on the 3 complete months of data so far, calculate the amount of time each facility 
--- will take to repay its cost of ownership. Remember to take into account ongoing monthly maintenance. 
--- Output facility name and payback time in months, order by facility name. Don't worry about differences 
--- in month lengths, we're only looking for a rough value here!
with fac_revenue_cost as (
 select
  	fac.facid,
 	fac.name,
  	fac.initialoutlay,
  	fac.monthlymaintenance *3 as maintenance_3,
  	sum(boo.slots * (case
		when boo.memid = 0 then fac.guestcost
		else fac.membercost end)) as total_revenue_3
 from cd.bookings boo
 inner join cd.facilities fac
 on fac.facid = boo.facid
 group by fac.name, fac.facid
 )
 select
 	name,
	initialoutlay*3/(total_revenue_3 - maintenance_3) as months
 from fac_revenue_cost
 order by name;
 
--- For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. 
--- Output should contain date and revenue columns, sorted by the date. Remember to account for the possibility 
--- of a day having zero revenue. This one's a bit tough, so don't be afraid to check out the hint!
with day_revenue as (
 select
  	to_char(boo.starttime,'YYYY-MM-DD') as date,
  	sum(boo.slots * (case
		when boo.memid = 0 then fac.guestcost
		else fac.membercost end)) as revenue
 from cd.bookings boo
 inner join cd.facilities fac
 on fac.facid = boo.facid
 group by date
), days as (
 select to_char(generate_series('2012-07-01'::date,'2012-10-12'::date,'1 day'),
				'YYYY-MM-DD') as date 
), day_revenue_complete as (
  	select
		days.date,
		coalesce(revenue,0) as revenue
	from days as days
	left join day_revenue dayr
	on days.date = dayr.date
	order by date
), revenue_15day as (
select
    date,
    avg(revenue) over (
        order by date
        rows between 14 preceding and current row
    ) as revenue
from day_revenue
order by date asc
)
select *
from revenue_15day
where date >= '2012-08-01' and date < '2012-09-01'
--- HINT You'll need to generate a list of days: check out GENERATE_SERIES for that. 
--- You can then solve this problem using aggregate functions or window functions.



