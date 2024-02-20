CREATE database Slesarev_MyBASE on primary
( name = N'Slesarev_MyBASE_mdf', filename = N'C:\Vanya\Study\Data_Bases\lab03\Slesarev_MyBASE_mdf.mdf', 
   size = 10240Kb, maxsize=128Mb, filegrowth=1024Kb),
( name = N'Slesarev_MyBASE_ndf', filename = N'C:\Vanya\Study\Data_Bases\lab03\Slesarev_MyBASE_ndf.ndf', 
   size = 10240KB, maxsize=64Mb, filegrowth=10%)
log on
( name = N'Slesarev_MyBASE_log', filename=N'C:\Vanya\Study\Data_Bases\lab03\Slesarev_MyBASE_log.ldf',       
   size=10240Kb,  maxsize=512Mb, filegrowth=10%)
/*filegroup FG1
( name = N'Slesarev_MyBASE_fg1_1', filename = N'C:\Vanya\Study\Data_Bases\lab03\Slesarev_MyBASE_fgq-1.ndf', 
   size = 10240Kb, maxsize=64Mb, filegrowth=10%),
( name = N'Slesarev_MyBASE_fg1_2', filename = N'C:\Vanya\Study\Data_Bases\lab03\Slesarev_MyBASE_fgq-2.ndf', 
   size = 10240Kb, maxsize=64Mb, filegrowth=10%)*/

ALTER database Slesarev_MyBASE
ADD filegroup groupTV;
ALTER database Slesarev_MyBASE
ADD filegroup groupOrders;
ALTER database Slesarev_MyBASE
ADD filegroup groupCustomers;

ALTER DATABASE Slesarev_MyBASE
ADD FILE (
    NAME = TV,
    FILENAME = 'C:\Vanya\Study\Data_Bases\lab03\TV.ndf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 1MB
) TO FILEGROUP groupTV;

ALTER DATABASE Slesarev_MyBASE
ADD FILE (
    NAME = Orders,
    FILENAME = 'C:\Vanya\Study\Data_Bases\lab03\Orders.ndf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 1MB
) TO FILEGROUP groupOrders;

ALTER DATABASE Slesarev_MyBASE
ADD FILE (
    NAME = Customers,
    FILENAME = 'C:\Vanya\Study\Data_Bases\lab03\Customers.ndf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 1MB
) TO FILEGROUP groupCustomers;

/*Учет стоимости рекламы. Заказчики помещают рекламу в телеэфире
в определенной передаче в определен-ный день. Информационные поля: 
Название передачи, Рейтинг, Стоимость минуты, Название фирмы-заказчика, 
Банковские реквизиты, Телефон, Контактное лицо, Вид рекламы, Дата, Длительность в минутах. 
*/

use Slesarev_MyBASE
CREATE table TVPrograms
(
	[program_name] nvarchar(50) primary key,
	minute_price int not null,
	rate float not null,
)
ON groupTV;

CREATE table Owners
(
	id int primary key,
	surname nvarchar(15) not null,
	[name] nvarchar(15) not null,
	thirdname nvarchar(15) not null,
	phone nvarchar(10) unique
)
ON groupCustomers;

CREATE table Customers
(
	company_name nvarchar(50) primary key,
	bank_account nvarchar(20) not null,
	[owner_id] int not null foreign key references Owners(id)
)
ON groupCustomers;

CREATE table Orders
(
	order_id int primary key,
	company_customer nvarchar(50) not null foreign key references Customers(company_name),
	[program_name] nvarchar(50) not null foreign key references TVPrograms([program_name]),
	advertising_type nvarchar(30) not null,
	duration int not null default 1,
	show_date date not null
)
ON groupOrders;


drop table Orders
drop table Customers
drop table Owners
drop table TVPrograms

DELETE from Orders
DELETE from TVPrograms
DELETE from Customers
DELETE from Owners


INSERT into TVPrograms([program_name], minute_price, rate)
Values('ОНТ', 25, 7.7),
('ТНТ', 78, 9.0),
('nickelodeon', 45, 8.5);

INSERT into Owners(id, surname, [name], thirdname, phone)
values(0, 'Vasya', 'Pupkin', 'Alexandrovich', 1234),
(1, 'Ivanov', 'Ivan', 'Ivanovich', 1111),
(2, 'Petrov', 'Petr', 'Petrovich', 2222);

INSERT into Customers(company_name, bank_account, [owner_id])
Values('PetrIndustries', 123456, 2),
('VasyaIncorporatet', 987766, 0);

INSERT into Orders(order_id,company_customer,[program_name],advertising_type,duration,show_date)
Values(1,'PetrIndustries','nickelodeon','реклама алкоголя',5,'10-05-2024'),
(2,'VasyaIncorporatet','ТНТ','реклама казино',3,'12-07-2024'),
(3,'PetrIndustries','ТНТ','реклама автомобиля',6,'24-06-2024');

use Slesarev_MyBASE
UPDATE TVPrograms set rate += 0.5 where minute_price > 40
SELECT * from TVPrograms

DELETE from Owners where id = 1
SELECT * from Owners
SELECT order_id,[program_name],show_date from Orders WHERE duration < 6
SELECT count(*) from Orders



