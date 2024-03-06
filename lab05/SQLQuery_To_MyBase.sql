

--task 1
USE Slesarev_MyBASE;
select Customers.company_name,Owners.[name]
from Customers,Owners
where Customers.owner_id = Owners.id and
	Customers.company_name in (select Orders.company_customer
		from Orders 
		where Orders.[program_name] like '%nick%')


--task 2
USE Slesarev_MyBASE;
select Customers.company_name,Owners.[name]
from Customers inner join Owners
on Customers.owner_id = Owners.id 
where Customers.company_name in (select Orders.company_customer
		from Orders 
		where Orders.[program_name] like '%nick%')


--task 3
USE Slesarev_MyBASE;
select Customers.company_name,Owners.[name],Orders.advertising_type
from Customers inner join Owners
on Customers.owner_id = Owners.id 
inner join Orders
on Orders.company_customer = Customers.company_name
where Customers.company_name in (select Orders.company_customer
	where [program_name] like '%nick%')


--task 4
select t1.company_customer,t1.advertising_type,t1.duration
from Orders as t1
where t1.duration = 
	(select top(1) t2.duration 
	from Orders as t2
	where t1.company_customer = t2.company_customer
	order by duration desc)


--task 5
select Customers.company_name from Customers
where not exists 
	(select * from Orders 
	where Customers.company_name = Orders.company_customer)


--task 6
select top 1
	(select avg(Orders.duration) from Orders
		where Orders.advertising_type like '%казино%')[average_duration]
from Orders


--task 7
select Orders.duration,Orders.advertising_type
from Orders 
where Orders.duration >= all 
	(select Orders.duration from Orders)


--task 8
select Orders.duration,Orders.advertising_type
from Orders
where Orders.duration >= any 
	(select Orders.duration 
	from Orders 
	where Orders.advertising_type like '%казино%')


