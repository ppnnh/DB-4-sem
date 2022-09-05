use SHA_UNIVER;
go

--1
SELECT TEACHER.TEACHER_NAME [TEACHER_NAME], TEACHER.PULPIT [PULPIT] 
FROM TEACHER WHERE TEACHER.PULPIT = 'ИСиТ' 
for xml path, root('Список_преподавателей_кафедры_ИСиТ');
go

--2
SELECT AUDITORIUM.AUDITORIUM_NAME [AUDITORIUM_NAME], 
	   AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [AUDITORIUM_TYPENAME], 
	   AUDITORIUM.AUDITORIUM_CAPACITY [AUDITORIUM_CAPACITY]
FROM AUDITORIUM, AUDITORIUM_TYPE WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
											AND
										AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = 'Лекционная'
for xml AUTO, root('Список_аудиторий'), elements;
go

--3
DECLARE @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="ДП" название="Дизайн приложений" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="ОС" название="Основы социологии" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj; --подготовка
INSERT SUBJECT SELECT[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));

SELECT * FROM SUBJECT;
go

--4
INSERT INTO STUDENT([NAME], BDAY, INFO) values( 'Иванов И.И.', '01.02.2002',
                                                          '<студент>
														     <паспорт серия="МС" номер="876754" дата="19.02.2002" />
															 <телефон>+375294557647</телефон>
															 <адрес>
															    <страна>Беларусь</страна>
																<город>Минск</город>
																<улица>БГТУ</улица>
																<дом>10</дом>
																<квартира>20</квартира>
															 </адрес>
														  </студент>');

SELECT [NAME], BDAY, INFO FROM STUDENT WHERE [NAME] = 'Иванов И.И.';

UPDATE STUDENT set INFO = '<студент>
								<паспорт серия="МС" номер="876754" дата="19.02.2002" />
								<телефон>+375294557647</телефон>
								<адрес>
									<страна>Беларусь</страна>
									<город>Минск</город>
									<улица>БГТУ</улица>
									<дом>31</дом>
									<квартира>11</квартира>
								</адрес>
							</студент>'
WHERE [NAME] = 'Иванов И.И.';

SELECT [NAME] [ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
					 INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
					 INFO.query('/студент/адрес')[Адрес]
FROM STUDENT WHERE [NAME] = 'Пупкин А.С.';   
go


--4 

insert into STUDENT(IDGROUPS, NAME, BDAY, INFO) values(22, 'Буранко В.Д.', '07.02.2003',
                                                          '<студент>
														     <паспорт серия="AB" номер="1234567" дата="07.02.2003" />
															 <телефон>+375291802623</телефон>
															 <адрес>
															    <страна>Беларусь</страна>
																<город>Минск</город>
																<улица>Райниса</улица>
																<дом>5</дом>
																<квартира>21</квартира>
															 </адрес>
														  </студент>');
select * from STUDENT where NAME = 'Буранко В.Д.';
update STUDENT set INFO = '<студент>
					           <паспорт серия="AB" номер="1234567" дата="07.02.2003" />
						       <телефон>+375291802623</телефон>
							   <адрес>
								  <страна>Беларусь</страна>
								  <город>Минск</город>
								  <улица>Белорусская</улица>
	         					  <дом>18</дом>
								  <квартира>1</квартира>
								</адрес>
							 </студент>'
where NAME = 'Буранко В.Д.';
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Буранко В.Д.';       



--5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:string"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='Иванов И.И.'


create xml schema collection Student as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified"
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);


drop XML SCHEMA COLLECTION Student;	

create xml SCHEMA collection Myschema as
'<?xml version="1.0" encoding="UTF-8" ?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="shiporder">
      <xs:complexType>
         <xs:sequence>
            <xs:element name="orderperson" type="xs:string"/>
            <xs:element name="shipto">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="name" type="xs:string"/>
                     <xs:element name="address" type="xs:string"/>
                     <xs:element name="city" type="xs:string"/>
                     <xs:element name="country" type="xs:string"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
            <xs:element name="item" maxOccurs="unbounded">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="title" type="xs:string"/>
                     <xs:element name="note" type="xs:string" minOccurs="0"/>
                     <xs:element name="quantity" type="xs:positiveInteger"/>
                     <xs:element name="price" type="xs:decimal"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
         </xs:sequence>
         <xs:attribute name="orderid" type="xs:string" use="required"/>
      </xs:complexType>
   </xs:element>
</xs:schema>'

drop XML SCHEMA COLLECTION Myschema;	

