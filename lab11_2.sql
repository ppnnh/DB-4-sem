-----Сценарий B-----
	begin transaction
		select @@SPID;
		insert AUDITORIUM_TYPE values ('СЗ', 'Спортивный зал');
		update AUDITORIUM_TYPE set AUDITORIUM_TYPENAME = 'Лекционный кабинет' where AUDITORIUM_TYPE = 'ЛК';
	
	-----T1-----
	-----T2-----
	rollback;


--5

begin transaction
------------t1
update PULPIT set FACULTY = 'ТОВ' 
where FACULTY = 'ИТ' 
commit; 
-------------------------- t2 --------------------	
	

--6

begin transaction 	  
	-------------------------- t1 --------------------
          insert TEACHER values ('ЕЕЕ', 'GGGGGGGG', 'м', 'ИСиТ');
          commit; 
	-------------------------- t2 --------------------
	select * from TEACHER

--7

begin transaction 
		  delete TEACHER where TEACHER = 'ИВНСБ';  
          insert TEACHER values ('ИВНСБ', 'Иванов Сергей Борисович', 'м', 'ЛУ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
          -------------------------- t1 --------------------
          commit; 
           select TEACHER from TEACHER  where PULPIT = 'ЛУ';
      -------------------------- t2 --------------------

--8
