--1
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.FIRST') )	            
	drop table FIRST;           
	declare @c int, @flag char = 'c';           -- commit или rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table FIRST(K int );                         -- начало транзакции 
		INSERT FIRST values (1),(2),(3);
		set @c = (select count(*) from FIRST);
		print 'количество строк в таблице FIRST: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
	          else   rollback;                                 -- завершение транзакции: откат  
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	    where OBJECT_ID= object_id(N'DBO.FIRST') )
		print 'таблица FIRST есть';  
    else print 'таблицы FIRST нет'

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
	then 'дублирование товара'
	else 'неизвестная ошибка:' +cast(error_number() as varchar(5)) + error_message()
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
	then 'дублирование товара'
	else 'неизвестная ошибка:' +cast(error_number() as varchar(5)) + error_message()
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

-----Сценарий A-----
	set transaction isolation level READ UNCOMMITTED;
	begin transaction
	-----T1-----
		select @@SPID, 'insert AUDITORIUM_TYPE' 'результат', * from AUDITORIUM_TYPE
															   where AUDITORIUM_TYPE = 'СЗ';
		select @@SPID, 'update AUDITORIUM_TYPE' 'результат', * from AUDITORIUM_TYPE
															   where AUDITORIUM_TYPE = 'ЛК';
	commit;
	-----T2-----

--5
--не доп неподт чт
set transaction isolation level READ COMMITTED
begin transaction
-----t1-------
select count(*) from PULPIT
where FACULTY = 'ИТ';

-----t2-------
select 'update PULPIT' 'результат', count(*)
from PULPIT where FACULTY = 'ТОВ';
commit;

--6
--не доп неподт, неповт чт
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = 'ИСиТ';

--------t1---------
--------t2---------

select case
    when TEACHER = 'ППП' THEN 'insert TEACHER'
	else ' '
	end 'результат', TEACHER
FROM TEACHER WHERE PULPIT = 'ИСиТ';
commit;

--7
--не доп все
set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = 'ИВНСБ';  
          insert TEACHER values ('ИВНСБ', 'Иванов Сергей Борисович', 'м', 'ЛУ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';

	-------------------------- t1 -----------------
	 select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t2 ------------------ 
	commit; 
	

--8

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='ХТиТ' where PULPIT.FACULTY = 'ХТиТ';
	commit;
	select * from PULPIT
 rollback;