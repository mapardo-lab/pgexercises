--- STRING
--- Output the names of all members, formatted as 'Surname, Firstname'
select
	concat(surname,', ',firstname) as name
from cd.members

--- Find all facilities whose name begins with 'Tennis'. Retrieve all columns.
select *
from cd.facilities
where name like 'Tennis%'

--- Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. Retrieve all columns.
select *
from cd.facilities
where lower(name) like 'tennis%'

--- You've noticed that the club's member table has telephone numbers with very inconsistent formatting. 
--- You'd like to find all the telephone numbers that contain parentheses, returning the member ID and 
--- telephone number sorted by member ID.
select
	memid,
	telephone
from cd.members
where telephone like '(%)%'
order by memid

--- The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a numeric type.
--- Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with leading zeroes. 
--- Order by the new zip code.
select
	lpad(cast(zipcode as text),5,'0') as zip
from cd.members
order by zip

--- You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. 
--- Sort by the letter, and don't worry about printing out a letter if the count is 0.
with extract_first as (
select
	substring(surname,1,1) as first_letter
from cd.members
)
select
	first_letter,
	count(first_letter)
from extract_first
group by first_letter
order by first_letter

--- The telephone numbers in the database are very inconsistently formatted. You'd like to print a 
--- list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.
select
	memid,
	regexp_replace(telephone,'[-() ]','','gin') as telephone_rep
from cd.members
order by memid
