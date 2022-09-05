use UNIVER

/*1*/
select min(a.AUDITORIUM_CAPACITY) [min capacity],
max(a.AUDITORIUM_CAPACITY) [max capacity],
avg(a.AUDITORIUM_CAPACITY) [avg capacity],
sum(a.AUDITORIUM_CAPACITY) [sum capacity],
count(*) [count capacity]
from AUDITORIUM a

/*2*/
select a2.AUDITORIUM_TYPENAME,
max(a1.AUDITORIUM_CAPACITY) [max capacity],
min(a1.AUDITORIUM_CAPACITY) [min capacity],
avg(a1.AUDITORIUM_CAPACITY) [avg capacity],
sum(a1.AUDITORIUM_CAPACITY) [sum capacity],
count(a1.AUDITORIUM_CAPACITY) [count capacity]
from AUDITORIUM a1 inner join AUDITORIUM_TYPE a2
on a1.AUDITORIUM_TYPE=a2.AUDITORIUM_TYPE 
group by a2.AUDITORIUM_TYPENAME

/*3*/
select *
from (select case when p.NOTE between 4 and 5 then '4-5'
when p.NOTE between 6 and 7 then '6-7'
when p.NOTE between 8 and 9 then '8-9'
else '10'
end [score], count(*) [count]

from PROGRESS p group by case
when p.NOTE between 4 and 5 then '4-5'
when p.NOTE between 6 and 7 then '6-7'
when p.NOTE between 8 and 9 then '8-9'
else '10'
end) as d
order by case [score]
when '10' then 0
when '8-9' then 1
when '6-7' then 2
else 3
end

/*4*/
select f.FACULTY [faculty],
g.PROFESSION [profession],
g.IDGROUP [group],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from FACULTY f inner join GROUPS g
on f.FACULTY=g.FACULTY
inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on p.IDSTUDENT=s.IDSTUDENT
group by  f.FACULTY, g.PROFESSION, g.IDGROUP
order by [avg score] desc

select f.FACULTY [faculty],
g.PROFESSION [profession],
g.IDGROUP [group],
round(avg(cast(p.NOTE as float(4))),2) [avg score],
p.SUBJECT [subject]
from FACULTY f inner join GROUPS g
on f.FACULTY=g.FACULTY
inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on p.IDSTUDENT=s.IDSTUDENT
where p.SUBJECT='—”¡ƒ' or p.SUBJECT='Œ¿Ëœ'
group by  f.FACULTY, g.PROFESSION, g.IDGROUP, p.SUBJECT
order by [avg score] desc

/*5*/
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from FACULTY f, GROUPS g, STUDENT s, PROGRESS p
where f.FACULTY='“Œ¬'
group by f.FACULTY, g.PROFESSION, p.SUBJECT

select distinct g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from FACULTY f, GROUPS g, STUDENT s, PROGRESS p
where f.FACULTY='“Œ¬'
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT)

select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from FACULTY f, GROUPS g, STUDENT s, PROGRESS p
where f.FACULTY='“Œ¬'
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)

/*7*/
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='“Œ¬'
group by g.PROFESSION, p.SUBJECT, p.NOTE
union
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='’“Ë“'
group by g.PROFESSION, p.SUBJECT, p.NOTE

/*8*/
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='“Œ¬'
group by g.PROFESSION, p.SUBJECT, p.NOTE
intersect
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='’“Ë“'
group by g.PROFESSION, p.SUBJECT, p.NOTE

/*9*/
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='“Œ¬'
group by g.PROFESSION, p.SUBJECT, p.NOTE
except
select g.PROFESSION [profession],
p.SUBJECT [subject],
round(avg(cast(p.NOTE as float(4))),2) [avg score]
from GROUPS g inner join STUDENT s
on g.IDGROUP=s.IDGROUP
inner join PROGRESS p
on s.IDSTUDENT=p.IDSTUDENT
where g.FACULTY='’“Ë“'
group by g.PROFESSION, p.SUBJECT, p.NOTE

/*10*/
select SUBJECT [subject], count(IDSTUDENT) [count st], NOTE [note]
from PROGRESS 
group by SUBJECT, IDSTUDENT, NOTE
having NOTE=8 or NOTE=9
order by NOTE desc
