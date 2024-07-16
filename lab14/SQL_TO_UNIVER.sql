use UNIVER;

--task 01
alter function COUNT_STUDENTS (@faculty varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(STUDENT.IDSTUDENT)
	from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
	where FACULTY.FACULTY = @faculty);
return @rc;
end;

print 'Колич студентов = ' + cast(dbo.COUNT_STUDENTS('ИТ') as varchar(4))

alter function COUNT_STUDENTS (@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin declare @rc int = 0;
set @rc = (select count(STUDENT.IDSTUDENT)
	from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
	where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
return @rc;
end;

print 'Колич студентов = ' + cast(dbo.COUNT_STUDENTS('ИТ','1-47 01 01') as varchar(4))
print 'Колич студентов = ' + cast(dbo.COUNT_STUDENTS(default,'1-47 01 01') as varchar(4))


--task 02
drop function FSUBJECTS;
create function FSUBJECTS (@p varchar(20)) returns varchar(300)
as begin 
declare @currentDisc char(20);
declare @disciplines varchar(300) = 'Дисциплины: ';
declare discipline_cursor cursor local 
for select [SUBJECT].SUBJECT from [SUBJECT] where [SUBJECT].PULPIT = @p;
	open discipline_cursor 
	fetch discipline_cursor into @currentDisc
	while @@FETCH_STATUS = 0
	begin
		set @disciplines = @disciplines + ',' + trim(@currentDisc);
		fetch discipline_cursor into @currentDisc;
	end;
return @disciplines
end;

select [SUBJECT].PULPIT, dbo.FSUBJECTS([SUBJECT].PULPIT) from [SUBJECT]


--task 03
drop function FFACPUL
create function FFACPUL (@facCode varchar(20) = null, @pulCode varchar(20) = null) returns table
as return 
	select FACULTY.FACULTY,PULPIT.PULPIT 
	from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
	where 
		FACULTY.FACULTY = ISNULL(@facCode,FACULTY.FACULTY) and
		PULPIT.PULPIT = ISNULL(@pulCode,PULPIT.PULPIT)
	
select * from dbo.FFACPUL(null,null)
select * from dbo.FFACPUL('ЛХФ',null)
select * from dbo.FFACPUL(null,'ИСиТ')
select * from dbo.FFACPUL('ИТ','ИСиТ')


--task 04
drop function FCTEACHER;
create function FCTEACHER(@pulpitCode varchar(20)) returns int
as begin 
	declare @rc int = (select count(*) from TEACHER
	where TEACHER.PULPIT = ISNULL(@pulpitCode, TEACHER.PULPIT));
	return @rc;
end;

select PULPIT.PULPIT,dbo.FCTEACHER(PULPIT.PULPIT)[Количество преподавателей]
from PULPIT

select dbo.FCTEACHER(null)[Всего преподавателей]


--task 06
drop function COUNT_STUDENTS;
create function COUNT_STUDENTS(@faculty char(10), @num int = 20) returns int
as begin
	declare @rc int = (select count(STUDENT.IDSTUDENT) 
		from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
		inner join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
		where FACULTY.FACULTY = @faculty);
return @rc;
end;

print cast(dbo.COUNT_STUDENTS('ИТ', default) as varchar(4))

drop function COUNT_PULPIT;
create function COUNT_PULPIT (@faculty char(10)) returns int
as begin
	declare @rc int = (select count(PULPIT.PULPIT) 
		from PULPIT where PULPIT.FACULTY = @faculty)
return @rc;
end;

print cast(dbo.COUNT_PULPIT ('ИТ') as varchar(4))

drop function COUNT_GROUPS;
create function COUNT_GROUPS (@faculty char(10)) returns int
as begin
	declare @rc int = (select count(GROUPS.IDGROUP) 
		from GROUPS where GROUPS.FACULTY = @faculty)
return @rc;
end;

print cast(dbo.COUNT_GROUPS('ИТ') as varchar(4))

drop function COUNT_PROFESSION
create function COUNT_PROFESSION (@faculty char(10)) returns int
as begin
	declare @rc int = (select count(PROFESSION.PROFESSION) 
		from PROFESSION where PROFESSION.FACULTY = @faculty);
return @rc;
end;

print cast(dbo.COUNT_PROFESSION ('ИТ') as varchar(4))

drop function FACULTY_REPORT;
create function FACULTY_REPORT(@c int) returns @fr table
	( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
		[Количество студентов] int, [Количество специальностей] int )
as begin 
declare cc CURSOR static for 
select FACULTY from FACULTY 
where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
	declare @f varchar(30);
	open cc;  
    fetch cc into @f;
	while @@fetch_status = 0
		begin
			insert @fr values(@f, dbo.COUNT_PULPIT(@f), dbo.COUNT_GROUPS(@f), 
			dbo.COUNT_STUDENTS(@f, default), dbo.COUNT_PROFESSION(@f)); 
	        fetch cc into @f;  
		end;   
return; 
end;

select * from dbo.FACULTY_REPORT(20)
select * from dbo.FACULTY_REPORT(10)



--dop
alter function GetBadSpec () returns char(20)
as begin
declare @badSpec char(20) = (select top 1 PROFESSION.PROFESSION from PROGRESS 
		join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
		join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
		where PROGRESS.NOTE <= 6
		group by PROFESSION.PROFESSION
		order by COUNT(PROGRESS.NOTE) desc)
return @badSpec
end

print dbo.GetBadSpec()

select PROFESSION.PROFESSION, count(PROGRESS.NOTE) from PROGRESS 
		join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
		join PROFESSION on GROUPS.PROFESSION = PROFESSION.PROFESSION
		where PROGRESS.NOTE <= 6
		group by PROFESSION.PROFESSION
		order by COUNT(PROGRESS.NOTE) desc