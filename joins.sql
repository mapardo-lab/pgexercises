--- JOINS
--- How can you produce a list of the start times for bookings by members named 'David Farrell'?
select 
	book.starttime
from cd.bookings book
inner join cd.members memb
on book.memid = memb.memid
where firstname = 'David' and surname = 'Farrell';

--- How can you produce a list of the start times for bookings for tennis courts, 
--- for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
select
	boo.starttime as start,
	fac.name
from cd.facilities fac
inner join cd.bookings boo
on fac.facid = boo.facid
where 
	boo.starttime >= '2012-09-21' and 
	boo.starttime < '2012-09-22' and 
	fac.name like '%Tennis Court%'
order by boo.starttime, name;

--- How can you output a list of all members who have recommended another member? 
--- Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
select
	mem2.firstname,
	mem2.surname
from cd.members mem1
inner join cd.members mem2
on mem1.recommendedby = mem2.memid
group by mem2.firstname, mem2.surname
order by mem2.surname, mem2.firstname;

--- How can you output a list of all members, including the individual who recommended them (if any)?
--- Ensure that results are ordered by (surname, firstname).
select
	mem.firstname as memfname,
	mem.surname as memsname,
	rmem.firstname as recfname,
	rmem.surname as recsname
from cd.members mem
left join cd.members rmem
on mem.recommendedby = rmem.memid
order by memsname, memfname;

--- How can you produce a list of all members who have used a tennis court? 
--- Include in your output the name of the court, and the name of the member 
--- formatted as a single column. Ensure no duplicate data, and order by the 
--- member name followed by the facility name.
select
	distinct concat(mem.firstname, ' ', mem.surname) as member,
	fac.name as facility
from cd.bookings boo
inner join cd.facilities fac
on boo.facid = fac.facid
inner join cd.members mem
on mem.memid = boo.memid
where fac.name like '%Tennis Court%'
order by member, facility;

--- How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? 
--- Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user 
--- is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, 
--- and the cost. Order by descending cost, and do not use any subqueries.
select
	mem.firstname || ' ' || mem.surname as member,
	fac.name,
	case
		when mem.memid = 0 then fac.guestcost*boo.slots
		else fac.membercost*boo.slots
	end as cost
from cd.bookings boo
	inner join cd.facilities fac
	on boo.facid = fac.facid
	inner join cd.members mem
	on boo.memid = mem.memid
where
	((mem.memid = 0 and fac.guestcost*boo.slots > 30) or
	(mem.memid != 0 and fac.membercost*boo.slots > 30)) and
	boo.starttime >= '2012-09-14' and
	boo.starttime < '2012-09-15'
order by cost desc;

--- How can you output a list of all members, including the individual who recommended them (if any), 
--- without using any joins? Ensure that there are no duplicates in the list, and that each 
--- firstname + surname pairing is formatted as a column and ordered.
select
	firstname || ' ' || surname as member,
	recommendedby
from cd.members
order by member;

