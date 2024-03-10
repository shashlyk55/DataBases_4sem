use Slesarev_MyBASE
--task 01
select TVPrograms.[program_name],
	max(Orders.duration)[max_duration],
	min(Orders.duration)[min_duration],
	avg(Orders.duration)[avg_duration]
from Orders inner join TVPrograms
on Orders.[program_name] = TVPrograms.[program_name]
group by TVPrograms.[program_name]


--task 02
select Customers.company_name,
	max(Orders.duration)[max_duration],
	min(Orders.duration)[min_duration],
	avg(Orders.duration)[avg_duration],
	sum(Orders.duration)[sum_duration]
from Orders inner join Customers
on Orders.company_customer = Customers.company_name
group by Customers.company_name


--task 03
select *
from (select 
	/*case when Orders.duration between 3 and 5 
	then Orders.company_customer 
	end[customer],*/
	case when Orders.duration between 3 and 5 
	then Orders.duration 
	end[duration],
	case when Orders.duration between 3 and 5 
	then count(Orders.duration) 
	end[count]
	from Orders
	group by Orders.duration) as t
	--group by Orders.company_customer,Orders.duration) as t
where t.count is not null
order by t.count


--task 04



