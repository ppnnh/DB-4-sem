Use UNIVER;


--1--
GO
CREATE procedure PSUBJECT_1
as begin
	SELECT SUBJECT [���], SUBJECT_NAME [����������], PULPIT [�������] from SUBJECT;
	DECLARE @k int = (SELECT count(*) from SUBJECT);
	return @k;
end;
GO

exec PSUBJECT_1;

GO
DECLARE @k2 int;
EXEC @k2 = PSUBJECT_1; -- ����� ��������� 
print '���������� ���������: ' + cast(@k2 as varchar(30));
GO

DROP procedure PSUBJECT_1;


--2--
GO
ALTER procedure PSUBJECT_1 @p varchar(20), @c nvarchar(2) output
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
	set @c = cast(@@rowcount as nvarchar(2));
end;
GO

GO
DECLARE @k1 int, @k2 nvarchar(2);
EXEC @k1 = PSUBJECT_1 @p = '����', @c = @k2 output;
print '���������� ���������: ' + @k2;
GO


--3--
GO
ALTER procedure PSUBJECT_1 @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;
GO

GO
CREATE table #SUBJECT
(
	���_������� varchar(20),
	��������_�������� varchar(100),
	������� varchar(20)
);

INSERT #SUBJECT EXEC PSUBJECT_1 @p = '���';
INSERT #SUBJECT EXEC PSUBJECT_1 @p = '����';

SELECT * from #SUBJECT;
GO

drop table #SUBJECT

--4--
drop procedure PAUDITORIUM_INSERT

go
CREATE procedure PAUDITORIUM_INSERT --���-��
		@a char(20), --AUDITORIUM
		@n varchar(50),--AUDITORIUM, AUDITORIUM_NAME
		@c int = 0, --AUDITORIUM_CAPACITY 
		@t char(10) --AUDITORIUM_TYPE 
as begin 

begin try
	INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values(@a, @n, @c, @t);
	return 1;
end try

begin catch
	print '����� ������: ' + cast(error_number() as varchar(6));
	print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar(6));
	print '�����: ' + cast(error_state() as varchar(8));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print '��� ���������: ' + error_procedure();
	return -1;
end catch;

end;

DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = 5, @n = '��', @c = 100, @t = '113-5'; 
print 'Return: ' + cast(@rc as varchar(3));
go

select * from AUDITORIUM

delete AUDITORIUM where AUDITORIUM='313-1';
DROP procedure PAUDITORIUM_INSERT;



--5--
drop procedure SUBJECT_REPORT;

GO
CREATE procedure SUBJECT_REPORT @p char(10) 
as begin
DECLARE @rc int = 0;

begin try
	DECLARE @sb char(10), @r varchar(100) = '';

	DECLARE sbj CURSOR for --������
		SELECT SUBJECT from SUBJECT where PULPIT = @p;

	if not exists(SELECT SUBJECT from SUBJECT where PULPIT = @p)--� ���� catch
		raiserror('������', 11, 1);

	else 
	OPEN sbj;
	fetch sbj into @sb;
	while @@fetch_status = 0

	begin
		set @r = rtrim(@sb) + ', ' + @r;  
		set @rc = @rc + 1;
		fetch sbj into @sb;
	end

	print '��������: ' + @r;
	close sbj;
	deallocate  sbj;
	return @rc;

end try

begin catch
	print '������ � ����������' 
	if error_procedure() is not null   
	print '��� ���������: ' + error_procedure();
	return @rc;
end catch;
end;
GO

DECLARE @k2 int;  
EXEC @k2 = SUBJECT_REPORT @p ='����';  
print '���������� ���������: ' + cast(@k2 as varchar(3));
go



--6
drop procedure PAUDITORIUM_INSERTX;

GO
CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	--��������, ��� ����� �������� � AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

as begin
DECLARE @rc int = 1;

begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t; 
	commit tran;
	return @rc;
end try

begin catch
	print '����� ������: ' + cast(error_number() as varchar(6));
print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar(6));
	print '�����: ' + cast(error_state() as varchar(8));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if error_procedure() is not  null   
	print '��� ���������: ' + error_procedure(); 
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;

end;
GO


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '789-1', @n = '����', @c = 85, @t = '789-1', @tn = '����'; 
print '����������: ' + cast(@k3 as varchar(3));
go
select * from AUDITORIUM
select * from  AUDITORIUM_TYPE
go
delete AUDITORIUM where AUDITORIUM='789-1';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='����';
go







--go
--use K_MyBase_Session
--go
--CREATE procedure SESSION_INSERT --���-��
--		@dn int, --DOC NIUM
--		@i int,--ID
--		@sn nvarchar(20), --SUB NAME
--		@m int, --MARK
--		@d date --DATE
--as begin 

--begin try
--	INSERT into Session(Documentation_Number, Strudent_Id, Subject_Name, Mark, Date)
--		values(@dn, @i, @sn, @m, @d);
--	return 1;
--end try

--begin catch
--	print '����� ������: ' + cast(error_number() as varchar(6));
--	print '���������: ' + error_message();
--	print '�������: ' + cast(error_severity() as varchar(6));
--	print '�����: ' + cast(error_state() as varchar(8));
--	print '����� ������: ' + cast(error_line() as varchar(8));
--	if error_procedure() is not null   
--	print '��� ���������: ' + error_procedure();
--	return -1;
--end catch;

--end;
--GO
--DECLARE @rc int;  
--DECLARE @CD DATE = GETDATE();
--EXEC @rc = SESSION_INSERT @dn = 1111, @i = 1, @sn = '����', @m = 10, @d = @CD; 
--print '����������: ' + cast(@rc as varchar(3));
--go

--select * from Session

--delete Session where Documentation_Number=1111;
--DROP procedure SESSION_INSERT;
