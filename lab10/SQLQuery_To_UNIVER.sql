use UNIVER;


--task 01
exec sp_helpindex 'AUDITORIUM' 
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PROGRESS'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'TEACHER'

drop table #TABLE_T1
create table #TABLE_T1(
	id int,
	val int
);

checkpoint;  --фиксация БД
 DBCC DROPCLEANBUFFERS;  --очистить буферный кэш


set nocount on
declare @i int = 0
while @i < 1200
	begin
	insert #TABLE_T1 values(@i,floor(1000*rand()))
	set @i = @i + 1
	end

select top 20 * from #TABLE_T1 order by id

drop index #TABLE_T1_CT on #TABLE_T1
create clustered index #TABLE_T1_CT on #TABLE_T1(id asc)


--task 02
drop table #TABLE_T2
create table #TABLE_T2(
	id int,
	val int
	);

set nocount on
declare @i int = 0
while @i < 11000
	begin 
	insert #TABLE_T2 values(@i,FLOOR(1000*rand()))
	set @i = @i + 1
	end

select top 20 * from #TABLE_T2 order by id,val
select * from #TABLE_T2 where val > 100 and val < 600 and id > 4000 and id < 7000
select * from #TABLE_T2 where id = 5712

drop index #TABLE_T2_NCT on #TABLE_T2
create index #TABLE_T2_NCT on #TABLE_T2 (id,val)


--task 03
drop table #TABLE_T3
create table #TABLE_T3(
	id int,
	val int
)

set nocount on
declare @i int = 0
while @i < 11000
	begin 
	insert #TABLE_T3 values(@i,FLOOR(1000*rand()))
	set @i = @i + 1
	end

select id from #TABLE_T3 where val >= 534 and id < 100

drop index #TABLE_T3_ind on #TABLE_T3
create index #TABLE_T3_ind on #TABLE_T3(val) include (id)


--task 04
drop table #TABLE_T4
create table #TABLE_T4(
	id int,
	val int
)

set nocount on
declare @i int = 0
while @i < 10500
	begin 
	insert #TABLE_T4 values(@i,FLOOR(1000*rand()))
	set @i = @i + 1
	end

select * from #TABLE_T4 where val = 700
select * from #TABLE_T4 where val > 600 and val < 700
select * from #TABLE_T4 where val > 850

drop index #TABLE_T4_WHERE on #TABLE_T4
create index #TABLE_T4_WHERE on #TABLE_T4(val) where (val > 500 and val < 800)


--task 05
use tempdb
--drop table #TABLE_T5
create table #TABLE_T5(
	id int,
	val int
)

set nocount on
declare @i int = 0
while @i < 10500
	begin 
	insert #TABLE_T5 values(@i,FLOOR(1000*rand()))
	set @i = @i + 1
	end

CHECKPOINT;
DBCC DROPCLEANBUFFERS

drop index #TABLE_T5_ind on #TABLE_T5
create index #TABLE_T5_ind on #TABLE_T5(val)

SELECT NAME [Индекс], AVG_FRAGMENTATION_IN_PERCENT [Фрагментация (%)] 
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#TABLE_T5'), NULL, NULL, NULL) SS
JOIN SYS.INDEXES II ON SS.OBJECT_ID = II.OBJECT_ID
AND SS.INDEX_ID = II.INDEX_ID WHERE NAME IS NOT NULL; 

INSERT top(10000) #TABLE_T5(id, val) select id,val from #TABLE_T5;
INSERT top(10000) #TABLE_T5(id, val) select id,val from #TABLE_T5;
INSERT top(10000) #TABLE_T5(id, val) select id,val from #TABLE_T5;

UPDATE #TABLE_T5 SET val = 101 WHERE id % 2 = 0;

--alter index #TABLE_T5_ind on #TABLE_T5 reorganize

alter index #TABLE_T5_ind on #TABLE_T5 rebuild with (online = off)

-- Проверяем степень фрагментации индекса
SELECT NAME [Индекс], AVG_FRAGMENTATION_IN_PERCENT [Фрагментация (%)] 
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#TABLE_T5'), NULL, NULL, NULL) SS
JOIN SYS.INDEXES II ON SS.OBJECT_ID = II.OBJECT_ID
AND SS.INDEX_ID = II.INDEX_ID WHERE NAME IS NOT NULL; 


--task 06
drop table #TABLE_T6
create table #TABLE_T6(
	id int,
	val int
)

set nocount on
declare @i int = 0
while @i < 10500
	begin 
	insert #TABLE_T5 values(@i,FLOOR(1000*rand()))
	set @i = @i + 1
	end

drop index #TABLE_T6_ind
create index #TABLE_T6_ind on #TABLE_T6(val) with (fillfactor = 40)

SELECT NAME [Индекс], AVG_FRAGMENTATION_IN_PERCENT [Фрагментация (%)] 
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#TABLE_T6'), NULL, NULL, NULL) SS
JOIN SYS.INDEXES II ON SS.OBJECT_ID = II.OBJECT_ID
AND SS.INDEX_ID = II.INDEX_ID WHERE NAME IS NOT NULL; 

insert top(40) percent into #TABLE_T6 select id,val from #TABLE_T5
insert top(40) percent into #TABLE_T6 select id,val from #TABLE_T5
insert top(40) percent into #TABLE_T6 select id,val from #TABLE_T5
insert top(40) percent into #TABLE_T6 select id,val from #TABLE_T5
insert top(40) percent into #TABLE_T6 select id,val from #TABLE_T5

SELECT NAME [Индекс], AVG_FRAGMENTATION_IN_PERCENT [Фрагментация (%)] 
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#TABLE_T6'), NULL, NULL, NULL) SS
JOIN SYS.INDEXES II ON SS.OBJECT_ID = II.OBJECT_ID
AND SS.INDEX_ID = II.INDEX_ID WHERE NAME IS NOT NULL; 
