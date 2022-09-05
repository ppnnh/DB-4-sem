use SHA_UNIVER;
go

--1
SELECT TEACHER.TEACHER_NAME [TEACHER_NAME], TEACHER.PULPIT [PULPIT] 
FROM TEACHER WHERE TEACHER.PULPIT = '����' 
for xml path, root('������_��������������_�������_����');
go

--2
SELECT AUDITORIUM.AUDITORIUM_NAME [AUDITORIUM_NAME], 
	   AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [AUDITORIUM_TYPENAME], 
	   AUDITORIUM.AUDITORIUM_CAPACITY [AUDITORIUM_CAPACITY]
FROM AUDITORIUM, AUDITORIUM_TYPE WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
											AND
										AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '����������'
for xml AUTO, root('������_���������'), elements;
go

--3
DECLARE @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <����������>
					     <���������� ���="��" ��������="������ ����������" �������="����" />
						 <���������� ���="���" ��������="������ ������ ����������" �������="����" />
						 <���������� ���="��" ��������="������ ����������" �������="����" />
					  </����������>';
exec sp_xml_preparedocument @h output, @sbj; --����������
INSERT SUBJECT SELECT[���], [��������], [�������] from openxml(@h, '/����������/����������',0)
    with([���] char(10), [��������] varchar(100), [�������] char(20));

SELECT * FROM SUBJECT;
go

--4
INSERT INTO STUDENT([NAME], BDAY, INFO) values( '������ �.�.', '01.02.2002',
                                                          '<�������>
														     <������� �����="��" �����="876754" ����="19.02.2002" />
															 <�������>+375294557647</�������>
															 <�����>
															    <������>��������</������>
																<�����>�����</�����>
																<�����>����</�����>
																<���>10</���>
																<��������>20</��������>
															 </�����>
														  </�������>');

SELECT [NAME], BDAY, INFO FROM STUDENT WHERE [NAME] = '������ �.�.';

UPDATE STUDENT set INFO = '<�������>
								<������� �����="��" �����="876754" ����="19.02.2002" />
								<�������>+375294557647</�������>
								<�����>
									<������>��������</������>
									<�����>�����</�����>
									<�����>����</�����>
									<���>31</���>
									<��������>11</��������>
								</�����>
							</�������>'
WHERE [NAME] = '������ �.�.';

SELECT [NAME] [���], INFO.value('(�������/�������/@�����)[1]', 'char(2)')[����� ��������],
					 INFO.value('(�������/�������/@�����)[1]', 'varchar(20)')[����� ��������],
					 INFO.query('/�������/�����')[�����]
FROM STUDENT WHERE [NAME] = '������ �.�.';   
go


--4 

insert into STUDENT(IDGROUPS, NAME, BDAY, INFO) values(22, '������� �.�.', '07.02.2003',
                                                          '<�������>
														     <������� �����="AB" �����="1234567" ����="07.02.2003" />
															 <�������>+375291802623</�������>
															 <�����>
															    <������>��������</������>
																<�����>�����</�����>
																<�����>�������</�����>
																<���>5</���>
																<��������>21</��������>
															 </�����>
														  </�������>');
select * from STUDENT where NAME = '������� �.�.';
update STUDENT set INFO = '<�������>
					           <������� �����="AB" �����="1234567" ����="07.02.2003" />
						       <�������>+375291802623</�������>
							   <�����>
								  <������>��������</������>
								  <�����>�����</�����>
								  <�����>�����������</�����>
	         					  <���>18</���>
								  <��������>1</��������>
								</�����>
							 </�������>'
where NAME = '������� �.�.';
select NAME[���], INFO.value('(�������/�������/@�����)[1]', 'char(2)')[����� ��������],
	INFO.value('(�������/�������/@�����)[1]', 'varchar(20)')[����� ��������],
	INFO.query('/�������/�����')[�����]
		from  STUDENT
			where NAME = '������� �.�.';       



--5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:string"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='������ �.�.'


create xml schema collection Student as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified"
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
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

