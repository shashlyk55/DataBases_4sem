use UNIVER;

--task 01
create view [teacher_view](code,[name],gender,cafedra_code)
	as select  TEACHER.TEACHER,
			   TEACHER.TEACHER_NAME,
			   TEACHER.GENDER,
			   TEACHER.PULPIT from TEACHER;
go
select * from teacher_view;


--task 02
create view [cafedra_quantity]
	as select FACULTY_NAME[fac_name],
			  COUNT(PULPIT_NAME)[quantity_cafedra]
		from FACULTY inner join PULPIT
		on FACULTY.FACULTY = PULPIT.FACULTY
		group by FACULTY_NAME
go
select * from cafedra_quantity


--task 03
create view [auditoria_t1]
	as select AUDITORIUM.[AUDITORIUM],
			  AUDITORIUM.AUDITORIUM_TYPE[AUDITORIUM_TYPE]
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE in ('כך')
go
insert [auditoria_t1] values ('9999-1','ֻÊ')
update [auditoria_t1] set AUDITORIUM = '111-4' where [name] = '236-1'
select * from [auditoria_t1]


--task 04
create view [auditoria_t2]
	as select AUDITORIUM.[AUDITORIUM],
			  AUDITORIUM_TYPE.[AUDITORIUM_TYPE]
		from AUDITORIUM inner join AUDITORIUM_TYPE
		on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		where AUDITORIUM.AUDITORIUM_TYPE in ('כך') with check option

insert [auditoria_t2] values ('999-1','ֻÊ')
update [auditoria_t2] set AUDITORIUM = '123-4' where AUDITORIUM = '236-1'
select * from [auditoria_t2]


--task 05
create view disciplines
	as select top 10 [SUBJECT].SUBJECT_NAME,
		      [SUBJECT].PULPIT
	from [SUBJECT] 
	order by [SUBJECT].SUBJECT_NAME
go
select * from disciplines

		   
--task 06
use UNIVER;
alter view [cafedra_quantity] with schemabinding
	as select fac.FACULTY_NAME[fac_name],
			  COUNT(plp.PULPIT_NAME)[caf_quantity]
		from dbo.FACULTY fac inner join dbo.PULPIT plp
		on fac.FACULTY = plp.FACULTY
		group by fac.FACULTY_NAME

select * from [cafedra_quantity];



USE Slesarev_MyBASE
--task 01
create view programs_view([name],minute_price,rate)
	as select * from TVPrograms;
go
select * from programs_view;



