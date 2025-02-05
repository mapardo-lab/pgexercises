--- DATE
--- Produce a timestamp for 1 a.m. on the 31st of August 2012.
select '2012-08-31 01:00:00'::timestamp as timestamp

--- Find the result of subtracting the timestamp '2012-07-30 01:00:00' from the timestamp '2012-08-31 01:00:00'
select '2012-08-31 01:00:00'::timestamp - '2012-07-30 01:00:00'::timestamp as interval

--- Produce a list of all the dates in October 2012. They can be output as a timestamp (with time set to midnight) or a date.
select generate_series('2012-10-01'::date, '2012-10-31'::date,'1 day')

--- Get the day of the month from the timestamp '2012-08-31' as an integer.
select extract(day from '2012-08-31'::date) as date_part

--- Work out the number of seconds between the timestamps '2012-08-31 01:00:00' and '2012-09-02 00:00:00'
select round(extract(epoch from ('2012-09-02 00:00:00'::timestamp - 
						   '2012-08-31 01:00:00'::timestamp))) as date_part

--- For each month of the year in 2012, output the number of days in that month. 
--- Format the output as an integer column containing the month of the year, and a 
--- second column containing an interval data type. 
with month_serie as (
select *
from generate_series('2012-01-01'::date, 
					 '2012-12-01'::date, 
					 '1 month')
)
select
	extract(month from  generate_series) as month,
	(generate_series + '1 month'::interval) - generate_series as length
from month_serie


--- For any given timestamp, work out the number of days remaining in the month. 
--- The current day should count as a whole day, regardless of the time. 
--- Use '2012-02-11 01:00:00' as an example timestamp for the purposes of making the answer. 
--- Format the output as a single interval value.
select (date_trunc('month', '2012-02-11 01:00:00'::timestamp) + 
		'1 month'::interval) - date_trunc('day','2012-02-11 01:00:00'::timestamp) as remaining

--- Return a list of the start and end time of the last 10 bookings 
--- (ordered by the time at which they end, followed by the time at which they start) in the system.
select
	starttime,
	starttime + '30 minute'::interval*slots as endtime
from cd.bookings
order by endtime desc , starttime desc
limit 10

--- Return a count of bookings for each month, sorted by month
with date_truncated as (
select 
	date_trunc('month',starttime) as month
from cd.bookings
)
select
	month,
	count(month) as count
from date_truncated
group by month
order by month

--- Work out the utilisation percentage for each facility by month, sorted by name and month, 
--- rounded to 1 decimal place. Opening time is 8am, closing time is 8.30pm. You can treat every 
--- month as a full month, regardless of if there were some dates the club was not open. 
with facid_month_util as(
select
	facid,
	date_trunc('month',starttime) as month,
	sum(slots)*0.5 as month_util
from cd.bookings
group by facid, month
), facid_month_total_util as (
select
	facid,
  	month,
  	(extract(epoch from 
			 (month + '1 month'::interval) - month)/3600/24)*12.5 as month_total,
  	month_util
from facid_month_util
)
select 
	name,
	month,
	round(month_util/month_total*100,1) as utilisation
from facid_month_total_util mon
inner join cd.facilities fac
on mon.facid = fac.facid
order by name, month

