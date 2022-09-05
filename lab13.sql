
--1
drop function COUNT_STUDENTS;
go
create function COUNT_STUDENTS(@faculty varchar(20)) returns int as 
begin 
declare @rs int=0;
set @rs=(select count(*)
		from FACULTY inner join GROUPS
		on FACULTY.FACULTY = GROUPS.FACULTY
		inner join STUDENT
		on GROUPS.IDGROUP= STUDENT.IDGROUP
		where FACULTY.FACULTY = @faculty);
return @rs;
end;
go
declare @f int = dbo.COUNT_STUDENTS('ХТиТ');
print 'Количество записей = ' + cast(@f as varchar(4));

go
alter function COUNT_STUDENTS(@faculty varchar(20), @prof varchar(20) = NULL) returns int as
begin 
declare @rs int=0;
set @rs=(select count(*)
		from FACULTY inner join GROUPS
		on FACULTY.FACULTY = GROUPS.FACULTY
		inner join STUDENT
		on GROUPS.IDGROUP= STUDENT.IDGROUP
		where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = ISNULL(@prof, GROUPS.PROFESSION));
return @rs;
end;
go
declare @f int = dbo.COUNT_STUDENTS('ХТиТ', '1-36 01 08');
print 'Количество записей = ' + cast(@f as varchar(4));

select * from FACULTY
select * from GROUPS
select * from STUDENT

--2
go
create function FSUBJECTS(@p varchar(20)) returns char(300) as
begin
declare @tv char(20);
declare @t varchar(300) = 'Дисциплины: ';
declare Sub cursor local
for select SUBJECT from SUBJECT 
			where PULPIT = @p;

open Sub;
fetch Sub into @tv;
while @@FETCH_STATUS=0
begin
set @t=@t+', '+ rtrim(@tv);
fetch Sub into @tv;
end;
return @t;
end;
go
select PULPIT, dbo.FSUBJECTS (PULPIT) from PULPIT;

--3
drop function FFACPUL;
go
create function FFACPUL(@faculty varchar(20), @pulpit varchar(20)) returns table as 
return select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT 
	   on FACULTY.FACULTY = PULPIT.FACULTY 
	   where FACULTY.FACULTY = isnull(@faculty, FACULTY.FACULTY) and PULPIT.PULPIT = isnull(@pulpit, PULPIT.PULPIT);
go
select * from dbo.FFACPUL(NULL, NULL);
select * from dbo.FFACPUL('ТОВ', NULL);
select * from dbo.FFACPUL(NULL, 'ИСиТ');
select * from dbo.FFACPUL('ИТ', 'ИСиТ');

--4
go
create function FCTEACHER(@pulpit varchar(20)) returns int as 
begin
	declare @count int = (select count(*) from TEACHER where PULPIT = isnull(@pulpit, PULPIT));
	return @count;
end;
go
select PULPIT, dbo.FCTEACHER(PULPIT) [Количество преподавателей] from PULPIT;
select dbo.FCTEACHER(NULL) [Всего преподавателей];

--6
drop function FACULTY_REPORT;
go
create function FACULTY_REPORT(@c int) returns @fr table 
([Факультет] varchar(50), [Кол-во кафедр] int, [Кол-во групп] int, [Кол-во судентов] int, [Кол-во специальностей] int)
as begin
	declare cc cursor static for
	select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY, default) > @c;
	declare @f varchar(30);
	open cc;
	fetch cc into @f;
	while @@FETCH_STATUS = 0
	begin
		insert @fr values (@f, dbo.COUNT_PULPIT(@f),dbo.COUNT_GROUPS(@f), dbo.COUNT_STUDENTS(@f, default),
		dbo.COUNT_PROFESSION(@f));
		fetch cc into @f;
	end;
	return;
end;
go
select * from dbo.FACULTY_REPORT(0);

go
create function COUNT_PULPIT(@faculty varchar(20)) returns int as 
begin
	declare @count int;
	set @count = (select count(*) from PULPIT where FACULTY = @faculty);
	return @count;
end;

go 
create function COUNT_GROUPS(@faculty varchar(20)) returns int as 
begin
	declare @count int;
	set @count = (select count(*) from GROUPS where FACULTY = @faculty);
	return @count;
end;

go 
create function COUNT_PROFESSION(@faculty varchar(20)) returns int as 
begin
	declare @count int;
	set @count = (select count(*) from GROUPS where FACULTY = @faculty);
	return @count;
end;
go
 