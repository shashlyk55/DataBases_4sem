
--task 1
USE UNIVER;

select PULPIT.PULPIT_NAME,FACULTY.FACULTY_NAME
from PULPIT,FACULTY
where PULPIT.FACULTY = FACULTY.FACULTY and
	FACULTY.FACULTY in 
	(select PROFESSION.FACULTY
	from PROFESSION
	where (PROFESSION.PROFESSION_NAME like '%���������%'))


--task 2
USE UNIVER;

select PULPIT.PULPIT_NAME,FACULTY.FACULTY_NAME
from PULPIT inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where FACULTY.FACULTY in 
	(select PROFESSION.FACULTY
	from PROFESSION
	where (PROFESSION.PROFESSION_NAME like '%����������%' or 
			PROFESSION.PROFESSION_NAME like '%����������%'))


--task 3
USE UNIVER;

select FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,PROFESSION.PROFESSION_NAME
from FACULTY inner join PROFESSION
on PROFESSION.FACULTY = FACULTY.FACULTY
inner join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
where (PROFESSION.PROFESSION_NAME like '%����������%' or 
			PROFESSION.PROFESSION_NAME like '%����������%')


--task 4
USE UNIVER;

select t1.AUDITORIUM_CAPACITY,t1.AUDITORIUM_TYPE
from AUDITORIUM as t1
where t1.AUDITORIUM_CAPACITY = 
	(select top(1) t2.AUDITORIUM_CAPACITY
	from AUDITORIUM as t2
	where t1.AUDITORIUM_TYPE = t2.AUDITORIUM_TYPE
	order by AUDITORIUM_CAPACITY desc)


--task 5
USE UNIVER;

select FACULTY.FACULTY_NAME,FACULTY.FACULTY
from FACULTY
where not exists 
	(select * from PULPIT
	where PULPIT.FACULTY = FACULTY.FACULTY)


--task 6
select top 1
	(select avg(PROGRESS.NOTE) from PROGRESS
		where (PROGRESS.[SUBJECT] like '����'))[����],
	(select avg(PROGRESS.NOTE) from PROGRESS
		where (PROGRESS.[SUBJECT] like '����'))[����],
		(select avg(PROGRESS.NOTE) from PROGRESS
		where (PROGRESS.[SUBJECT] like '��'))[��]
from PROGRESS


--task 7
USE UNIVER;

select STUDENT.IDSTUDENT,PROGRESS.NOTE,PROGRESS.[SUBJECT]
from STUDENT inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where PROGRESS.NOTE >= all (select PROGRESS.NOTE from PROGRESS)


--task 8
USE UNIVER;

select STUDENT.IDSTUDENT,PROGRESS.NOTE,PROGRESS.[SUBJECT]
from STUDENT inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where PROGRESS.NOTE >= any 
	(select PROGRESS.NOTE
	from PROGRESS 
	where PROGRESS.[SUBJECT] like '����')

	



