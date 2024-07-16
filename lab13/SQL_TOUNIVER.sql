use UNIVER;

--task 01
drop procedure PSUBJECT

go
create procedure PSUBJECT
as 
begin
	declare @s int = (select COUNT(*) from [SUBJECT]);
	select * from [SUBJECT]
	return @s
end;

declare @count int = 0
exec @count = PSUBJECT
print 'колич строк = ' + cast(@count as varchar(3))


--task 02
declare @rows int = 0
exec @rows = PSUBJECT @p = 'ИСиТ', @c = 0
print 'колич строк = ' + cast(@rows as varchar(3)) 


--task 03
drop table #tempSUBJECT
create table #tempSUBJECT
(
[SUBJECT] char(10),
SUBJECT_NAME nvarchar(100),
PULPIT char(20)
)
go
insert #tempSUBJECT exec PSUBJECT @p = 'ИСиТ'
select * from #tempSUBJECT


--task 04
drop procedure PAUDITORIUM_INSERT

create procedure PAUDITORIUM_INSERT 
	@a char(20),@n varchar(50),@c int = 0, @t char(10)
as declare @rc int = 1
begin try
	insert into AUDITORIUM (AUDITORIUM,AUDITORIUM_NAME,AUDITORIUM_CAPACITY,AUDITORIUM_TYPE)
	values (@a,@n,@c,@t)
	return @rc
end try
begin catch
	print 'номер ошибки: '+cast(error_number() as varchar(6))
	print 'сообщение: '+error_message()
	print 'уровень: '+cast(error_severity() as varchar(6))
	print 'метка: '+cast(error_state() as varchar(8))
	print 'номер строки: '+cast(error_line() as varchar(8))
	if(error_procedure() is null)
	print 'имя процедуры: '+error_procedure()
	RAISERROR('ошибка добавления в таблицу AUDITORIUM', 16,1)
	return -1
end catch
	
delete from AUDITORIUM where AUDITORIUM = '123-4'

declare @rc int
exec @rc = PAUDITORIUM_INSERT @a = '123-4',@n = '123-4',@c = 11,@t = 'ЛБ-К'
print 'код шибки = '+cast(@rc as varchar(3))



--task 05
drop procedure SUBJECT_REPORT
deallocate CursorSubject

create procedure SUBJECT_REPORT @p char(10)
as declare @rc int = 0
begin try
	declare @sub char(20),@s char(300) = ' ';
	declare CursorSubject cursor for select [SUBJECT] from [SUBJECT] where PULPIT = @p
	if not exists (select [SUBJECT] from [SUBJECT] where PULPIT = @p)
		raiserror('ошибка',11,1)
	else
		open CursorSubject
		fetch CursorSubject into @sub
		print 'Предметы на кафедре ' + @p
		while @@FETCH_STATUS = 0
		begin
			set @s = RTRIM(@sub) + ',' + @s
			set @rc = @rc + 1
			fetch CursorSubject into @sub
		end
	print @s
	close CursorSubject
	deallocate CursorSubject
	return @rc
end try
begin catch
	deallocate CursorSubject
	print 'ошибка в параметрах'
	if error_procedure() is not null
		print 'имя процедуры: ' + error_procedure()
	return @rc
end catch

declare @rc int 
exec @rc = SUBJECT_REPORT @p = 'ИСиТ'
print 'колич предметов = '+cast(@rc as varchar(3))
	

--task 06
drop procedure PAUDITORIUM_INSERTIX
delete from AUDITORIUM where AUDITORIUM.AUDITORIUM_TYPE = 'custom'
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'custom'

create procedure PAUDITORIUM_INSERTIX 
	@a char(20),@n varchar(50),@c int = 0,@t char(10),@tn varchar(50)
as declare @rc int = 1
begin try
	set transaction isolation level SERIALIZABLE
	begin tran
	insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE,AUDITORIUM_TYPENAME) values(@t,@tn)

	exec @rc = PAUDITORIUM_INSERT @a,@n,@c,@t
	 
	commit tran
	return @rc
end try
begin catch
	print 'номер ошибки: '+cast(error_number() as varchar(6))
	print 'сообщение: '+error_message()
	print 'уровень: '+cast(error_severity() as varchar(6))
	print 'метка: '+cast(error_state() as varchar(8))
	print 'номер строки: '+cast(error_line() as varchar(8))
	if(error_procedure() is null)
	print 'имя проццедуры: '+error_procedure()
	if @@TRANCOUNT > 0 rollback tran
	return -1
end catch

declare @rc int;
exec @rc = PAUDITORIUM_INSERTIX @a = '456-7',@n = '456-7',@c = 9,@t = 'custom',@tn = 'customType'
print 'код шибки = '+cast(@rc as varchar(3))


--dop
drop procedure MakeOtlichnik
create procedure MakeOtlichnik @id int
as begin 
	update PROGRESS set PROGRESS.NOTE = 10 where PROGRESS.IDSTUDENT = @id;
end

exec MakeOtlichnik @id = 1016




