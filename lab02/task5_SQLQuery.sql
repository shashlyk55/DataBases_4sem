CREATE DATABASE [Slesarev_MyBase]

ON PRIMARY
(
	NAME = N'Slesarev_MyBase',
	FILENAME = N'D:\BSTU\SQLProjects\lab02\Slesarev_MyBase.mdf',
	SIZE = 5120KB, MAXSIZE = 10240KB, FILEGROWTH = 1024KB
)

LOG ON
(
	NAME = N'Slesarev_MyBase_log',
	FILENAME = N'D:\BSTU\SQLProjects\lab02\Slesarev_MyBase_log.ldf',
	SIZE = 5120KB, MAXSIZE = 20480, FILEGROWTH = 1024KB
)
GO

USE [Slesarev_MyBase]

-- Склад - главная табоица
CREATE TABLE Storage_table
(
	Adress nvarchar(50) PRIMARY KEY CHECK(Adress!='') not null,
	Size int IDENTITY(0,1) CHECK(Size > 0) not null,
);
-- Товар зависит от склада
CREATE TABLE Product_table
(
	[Name] nvarchar(20) PRIMARY KEY not null,
	Price real CHECK(Price > 0) not null,
	Quantity int CHECK(Quantity > 0) not null,
	[Description] nvarchar(300) CHECK([Description]!='') null,
	Storage_location nvarchar(50) CHECK(Storage_location!='') not null,
	[Owner] nvarchar(40) CHECK([Owner]!='') not null,
	Storage_adress nvarchar(50) CHECK(Storage_adress!='') not null REFERENCES Storage_table (Adress),
);

-- Клиент зависит от товара
CREATE TABLE Client_table
(
	Client_name nvarchar(40) PRIMARY KEY CHECK(Client_name!='') not null,
	Phone nvarchar(10) UNIQUE CHECK(Phone!='') not null,
	Transaction_date date not null,

	FOREIGN KEY (Client_name) REFERENCES Product_table([Owner]),
);



