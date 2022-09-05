--1
declare @ch char='H',
		@vch varchar(2)='GH',
		@dt datetime,
		@t time,
		@i int,
		@si smallint,
		@ti tinyint,
		@n numeric(12,5);
set     @dt=getdate();
set		@t=getutcdate();
select @dt=PDATE from PROGRESS
select @i=max(AUDITORIUM_CAPACITY) from AUDITORIUM;
select @si=min(NOTE) from PROGRESS;
select @ti=count(NOTE) from PROGRESS;
select @ch char, @vch varchar, @dt datetime;
print 'int: '+cast(@i as varchar(10));
print 'smallint: '+cast(@si as varchar(10));
print 'tinyint: '+cast(@ti as varchar(10));

--2
declare @i1 int, @i2 int, @i3 real, @i4 real, @i5 real;
select @i1=sum(AUDITORIUM_CAPACITY) from AUDITORIUM;
select @i2=avg(AUDITORIUM_CAPACITY) from AUDITORIUM;
set @i3=(select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY<@i2);
set @i5=(select count(*) from AUDITORIUM);
set @i4=cast((@i3/@i5)*100 as numeric(4,2));
if @i1>200
begin
select @i1 sum, @i2 avg, @i3 count, @i4'%';
end
else print 'capacity: '+@i1;

--3
print 'count of rows: '+cast(@@rowcount as varchar(12));
print 'version: '+cast(@@version as varchar(100));
print 'identification of process: '+cast(@@spid as varchar(12));
print 'code of last error: '+cast(@@error as varchar(10));
print 'servername: '+cast(@@servername as varchar(100));
print 'level of tran: '+cast(@@trancount as varchar(20));
print 'fetch status: '+cast(@@fetch_status as varchar(20));
print 'level of procedure: '+cast(@@nestlevel as varchar(20));

--4
go
declare @t float=0.3, @x float=0.5, @z float;
if (@t>@x) set @z=power(sin(@t),2)
else if(@t<@x) set @z=1-exp(@x-2)
else set @z=4*(@t+@x)
print 'z= '+cast(@z as varchar(10));
go

go
select replace('Буранко Валерия Дмитриевна','Валерия Дмитриевна','В.Д.') ФИО
declare @s varchar(100) = 'Буранко Валерия Дмитриевна';
select substring(@s, 1, charindex(' ', @s))
+substring(@s, charindex(' ', @s)+1,1)+'.'
+substring(@s, charindex(' ', @s, charindex(' ', @s)+1)+1,1)+'.'
 go

go
declare @currentDate date = GETDATE();
declare	@nextmohth int = MONTH(@currentDate)+1;
select IDSTUDENT, BDAY, datediff(year,BDAY,@currentDate) [YEARS OLD] from STUDENT
where MONTH(BDAY) = @nextmohth
go

go
select distinct DATENAME(dw,PDATE) [День сдачи] from PROGRESS 
where SUBJECT = 'СУБД';
go

--5
go
declare @CountOfGroups int = (select COUNT(*) from GROUPS)
	if(@CountOfGroups < 10)
	begin
	print 'Кол-во групп меньше 10'
	print 'Кол-во ' + CAST(@CountOfGroups as varchar)
	end
	else if(@CountOfGroups < 15)
	begin
	print 'Кол-во групп меньше 15'
	print 'Кол-во ' + CAST(@CountOfGroups as varchar)
	end
	else if(@CountOfGroups < 20)
	begin
	print 'Кол-во групп меньше 20'
	print 'Кол-во ' + CAST(@CountOfGroups as varchar)
	end
	else if(@CountOfGroups >= 21)
	begin
	print 'Кол-во групп >= 20'
	print 'Кол-во ' + CAST(@CountOfGroups as varchar)
	end
go

--6
go
	select case 
	when PROGRESS.NOTE between 4 and 5 then 'удовлетворительно'
	when PROGRESS.NOTE between 6 and 7 then 'средне'
	when PROGRESS.NOTE between 8 and 10 then 'высоко'
	else 'низко'
	end Оценка,COUNT(*) [Кол-во], PROGRESS.NOTE
	from PROGRESS
	group by PROGRESS.NOTE, case
		when PROGRESS.NOTE between 4 and 5 then 'удовлетворительно'
		when PROGRESS.NOTE between 6 and 7 then 'средне'
		when PROGRESS.NOTE between 8 and 10 then 'высоко'
		else 'низко'
	end
go

--7
go
create table #Table
(
	ID int identity(0,100),
	LOTO INT,
	Moneys money
);
 set nocount on -- не выводить сообщение о вводе строки
declare @ii int = 0;
while @ii < 10
	begin
	insert #Table(LOTO,Moneys)
		values(1500*Rand(),15000*(Rand()))
	set @ii= @ii+1;
	end;
select * from #Table
drop table #Table
go

--8
go
declare @ex INT = 0;
	print @ex+1
	print @ex+2
	RETURN 
SET @ex=5;
	print @ex+5
go

--9
go
declare @5 int = 5, @0 int = 0;
begin TRY
	print @5/@0;
end try
begin catch
	print 'Код последней ошибки ' + CAST(ERROR_NUMBER() as varchar(200));
	print 'Сообщение об ошибке ' + ERROR_MESSAGE()
	print 'Номер строки с ошибкой ' +CAST(ERROR_LINE() as varchar(200));
	print 'Уровень серьезности ошибки ' + CAST(ERROR_SEVERITY() as varchar(200));
	print 'Метка ошибки ' + CAST(ERROR_STATE() as varchar(200));
end catch
go