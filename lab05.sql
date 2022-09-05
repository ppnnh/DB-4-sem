use UNIVER
/*1*/
select p.PULPIT_NAME, f.FACULTY
from FACULTY f, PULPIT p
where p.FACULTY=f.FACULTY and
f.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION
where (PROFESSION.PROFESSION_NAME like '%технология%' or 
PROFESSION_NAME like '%технологии%'))

/*2*/
select p.PULPIT_NAME, f.FACULTY
from FACULTY f inner join PULPIT p
on p.FACULTY=f.FACULTY
where f.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION
where (PROFESSION.PROFESSION_NAME like '%технология%' or 
PROFESSION_NAME like '%технологии%'))

/*3*/
select distinct p.PULPIT_NAME, f.FACULTY
from FACULTY f inner join PULPIT p
on p.FACULTY=f.FACULTY 
inner join PROFESSION 
on PROFESSION.FACULTY=f.FACULTY
where (PROFESSION.PROFESSION_NAME like '%технология%' or 
PROFESSION_NAME like '%технологии%')

/*4*/
select AUDITORIUM_CAPACITY, AUDITORIUM_TYPE
from AUDITORIUM a
where AUDITORIUM_TYPE=(select top(1) AUDITORIUM_TYPE from AUDITORIUM aa
where aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE) order by AUDITORIUM_CAPACITY desc

/*5*/
insert FACULTY 
values ('ЛИД', 'Лесное инженерное дело')

select f.FACULTY_NAME
from FACULTY f
where not exists (select * from PULPIT p
where f.FACULTY=p.FACULTY)

/*6*/
select top 1
(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT='ОАиП') [OAP],
(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT='БД') [BD],
(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT='СУБД') [SUBD]

/*7*/
select distinct NOTE, SUBJECT
from PROGRESS
where NOTE>all (select avg(NOTE) from PROGRESS
where SUBJECT='КГ')

/*8*/
select distinct NOTE, SUBJECT
from PROGRESS
where NOTE>=any (select avg(NOTE) from PROGRESS
where SUBJECT='СУБД')
