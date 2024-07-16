use UNIVER


--task 1
drop table TR_AUDIT
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20) check (STMT in ('INS','DEL','UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)

drop trigger TR_Teacher_Ins
create trigger TR_Teacher_Ins on TEACHER after INSERT
as declare @t char(10), @tn varchar(100), @g char(1), @p char(20), @info varchar(300)
set @t = (select TEACHER from inserted)
set @tn = (select TEACHER_NAME from inserted)
set @g = (select GENDER from inserted)
set @p = (select PULPIT from inserted)
set @info = @t + '' + @tn + '' + @g + '' + @p
insert into TR_AUDIT(STMT,TRNAME,CC) values ('INS','TR_Teacher_Ins',@info)
return

insert into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) values('ШМН','Шиман Дмитрий Васильевич','м','ИСиТ')
select * from TR_AUDIT


--task 2
drop trigger TR_Teacher_Del
create trigger TR_Teacher_Del on TEACHER after DELETE
as declare @t char(10)
	set @t = (select TEACHER from deleted)
	insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_Teacher_Del',@t)
return

delete TEACHER where TEACHER.TEACHER = 'ШМН'
select * from TR_AUDIT


--task 3
drop trigger TR_Teacher_Upd
create trigger TR_Teacher_Upd on TEACHER after UPDATE
as declare @tBf char(10), @tnBf varchar(100), @gBf char(1), @pBf char(20), @info char(300)
	set @tBf = (select TEACHER from inserted)
	set @tnBf = (select TEACHER_NAME from inserted)
	set @gBf = (select GENDER from inserted)
	set @pBf = (select PULPIT from inserted)

   declare @tAf char(10), @tnAf varchar(100), @gAf char(1), @pAf char(20)
	 set @tAf = (select TEACHER from deleted)
	 set @tnAf = (select TEACHER_NAME from deleted)
	 set @gAf = (select GENDER from deleted)
	 set @pAf = (select PULPIT from deleted)

	set @info = @tBf + '' + @tnBf + ' ' + @gBf + ' ' + @pBf + '->' + @tAf + '' + @tnAf + ' ' + @gAf + ' ' + @pAf 
	insert into TR_AUDIT(STMT,TRNAME,CC) values ('UPD','TR_Teacher_Ins',@info)
return 

select * from TEACHER
update TEACHER set TEACHER.GENDER = 'м' where TEACHER.TEACHER = 'ШМН' 
select * from TR_AUDIT


-- task 4
drop trigger TR_TEACHER
create trigger TR_TEACHER on TEACHER after INSERT,DELETE,UPDATE
as declare @ins int = (select count(*) from inserted),
		@del int = (select count(*) from deleted);
	if @ins > 0 and @del = 0
	begin
		declare @t char(10), @tn varchar(100), @g char(1), @p char(20), @insertInfo varchar(300)
		print 'Собятие INSERT';
		set @t = (select TEACHER from inserted)
		set @tn = (select TEACHER_NAME from inserted)
		set @g = (select GENDER from inserted)
		set @p = (select PULPIT from inserted)
		set @insertInfo = @t + '' + @tn + '' + @g + '' + @p
		insert into TR_AUDIT(STMT,TRNAME,CC) values ('INS','TR_Teacher_Ins',@insertInfo)
	end
	else
	if @ins = 0 and @del > 0
	begin
		declare @deleteInfo char(10)
		print 'Событие DELETE';
		set @deleteInfo = (select TEACHER from deleted)
		insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_Teacher_Del',@deleteInfo)
	end
	else
	if @ins > 0 and @del > 0
	begin
		declare @tBf char(10), @tnBf varchar(100), @gBf char(1), @pBf char(20), @updateInfo char(300)
		set @tBf = (select TEACHER from inserted)
		set @tnBf = (select TEACHER_NAME from inserted)
		set @gBf = (select GENDER from inserted)
		set @pBf = (select PULPIT from inserted)

		declare @tAf char(10), @tnAf varchar(100), @gAf char(1), @pAf char(20)
		set @tAf = (select TEACHER from deleted)
		set @tnAf = (select TEACHER_NAME from deleted)
		set @gAf = (select GENDER from deleted)
		set @pAf = (select PULPIT from deleted)

		set @updateInfo = @tBf + '' + @tnBf + ' ' + @gBf + ' ' + @pBf + '->' + @tAf + '' + @tnAf + ' ' + @gAf + ' ' + @pAf 
		insert into TR_AUDIT(STMT,TRNAME,CC) values ('UPD','TR_Teacher_Upd',@updateInfo)
	end
return

select * from TEACHER

select * from TR_AUDIT
delete TEACHER where TEACHER.TEACHER = 'ШМН'
insert into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) values('ШМН','Шиман Дмитрий Васильевич','м','ИСиТ')
update TEACHER set TEACHER.TEACHER_NAME = 'ШАМАН' where TEACHER.TEACHER = 'ШМН'


-- task 05
select * from TEACHER
insert into TEACHER(TEACHER,TEACHER_NAME,GENDER,PULPIT) values('ЯКБ','Ксения Якубенко','ж','ИСиТ')
update TEACHER set TEACHER.GENDER = 'мж' where TEACHER.TEACHER = 'ЯКБ'
delete TEACHER where TEACHER.TEACHER = 'ЯКБ'
select * from TR_AUDIT


-- task 06
drop trigger TR_TEACHER_DEL1
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE
as declare @t char(10)
	set @t = (select TEACHER from deleted)
	insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_TEACHER_DEL1',@t)
return

drop trigger TR_TEACHER_DEL2
create trigger TR_TEACHER_DEL2 on TEACHER after DELETE
as declare @t char(10)
	set @t = (select TEACHER from deleted)
	insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_TEACHER_DEL2',@t)
return

drop trigger TR_TEACHER_DEL3
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE
as declare @t char(10)
	set @t = (select TEACHER from deleted)
	insert into TR_AUDIT(STMT,TRNAME,CC) values ('DEL','TR_TEACHER_DEL3',@t)
return

select t.name, e.type_desc 
	from sys.triggers  t join  sys.trigger_events e  
	on t.object_id = e.object_id 
	where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;  

exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL2',@order = 'Last',@stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL3',@order = 'First',@stmttype = 'DELETE'

delete TEACHER where TEACHER.TEACHER = 'ЯКБ'
select * from TR_AUDIT


-- task 07
create trigger TR_TEACHER_TRAN on TEACHER after INSERT, DELETE, UPDATE  
as 
declare @count int = (select  count(*) from TEACHER where TEACHER.TEACHER_NAME = 'ШАМАН');
if (@count > 0)
	begin
		raiserror('ШАМАНА быть не может!',10,1);
		rollback;
	end;
return;

update TEACHER set TEACHER.TEACHER_NAME = 'ШАМАН' where TEACHER.TEACHER = 'ШМН'
select * from TR_AUDIT


-- task 08
create trigger TR_FAC_INSTEAD_OF on FACULTY instead of DELETE
as raiserror('Удаление запрещено',10,1)
return

insert into FACULTY values('qwe','qwerty')
delete FACULTY where FACULTY.FACULTY = 'qwe'

drop trigger TR_Teacher_Ins
drop trigger TR_Teacher_Del
drop trigger TR_Teacher_Upd
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3
drop trigger TR_TEACHER_TRAN
drop trigger TR_FAC_INSTEAD_OF


-- task 09
drop table ZXC
create table ZXC(
	id int identity(1,1),
	val int
	);
alter table ZXC add county int


DROP TRIGGER DDL_UNIVER ON DATABASE;
create trigger DDL_UNIVER on database
for DDL_DATABASE_LEVEL_EVENTS
as
	declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
	declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
	declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 

	print 'Тип события: '+@t;
    print 'Имя объекта: '+@t1;
    print 'Тип объекта: '+@t2;

	IF @t = 'CREATE_TABLE'
    BEGIN
        RAISERROR(N'Создание новых таблиц запрещено.', 16, 1);
        ROLLBACK;
    END
    ELSE IF @t = 'DROP_TABLE'
    BEGIN
        RAISERROR(N'Удаление существующих таблиц запрещено.', 16, 1);
        ROLLBACK;
    END

    --raiserror( 'Операции с таблицами запрещены', 16, 1);  
    --rollback;    



-- триггер который студенту при добавлении оценки ниже 4 ставит 10


create trigger TR_MAKE_OTLICHNIK on PROGRESS after INSERT
as begin
	declare @insertedId int = -1,@subj char(10)
	set @insertedId = (select IDSTUDENT from inserted where inserted.NOTE = 4)
	set @subj = (select [SUBJECT] from inserted where inserted.IDSTUDENT = @insertedId and inserted.NOTE = 4)

	if(@insertedId >= 0)
	begin
		update PROGRESS set PROGRESS.NOTE = 10
		where PROGRESS.IDSTUDENT = @insertedId and PROGRESS.SUBJECT = @subj
	end
end


delete PROGRESS where IDSTUDENT = 1002 and SUBJECT = 'ДМ'
insert into PROGRESS values('ДМ', 1003,'2013-10-01' , 6)
select * from PROGRESS where IDSTUDENT = 1003



