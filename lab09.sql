--1
go
exec SP_HELPINDEX 'STUDENT'

create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<1001
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
--оценка времени выполнения след запроса
checkpoint;
dbcc dropcleanbuffers;
select * from #table where id between 1 and 10 

create clustered index #table_cl on #table(id asc)
drop table #table
go

--2
go
create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<10001
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
select * from #table where id between 1 and 100
create index #table_ind on #table(id, number)
select * from #table where number>100 and number<200
select * from #table order by id, number
drop table #table
go

--3
go
create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<10001
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
select * from #table where id between 1 and 100
create index #table_ind on #table(id asc) include(number)
select id from #table where number<200
drop table #table
go

--4
go
create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<101
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
select * from #table where id between 5 and 50
select * from #table where id>30
select * from #table where id=45
create index #table_ind on #table(id asc) where (id>=5 and id<45)
select id from #table where number<200
drop table #table
go

--5
go
create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<101
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
create index #table_ind on #table(id)
select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)] 
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'),
object_id(N'#table'),null,null,null) ss
join sys.indexes ii on ss.object_id=ii.object_id and ss.index_id=ii.index_id
where name is not null                                                                                   

-->90
declare @i int=0;
while @i<100000
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)] 
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'),
object_id(N'#table'),null,null,null) ss
join sys.indexes ii on ss.object_id=ii.object_id and ss.index_id=ii.index_id
where name is not null

--reorganize
alter index #table_ind on #table reorganize

select name, avg_fragmentation_in_percent 
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'),
object_id(N'#table'),null,null,null) ss
join sys.indexes ii on ss.object_id=ii.object_id and ss.index_id=ii.index_id
where name is not null

--rebuild
alter index #table_ind on #table rebuild with (online=off)

select name, avg_fragmentation_in_percent 
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'),
object_id(N'#table'),null,null,null) ss
join sys.indexes ii on ss.object_id=ii.object_id and ss.index_id=ii.index_id
where name is not null

drop table #table
go

--6
go
create table #table
( id int identity(1,1),
  number int
);
set nocount on;
declare @i int=0;
while @i<101
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
create index #table_ind on #table(id) with (fillfactor=65)
while @i<301
begin
  insert #table(number)
  values(3000*rand())
  set @i+=1;
end;
select name, avg_fragmentation_in_percent 
from sys.dm_db_index_physical_stats(db_id(N'TEMPDB'),
object_id(N'#table'),null,null,null) ss
join sys.indexes ii on ss.object_id=ii.object_id and ss.index_id=ii.index_id
where name is not null

drop table #table
go