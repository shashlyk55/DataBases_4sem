use UNIVER;

--task 01
declare ZkSubject cursor for select SUBJECT.SUBJECT_NAME from SUBJECT where SUBJECT.PULPIT = 'ИСИТ';
go
update SUBJECT set SUBJECT_NAME = 'qwerty234w4e76r' where SUBJECT.SUBJECT_NAME like '%Базы данных%'
declare @tv char(20), @t char(400) = '';
open ZkSubject;
fetch ZkSubject into @tv;
print 'Дисциплины кафедры ИСИТ';
while @@FETCH_STATUS = 0
	begin
		set @t = RTRIM(@tv) + ',' + @t;
		fetch ZkSubject into @tv;
	end;
print @t;
close ZkSubject;

DEALLOCATE ZkSubject;


--task 02
DECLARE Subject_cursor CURSOR LOCAL for 
	select SUBJECT.SUBJECT_NAME from SUBJECT where SUBJECT.SUBJECT_NAME like '%комп%';
DECLARE @subj char(100), @subjs char(100) ='';
OPEN Subject_cursor;
print 'Дисциплины комп на ИСИТ: ';
FETCH Subject_cursor into @subj;
	set @subjs ='1. ' + RTRIM(@subj);	
	print @subjs;

go
DECLARE @subj char(50), @subjs char(100) ='';
FETCH  Subject_cursor into @subj;
	set @subjs ='2. ' + RTRIM(@subj);	
	print @subjs;
CLOSE Subject_cursor


--deallocate Subject_cursor;
DECLARE Subject_cursor CURSOR GLOBAL for 
	select SUBJECT.SUBJECT_NAME from SUBJECT where SUBJECT.SUBJECT_NAME like '%комп%';
DECLARE @subj char(100), @subjs char(100) ='';
OPEN Subject_cursor;
print 'Дисциплины комп на ИСИТ: ';
FETCH Subject_cursor into @subj;
	set @subjs ='1. ' + RTRIM(@subj);	
	print @subjs;

go
DECLARE @subj char(50), @subjs char(100) ='';
FETCH  Subject_cursor into @subj;
	set @subjs ='2. ' + RTRIM(@subj);	
	print @subjs;
CLOSE Subject_cursor


--task 03
deallocate Auditorium_local_static

INSERT Into AUDITORIUM values('333-1','ЛБ-К','15','333-1');
DECLARE Auditorium_local_static CURSOR local STATIC for select AUDITORIUM,AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К';
DECLARE @q int = 0, @auditorium char(10), @iter int = 1;
open Auditorium_local_static;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
DELETE AUDITORIUM where AUDITORIUM ='333-1';
FETCH Auditorium_local_static into @auditorium, @q;
while @@FETCH_STATUS = 0
	begin
		print cast(@iter as varchar(5)) + '. Аудитория ' + rtrim(@auditorium) +': ' + cast(@q as varchar(5)) + ' мест' ;
		set @iter += 1;
		FETCH Auditorium_local_static into @auditorium, @q;
	end;
CLOSE Auditorium_local_static;

go
INSERT Into AUDITORIUM values('333-1','ЛБ-К','15','333-1');
DECLARE Auditorium_local_dynamic CURSOR local DYNAMIC for select AUDITORIUM,AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К';
DECLARE @q int = 0, @auditorium char(10), @iter int = 1;
open Auditorium_local_dynamic;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
DELETE AUDITORIUM where AUDITORIUM ='333-1';
FETCH Auditorium_local_dynamic into @auditorium, @q;
while @@FETCH_STATUS = 0
	begin
		print cast(@iter as varchar(5)) + '. Аудитория ' + rtrim(@auditorium) +': ' + cast(@q as varchar(5)) + ' мест' ;
		set @iter += 1;
		FETCH Auditorium_local_dynamic into @auditorium, @q;
	end;
CLOSE Auditorium_local_dynamic;

deallocate Auditorium_local_dynamic


--task 04
DECLARE  @tc int, @rn char(50);  
         DECLARE Primer1 cursor local dynamic SCROLL                               
               for SELECT row_number() over (order by SUBJECT.SUBJECT_NAME) N,
	                           SUBJECT.SUBJECT_NAME FROM SUBJECT 
                                      where SUBJECT.SUBJECT_NAME like '%комп%' 
	OPEN Primer1;
	FETCH  first from Primer1 into  @tc, @rn;                 
	print 'следующая строка        : ' + cast(@tc as varchar(3))+ rtrim(@rn);  
	FETCH  next from Primer1 into  @tc, @rn;                 
	print 'следующая строка        : ' + cast(@tc as varchar(3))+ rtrim(@rn);  
	FETCH  LAST from  Primer1 into @tc, @rn;       
	print 'последняя строка          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      
    CLOSE Primer1;


--task 05
deallocate Primer2
declare Primer2 cursor 
	for select AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM_CAPACITY 
				from AUDITORIUM for update;
declare @tn char(20), @tc int;
	open Primer2;
	fetch Primer2 into @tn, @tc;
	delete AUDITORIUM where current of Primer2;
	fetch Primer2 into @tn, @tc;
	update AUDITORIUM set AUDITORIUM.AUDITORIUM_CAPACITY = AUDITORIUM.AUDITORIUM_CAPACITY + 1
										where current of Primer2;
	close Primer2;

select * from AUDITORIUM;


--task 06
drop table #temp
create table #temp(
SUBJECT varchar(100),
IDSTUDENT int,
PDATE datetime,
NOTE int
);

INSERT INTO #temp (SUBJECT, IDSTUDENT, PDATE, NOTE)
SELECT SUBJECT, IDSTUDENT, PDATE, NOTE
FROM PROGRESS;
select * from #temp

delete from #temp where #temp.NOTE <= 4
--------------
use UNIVER;
DECLARE newCursor cursor 
						for SELECT STUDENT.NAME, GROUPS.PROFESSION, PROGRESS.NOTE
						from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP inner join
						PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT;

DECLARE @name varchar(300), @profession varchar(300), @mark varchar(10)

OPEN newCursor;
fetch newCursor into @name,@profession,@mark;
if(@mark <= 4)
			begin
				DELETE PROGRESS where CURRENT OF newCursor;
			end;
print @name + ' - '+ @profession + ' - ' + @mark ;
While (@@FETCH_STATUS = 0)
	begin
		fetch newCursor into @name,@profession,@mark;
		if(@mark <= 4)
			begin
				DELETE PROGRESS where CURRENT OF newCursor;
			end;
		print @name + ' = '+ @profession + ' = ' + @mark ;
	end;
CLOSE newCursor;

INSERT INTO PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
values ('ОАиП',1004,'2013-10-01',4),
('ОАиП',1005,'2013-10-01',3),
('СУБД',1017,'2013-12-01',4),
('СУБД',1018,'2013-12-01',2);
-------------

--2
declare @currentID int = 1001; 

use UNIVER;
DECLARE newCursor cursor local dynamic 
						for SELECT PROGRESS.NOTE, PROGRESS.IDSTUDENT from PROGRESS
	

DECLARE @id varchar(10), @mark varchar(10)

OPEN newCursor;
fetch newCursor into @mark,@id;
if(@id = @currentID)
			begin
				UPDATE PROGRESS set PROGRESS.NOTE = PROGRESS.NOTE + 1 where current of newCursor
				print @id + ' - ' + @mark ;
			end;
While (@@FETCH_STATUS = 0)
	begin
		fetch newCursor into @mark,@id;
		if(@id = @currentID)
			begin
				UPDATE PROGRESS set PROGRESS.NOTE = PROGRESS.NOTE + 1 where current of newCursor
				print @id + ' - ' + @mark ;
			end;
	end;
CLOSE newCursor;

UPDATE PROGRESS set PROGRESS.NOTE = PROGRESS.NOTE - 1 where PROGRESS.IDSTUDENT = 1001