--1
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.FIRST') )	            
	drop table FIRST;           
	declare @c int, @flag char = 'c';           -- commit ��� rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������
	CREATE table FIRST(K int );                         -- ������ ���������� 
		INSERT FIRST values (1),(2),(3);
		set @c = (select count(*) from FIRST);
		print '���������� ����� � ������� FIRST: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
	          else   rollback;                                 -- ���������� ����������: �����  
      SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������
	
	if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
	    where OBJECT_ID= object_id(N'DBO.FIRST') )
		print '������� FIRST ����';  
    else print '������� FIRST ���'

--2

begin try
	begin tran
	delete FACULTY where FACULTY_NAME = 'IT';
	insert FACULTY values('IT','Information technology');
	insert FACULTY values('TOV','ghuwhgvuijfkjn');
	commit tran;
	end try
	begin catch
	print 'Error:' + case
	when error_number()=2627 and patindex('%PK_UNIVER%', error_message())>0
	then '������������ ������'
	else '����������� ������:' +cast(error_number() as varchar(5)) + error_message()
end;
if @@TRANCOUNT > 0 rollback tran;
end catch;

--3

declare @point varchar(32);
begin try
	begin tran
	delete FACULTY where FACULTY_NAME = 'IT';
	set @point='p2';
	save tran @point;
	insert FACULTY values('IT','Information technology');
	set @point='p1';
	save tran @point;
	insert FACULTY values('TOV','ghuwhgvuijfkjn');
	set @point='p2';
	save tran @point;
	commit tran;
	end try
begin catch
	print 'Error:' + case
	when error_number()=2627 and patindex('%PK_UNIVER%', error_message())>0
	then '������������ ������'
	else '����������� ������:' +cast(error_number() as varchar(5)) + error_message()
end;
if @@TRANCOUNT > 0 
begin
	print 'Control point: ' + @point;
	rollback tran @point;
	commit tran;
	end;
end catch;

select * from FACULTY

--4

-----�������� A-----
	set transaction isolation level READ UNCOMMITTED;
	begin transaction
	-----T1-----
		select @@SPID, 'insert AUDITORIUM_TYPE' '���������', * from AUDITORIUM_TYPE
															   where AUDITORIUM_TYPE = '��';
		select @@SPID, 'update AUDITORIUM_TYPE' '���������', * from AUDITORIUM_TYPE
															   where AUDITORIUM_TYPE = '��';
	commit;
	-----T2-----

--5
--�� ��� ������ ��
set transaction isolation level READ COMMITTED
begin transaction
-----t1-------
select count(*) from PULPIT
where FACULTY = '��';

-----t2-------
select 'update PULPIT' '���������', count(*)
from PULPIT where FACULTY = '���';
commit;

--6
--�� ��� ������, ������ ��
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = '����';

--------t1---------
--------t2---------

select case
    when TEACHER = '���' THEN 'insert TEACHER'
	else ' '
	end '���������', TEACHER
FROM TEACHER WHERE PULPIT = '����';
commit;

--7
--�� ��� ���
set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = '�����';  
          insert TEACHER values ('�����', '������ ������ ���������', '�', '��');
          update TEACHER set TEACHER = '����' where TEACHER = '���';
          select TEACHER from TEACHER  where PULPIT = '��';

	-------------------------- t1 -----------------
	 select TEACHER from TEACHER  where PULPIT = '��';
	-------------------------- t2 ------------------ 
	commit; 
	

--8

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='����' where PULPIT.FACULTY = '����';
	commit;
	select * from PULPIT
 rollback;