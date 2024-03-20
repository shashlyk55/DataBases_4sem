use UNIVER;

--task 01
declare @c char = 'sd',
		@vc varchar(3) = 'ячсми',
		@dt datetime = getdate(),
		--@t time = CURRENT_TIMESTAMP,
		@zxc time = cast(getdate() as time),
		@i int = 4,
		@si smallint = 8,
		@ti tinyint = 12,
		@n numeric(10,5) = 1234.567;

select @si = @ti
set @i = 11

--select @vc,@i,@n

print 'int = ' + cast(@i as varchar)


--task 02
declare @capacity int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM)
if @capacity >= 200
begin
	declare @avg_capacity int = (select avg(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM)
	declare @aud_quantity int = (select count(*) from AUDITORIUM)
	declare @quantity2 int = (select count(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < @avg_capacity)
	print 'aud quantity = ' + cast(@aud_quantity as varchar(20))
	print 'avg capacity = ' + cast(@avg_capacity as varchar(20))
	print 'quantity of aud_cpacity < 200 = ' + cast(@quantity2 as varchar(20))
	print cast((cast(@quantity2 as float) / cast(@aud_quantity as float)) as varchar(10))
end
else 
	print 'capacity = ' + cast(@capacity as varchar(8))
	

--task 03
print @@ROWCOUNT
print @@VERSION
print @@SPID
print @@ERROR
print @@SERVERNAME
print @@TRANCOUNT
print @@FETCH_STATUS
print @@NESTLEVEL


--task 04
--1
declare @z float, @t float, @x float
set @t = 1
set @x = 2
if @t > @x set @z = POWER(sin(@t), 2)
else if @t < @x set @z = 4*(@t+@x)
else if @t = @x set @z = 1 - EXP(@x - 2)
print 'x = ' + cast(@x as varchar) + ' t = ' + cast(@t as varchar) + ' z = ' + cast(@z as varchar)

--2
declare @name varchar = 'Иванов Иван Иванович'


--3
--declare @current_date date = getdate()
declare @current_date date = '2024-10-07'
select * from STUDENT
where FORMAT(STUDENT.BDAY,'MM-dd') = FORMAT(DATEADD(month,1,@current_date),'MM-dd')

--4


