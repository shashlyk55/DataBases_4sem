---task 01
USE Slesarev_MyBase;
SELECT Customers.owner_id,
		Owners.surname,
		Owners.name
	from Customers inner join Owners
	on Customers.owner_id = Owners.id

---task 02
USE Slesarev_MyBase;
SELECT Orders.advertising_type,
		TVPrograms.program_name
	from Orders inner join TVPrograms
	on Orders.program_name = TVPrograms.program_name
		and Orders.advertising_type like '%казино%'

---task03
USE Slesarev_MyBase;
SELECT Customers.company_name,
		TVPrograms.minute_price,
		TVPrograms.program_name,
		Customers.bank_account,
		case
			when TVPrograms.minute_price between 1 and 30 then 'enough money'
			else 'not enough money'
		end Have_money
	from Orders 
	inner join TVPrograms on Orders.program_name = TVPrograms.program_name
	inner join Customers on Orders.company_customer = Customers.company_name
		order by TVPrograms.minute_price

---task04
USE Slesarev_MyBase;
SELECT TVPrograms.program_name,
		isnull(Orders.advertising_type, '***') advertising_type
	from TVPrograms left outer join Orders 
	on TVPrograms.program_name = Orders.program_name
	
---task05
USE Slesarev_MyBase;
SELECT TVPrograms.program_name,
		Orders.advertising_type
	from TVPrograms full outer join Orders 
	on TVPrograms.program_name = Orders.program_name

SELECT TVPrograms.program_name,
		Orders.advertising_type
	from TVPrograms full outer join Orders 
	on TVPrograms.program_name = Orders.program_name
		where Orders.advertising_type is null

SELECT TVPrograms.program_name,
		Orders.advertising_type
	from TVPrograms full outer join Orders 
	on TVPrograms.program_name = Orders.program_name
		where Orders.advertising_type is not null

---task06
USE Slesarev_MyBase;
SELECT Customers.owner_id,
		Owners.surname,
		Owners.name
	from Customers cross join Owners
		where Customers.owner_id = Owners.id
