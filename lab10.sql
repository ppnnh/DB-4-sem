--1
declare @pl char(25), @p char(300)='';
declare ISIT cursor 
	for select SUBJECT_NAME from SUBJECT where PULPIT='»—Ë“';
open ISIT
fetch ISIT into @pl
print 'ISIT'
while @@FETCH_STATUS=0
	begin
		set @p=rtrim(@pl)+','+@p
		fetch ISIT into @pl
	end;
print @p
close ISIT

--2
go
declare teacher cursor local
	for select TEACHER_NAME, PULPIT from TEACHER
declare @tc char(20), @p char(300)
open teacher
fetch teacher into @tc, @p
print '1. '+@tc+@p
go
declare @tc char(20), @p char(300)
fetch teacher into @tc, @p
print '2. '+@tc+@p
go
go

go
declare teacher cursor global
	for select TEACHER_NAME, PULPIT from TEACHER
declare @tc char(20), @p char(200)
	open teacher
	fetch teacher into @tc, @p
	print '1. '+@tc+@p
go
declare @tc char(20), @p char(200)
	fetch teacher into @tc, @p
	print '2. '+@tc+@p
	close teacher
	deallocate teacher
go
go

--3
go
declare @f char(10), @pr char(20), @gr char(2)
declare groups cursor local static
	for select IDGROUP, FACULTY, PROFESSION from GROUPS where FACULTY='“Œ¬'
open groups
print 'Count of rows: '+cast(@@cursor_rows as varchar(5))
insert GROUPS(FACULTY, PROFESSION, YEAR_FIRST) values('“Œ¬', '1-54 01 03', 2010)
fetch groups into @gr, @f, @pr
while @@FETCH_STATUS=0
begin
	print @gr+''+@f+''+@pr
	fetch groups into @gr, @f, @pr
end
close groups
go

select * from GROUPS where FACULTY='“Œ¬'

go
declare @f char(10), @pr char(20), @gr char(2)
declare groups cursor local dynamic 
	for select IDGROUP, FACULTY, PROFESSION from GROUPS where FACULTY='“Œ¬'
open groups
print 'Count of rows: '+cast(@@cursor_rows as varchar(5))
insert GROUPS(FACULTY, PROFESSION, YEAR_FIRST) values('“Œ¬', '1-54 01 03', 2010)
fetch groups into @gr, @f, @pr
while @@FETCH_STATUS=0
begin
	print @gr+''+@f+''+@pr
	fetch groups into @gr, @f, @pr
end
close groups
go

--4
go
declare @f char(10), @pr char(20), @gr char(2)
declare groups cursor local dynamic scroll
	for select row_number() over (order by IDGROUP) N, FACULTY, PROFESSION 
	from GROUPS where FACULTY='’“Ë“'
open groups 
fetch groups into @gr, @pr, @f
print 'next row: '+@gr+' '+rtrim(@pr)+' '+@f
fetch absolute 2 from groups into @gr, @pr, @f 
print 'the second row: '+@gr+' '+rtrim(@pr)+' '+@f 
fetch last from groups into @gr, @pr, @f
print 'last row: '+@gr+' '+rtrim(@pr)+' '+@f
close groups
go

select * from GROUPS where FACULTY='’“Ë“'

--5
go
declare @f char(10), @pr char(20), @gr char(2), @y int
declare groups cursor local dynamic
	for select IDGROUP, FACULTY, PROFESSION, YEAR_FIRST from GROUPS for update
open groups
fetch groups into @gr, @f, @pr, @y
print cast(@y as varchar(4))
delete GROUPS where current of groups
fetch groups into @gr, @f, @pr, @y
print cast(@y as varchar(4))
update GROUPS set YEAR_FIRST=YEAR_FIRST+1 where current of groups
print cast(@y as varchar(4))
close groups
go

--6
go
declare @nm char(30), @nt int
declare notes cursor local dynamic 
for select distinct st.NAME, pr.NOTE from PROGRESS pr  join STUDENT st 
	on pr.IDSTUDENT=st.IDSTUDENT  join GROUPS gr
	on st.IDGROUP=st.IDGROUP where pr.NOTE<6
open notes
fetch notes into @nm, @nt
while @@FETCH_STATUS=0
	begin
		print @nm+' '+cast(@nt as varchar(2))
		fetch notes into @nm, @nt
	end
close notes
go

go
declare @id int, @nm char(30), @nt int
declare notes cursor local dynamic
for select st.IDSTUDENT, st.NAME, pr.NOTE from PROGRESS pr  join STUDENT st 
	on st.IDSTUDENT=pr.IDSTUDENT where st.IDSTUDENT=1001
open notes
fetch notes into @id, @nm, @nt 
print cast(@id as varchar(4))+' '+@nm+' '+cast(@nt as varchar(2))
update PROGRESS set NOTE=NOTE+1 where current of notes
print cast(@id as varchar(4))+' '+@nm+' '+cast(@nt as varchar(2))
close notes
go
