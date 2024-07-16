use Slesarev_MyBASE;

--task 01
set nocount on
if(exists (select * from sys.objects where OBJECT_ID = object_id('DBO.TABLE_T1')))
	drop table DBO.TABLE_T1

declare @c int, @flag char = 'c'
set IMPLICIT_TRANSACTIONS ON
create table DBO.TABLE_T1(id int, val int)
	insert DBO.TABLE_T1 values (1,12),(2,44),(3,53)
	set @c = (select count(*) from DBO.TABLE_T1)
	print 'строк в таблице TABLE_T1: ' + cast(@c as varchar(5))
	if @flag='c' commit
	else rollback
set IMPLICIT_TRANSACTIONS OFF

if exists (select * from sys.objects where OBJECT_ID = object_id('DBO.TABLE_T1'))
	print 'таблица TABLE_T1 есть'
else print 'таблицы TABLE_T1 нету'


--task 02
begin try
	begin tran
		update dbo.TABLE_T1 set val *= 2 where id = 2
		insert dbo.TABLE_T1 values (4,11)
		insert dbo.TABLE_T1 values ('jhhj',71)
		delete dbo.TABLE_T1 where id = 1
	commit tran
	print 'транзакция завершена'
end try
begin catch
	print 'ошибка: ' + case
	when error_number() = 2627 and patindex('%TABLE_T1%', error_message()) > 0
	then 'ошибка изменения данных в таблице'
	else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@TRANCOUNT > 0 rollback tran
end catch


--task 03
use UNIVER;
declare @point varchar(32)
begin try
	begin tran
		update PROGRESS set NOTE += 1 where SUBJECT = 'ОАиП' and NOTE > 6 and NOTE < 8
		insert PROGRESS values ('КГ',1018,'2013-05-06',5)
		set @point = 'p1' save tran @point
		insert PROGRESS values ('СУБД',1017,'2013-12-01',7)
		set @point = 'p2' save tran @point
		delete PROGRESS where SUBJECT = 'ТРИ'
	commit tran
	print 'транзакция завершена успешно'
end try
begin catch
	print 'ошибка: '+case 
		when error_number() = 2627 and patindex('%TABLE_T1%',error_message()) > 0
		then 'ошибка изменения данных в таблице'
		else 'неизвестная ошибка: '+cast(error_number() as varchar(5))+error_message()
		end
	if @@TRANCOUNT > 0
	begin
		print 'контрольная точка: '+@point
		rollback tran @point
		commit tran
	end
end catch


--task 04
--A--
set transaction isolation level read uncommitted  
begin transaction
---t1---
select @@SPID, 'insert SUBJECT' 'result',* from PROGRESS where PROGRESS.[SUBJECT] = 'БД'
commit
---t2---
--B--
begin transaction
select @@SPID
--delete from SUBJECT where SUBJECT = 'БД'
insert SUBJECT values ('БД','Базы данных','ИСИТ') 
update PROGRESS set [SUBJECT] = 'БД' where [SUBJECT] = 'СУБД'
--update PROGRESS set [SUBJECT] = 'СУБД' where [SUBJECT] = 'БД'
---t1---
---t2---
rollback;


--task 05
--A--
set transaction isolation level read committed 
begin transaction
select count(*) from PROGRESS where SUBJECT = 'КГ'
---t1---
---t2---
select 'update PROGRESS' 'result', count(*) from PROGRESS where SUBJECT = 'КГ'
commit
--B--
begin transaction
---t1---
update PROGRESS set SUBJECT = 'ТОПИ' where IDSTUDENT = 1047
--update PROGRESS set SUBJECT = 'КГ' where IDSTUDENT = 1047
commit
---t2---


--task 06
--A--
set transaction isolation level repeatable read
begin transaction 
--select SUBJECT from PROGRESS where PROGRESS.IDSTUDENT = 1023
select * from PROGRESS where PROGRESS.SUBJECT = 'СУБД'
---t1---
---t2---
--select SUBJECT from PROGRESS where PROGRESS.IDSTUDENT = 1023 
select * from PROGRESS where PROGRESS.SUBJECT = 'СУБД'
commit
--B--
begin transaction
---t1--- 
update PROGRESS set SUBJECT = 'СУБД' where IDSTUDENT = 1023
--update PROGRESS set SUBJECT = 'КГ' where IDSTUDENT = 1023
commit
---t2---


--task 07
--A--
set transaction isolation level serializable
begin transaction
delete PROGRESS where IDSTUDENT = 1001
insert PROGRESS values ('ОАиП',1001,'2013-10-01',8)
update PROGRESS set SUBJECT = 'ДМ' where IDSTUDENT = 1001
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t1---
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t2---
commit
--B--
set transaction isolation level read committed
begin transaction
delete PROGRESS where IDSTUDENT = 1001
insert PROGRESS values ('ОАиП',1001,'2013-10-01',8)
update PROGRESS set SUBJECT = 'ДМ' where IDSTUDENT = 1001
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t1---
commit
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t2---


--task 08
begin try
	begin tran
		insert AUDITORIUM_TYPE values ('qwe','qwerty')
		--delete AUDITORIUM_TYPE where AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'qwe'
		begin try
			begin tran
				insert AUDITORIUM values('888-8','qwe',99,'888-8')			
				--delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '888-8'
			commit
		end try
		begin catch
			print 'ошибка вложенной транзакции'
			print cast(error_number() as varchar(5)) + error_message()
			if @@TRANCOUNT > 1 rollback tran
		end catch
		commit tran
end try
begin catch
	print 'ошибка внешней транзакции'
	print cast(error_number() as varchar(5)) + error_message()
	if @@TRANCOUNT > 0 rollback tran
end catch
	 

