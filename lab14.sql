--1, 2, 3
drop table TR_AUDIT;
go
create table TR_AUDIT(
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
);


DROP TRIGGER TR_TEACHER_INS
go
create trigger TR_TEACHER_INS on TEACHER after insert 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	print '�������� �������';
	set @a1 = (select TEACHER from inserted);
	set @a2 = (select TEACHER_NAME from inserted);
	set @a3 = (select GENDER from inserted);
	set @a4 = (select PULPIT from inserted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
return;

DROP TRIGGER TR_TEACHER_DEL
go
create trigger TR_TEACHER_DEL on TEACHER after delete 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	print '�������� ��������';
	set @a1 = (select TEACHER from deleted);
	set @a2 = (select TEACHER_NAME from deleted);
	set @a3 = (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
return;

DROP TRIGGER TR_TEACHER_UPD
go
create trigger TR_TEACHER_UPD on TEACHER after update 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	print '�������� ����������';
	set @a1 = (select TEACHER from deleted);
	set @a2 = (select TEACHER_NAME from deleted);
	set @a3 = (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4 + '        ';
	set @a1 = (select TEACHER from inserted);
	set @a2 = (select TEACHER_NAME from inserted);
	set @a3 = (select GENDER from inserted);
	set @a4 = (select PULPIT from inserted);
	set @in = @in + @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in);
return;

delete TEACHER where TEACHER = 'test';
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('test', 'test', '�', '����');

update TEACHER set TEACHER_NAME = 'test_upd' where TEACHER = 'test';

select * from TR_AUDIT;

--4
DROP TRIGGER TR_TEACHER
go
create trigger TR_TEACHER on TEACHER after insert, delete, update 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	declare @ins int = (select count(*) from inserted), @del int = (select count(*) from deleted);
	if @ins > 0 and @del = 0
	begin
		print '������� INSERT';
		set @a1 = (select TEACHER from inserted);
		set @a2 = (select TEACHER_NAME from inserted);
		set @a3 = (select GENDER from inserted);
		set @a4 = (select PULPIT from inserted);
		set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
		insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @in);
	end;
	if @ins = 0 and @del > 0 
	begin
		print '������� DELETE';
		set @a1 = (select TEACHER from deleted);
		set @a2 = (select TEACHER_NAME from deleted);
		set @a3 = (select GENDER from deleted);
		set @a4 = (select PULPIT from deleted);
		set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
		insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @in);
	end;
	if @ins > 0 and @del > 0
	begin
		print '������� UPDATE';
		set @a1 = (select TEACHER from deleted);
		set @a2 = (select TEACHER_NAME from deleted);
		set @a3 = (select GENDER from deleted);
		set @a4 = (select PULPIT from deleted);
		set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4 + '        ';
		set @a1 = (select TEACHER from inserted);
		set @a2 = (select TEACHER_NAME from inserted);
		set @a3 = (select GENDER from inserted);
		set @a4 = (select PULPIT from inserted);
		set @in = @in + @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
		insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @in);
	end;
return;

--5 ����������� ����������� ����������� �� ���������� ���������
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('test', 'test', '�', '����');

--6
DROP TRIGGER TR_TEACHER_DEL1
go
create trigger TR_TEACHER_DEL1 on TEACHER after delete 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	set @a1 = (select TEACHER from deleted);
	set @a2 = (select TEACHER_NAME from deleted);
	set @a3 = (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @in);
return;
go

DROP TRIGGER TR_TEACHER_DEL2
create trigger TR_TEACHER_DEL2 on TEACHER after delete 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	set @a1 = (select TEACHER from deleted);
	set @a2 = (select TEACHER_NAME from deleted);
	set @a3 = (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @in);
return;
go

DROP TRIGGER TR_TEACHER_DEL3
create trigger TR_TEACHER_DEL3 on TEACHER after delete 
as
	declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(10), @in varchar(300);
	set @a1 = (select TEACHER from deleted);
	set @a2 = (select TEACHER_NAME from deleted);
	set @a3 = (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' ' + @a4;
	insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @in);
return;

select t.name, e.type_desc 
from sys.triggers t join sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE';  

exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE';
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last', @stmttype = 'DELETE';

--7
DROP TRIGGER TR_AUDITORIUM_C
go
create trigger TR_AUDITORIUM_C on AUDITORIUM after insert 
as
	declare @capacity int = (select AUDITORIUM_CAPACITY from inserted);
	if @capacity > 35
	begin
		raiserror('����������� ������ ��������� ��������� 35', 10, 1);
		rollback;
	end;
return;

insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME) 
values ('qqq', '��', 40, 'qqq');

--8
DROP TRIGGER FACULTY_INSTED_OF
go
create trigger FACULTY_INSTED_OF on FACULTY instead of delete 
as 
	raiserror('�������� ����������� ���������', 10, 1);
return;

delete FACULTY where FACULTY = '��';

--9
DROP TRIGGER DDL_UNIVER
go
create trigger DDL_UNIVER on database for DDL_DATABASE_LEVEL_EVENTS
as
	declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
	declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
    declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
	if @t1 = 'TR_AUDIT' 
    begin
       print '��� �������: '+@t;
       print '��� �������: '+@t1;
       print '��� �������: '+@t2;
       raiserror( N'�������� � �������� TR_AUDIT ���������', 16, 1);  
       rollback;    
   end;
return;

drop table TR_AUDIT;
