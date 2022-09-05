/*1*/
drop view [teachers]
go
create view [teachers]
as select TEACHER [code], TEACHER_NAME [name], GENDER [gender], PULPIT [pulpit]
from TEACHER
go

select * from [teachers]

/*2*/
drop view [count pulpit]
go
create view [count pulpit]
as select 
(select count(*) from PULPIT
where PULPIT.FACULTY=FACULTY.FACULTY)  [count] ,
FACULTY_NAME [faculty]
from FACULTY
go

select * from [count pulpit]

/*3*/
drop view [auditoriums]
go
create view [auditoriums] (code, name)
as select AUDITORIUM,
AUDITORIUM_NAME
from AUDITORIUM
where AUDITORIUM_TYPE like 'ÎÍ%'
go

select * from auditoriums

/*4*/
drop view [lection auditoriums]
go
create view [lection auditoriums] (code, name, type)
as select AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
from AUDITORIUM
where AUDITORIUM_TYPE like 'ÎÍ%' 
with check option
go

select * from [lection auditoriums]

insert [lection auditoriums] values('200-3', '200-3', 'À¡- ')
insert [lection auditoriums] values('200-3', '200-3', 'À - ')

/*5*/
drop view [disciplines]
go
create view [disciplines]
as select top 7 SUBJECT [code],
SUBJECT_NAME [name],
PULPIT [code pulpit]
from SUBJECT
order by SUBJECT_NAME
go

select * from disciplines

/*6*/
go
alter view [count pulpit] with schemabinding
as select (select count(*) from dbo.PULPIT
where PULPIT.FACULTY=FACULTY.FACULTY)  [count] ,
FACULTY_NAME [faculty]
from dbo.FACULTY
go

select * from [count pulpit]