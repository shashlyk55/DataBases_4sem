use UNIVER;

-- task 01
select FACULTY.FACULTY,
		GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from GROUPS inner join STUDENT
on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join FACULTY
on FACULTY.FACULTY = GROUPS.FACULTY
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY in ('ÈÒ')
group by rollup (FACULTY.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT])


--task 02
select FACULTY.FACULTY,
		GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from GROUPS inner join STUDENT
on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join FACULTY
on FACULTY.FACULTY = GROUPS.FACULTY
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY in ('ÈÒ')
group by cube (FACULTY.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]);


--task 03
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]
	UNION all
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÕÒÈÒ') or GROUPS.FACULTY in ('ÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]


--task 04
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÕÒÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]
	INTERSECT
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÕÒÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]


--task 05
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]
	EXCEPT
select GROUPS.PROFESSION,
		PROGRESS.[SUBJECT],
		avg(PROGRESS.NOTE)[avg_mark]
from PROGRESS inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in ('ÕÒÈÒ')
group by GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.[SUBJECT]


use Slesarev_MyBASE;
--task 03
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price > 35
	group by Orders.program_name,minute_price
	UNION 
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price < 30
	group by Orders.program_name,minute_price

--task 04
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price > 20
	group by Orders.program_name,minute_price
	INTERSECT 
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price < 30
	group by Orders.program_name,minute_price

--task 05
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price > 20
	group by Orders.program_name,minute_price
	EXCEPT 
select Orders.program_name,
		TVPrograms.minute_price
	from Orders inner join TVPrograms 
	on Orders.program_name = TVPrograms.program_name
	where minute_price < 30
	group by Orders.program_name,minute_price
