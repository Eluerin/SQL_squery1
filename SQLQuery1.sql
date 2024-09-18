--��1���߼�������䣨��֧�ṹ��ѭ���ṹ��
--��֧�ṹ��IF-ELSE��䡢CASE-END��䣩

------------IF-ELSE���(begin-end����{})

--ͳ�Ʋ���ʾ2009-2-17��Java Logic����ƽ����
--���ƽ������70���ϣ���ʾ�����Գɼ����㡱������ʾǰ����ѧ���Ŀ�����Ϣ
--�����70���£���ʾ�����Գɼ��ϲ������ʾ������ѧ���Ŀ�����Ϣ 
--1����ͳ�Ƴ�Java2009-2-12�յĿ���ƽ���֣��洢��������
use myschool
go

select *from result 
declare @avgscore float
set @avgscore = (select avg(studentresult) from result where subjectid = 3 and examdate = '2009-2-17')
print 'ƽ���ɼ��ǣ�'+cast(@avgscore as varchar(5))
go
--2������ҵ���߼��ж�
if @avgscore >= 70
begin
	print '���Գɼ�����'
	select top 3 *from result where subjectid =3 and examdate = '2009-2-17'	order by studentresult desc
end
else
begin
	print '���Գɼ��ϲ�'
	select top 3 *from result where subjectid =3 and examdate = '2009-2-17'	order by studentresult asc
end
go
--ͨ�����������򣨽���desc,����asc������top��������ʵ�ֲ�ѯ����ǰn�С���n��
--Ϊ��ͳһ�����ʽ��Ҫ��������-ѡ��-��ѯ���������Ϊ���ı���ʽ�������һ��������Ч

-----------------case���
--����case��䣬�ڲ�ѯ�Ĺ����У���ʾѧ���ĳɼ��ȼ�
select top 10 studentno,studentresult,level = 
	case
		when studentresult <60 then 'E'
		when studentresult>=60 and studentrresult <70 then 'D'
		when studentresult>=70 and studentrresult <80 then 'C'
		when studentresult>=80 and studentrresult <90 then 'C'
		else 'A'
end
from result
go


--ѭ���ṹ��WHILE��䣩--������������Ĳ���

--���ѧ����Winforms�������һ�ο����Ƿ��в�����(60�ּ���)��ѧ����
--���У�ÿ�˼�2�֣�����95�ֵ�ѧ�����ټӷ֣�ֱ������ѧ����ο��Գɼ�������I


--1����Ҫ֪��winforms�γ̵ı�ţ����һ�ο��Ե����ڣ�ͳ�Ʋ��ϸ������
declare @subjectno int
declare @latestdate datetime
declare @notpass_count int

set @subjectno =(select subjectid from subject where subjectname = 'XXX')
set @latestdate = (select max(examdate) from result where subjectid = @subjectno)
--set @notpass_count = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)

--2�������ѧ���ɼ��Բ�����
--if @notpass_count>0
--begin
--	update result set studentresult = studentresult +2 where studentresult <95 and subjectid = @subjectno
--	set @notpass_count  = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)
--end
--go
--һ��ѭ��

while 1=1
--��ѭ��������������������ѭ��
begin
	set @notpass_count  = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)
	if @notpass_count = 0
		break
	else
		update result set studentresult = studentresult +2 where studentresult <95 and subjectid = @subjectno	
end
go


------������(������go���)
--���ڴ���������֮���г�ͻ�Ķ������
declare @age int
set @age = 13
go

declare @age int
set @age = 30





--��2������
use sto
go


--����һ���������ݿ�
create database bankDB
go

--����һ�����ݱ�
create table bank
(
	customername varchar(50) primary key not null,
	currentmoney money 
)
go

alter table bank
	add constraint ck_bank_currentmoney check(currentmoney >=1)
go

insert into bank values('����',1000)
insert into bank(customername,currentmoney)
	values('����',1)
go

select *from bank
go

---ģ��ת��ҵ�������˻�ת500�����ģ�
update bank set currentmoney = currentmoney -500 where customername = '����'
update bank set currentmoney = currentmoney +500 where customername = '����'
select *from bank
go
--��ת�ʷ�����Ϊ0ʱ��������checkԼ����ì�ܣ��ᵼ�¸��˻����û���٣����Ǳ�ת�˷���������ˣ����ִ����Ӱ�����о���
--����������

--����(TRANSACTION)����Ϊ�����߼�������Ԫִ�е�һϵ�в����������
--��Ϊһ��������ϵͳ�ύ��Ҫô��ִ�С�Ҫô����ִ��
--������һ�����ɷָ�Ĺ����߼���Ԫ

--������������ԣ�ACID���ԣ�
--ԭ����(Atomicity)
--������һ�������Ĳ���������ĸ��������ǲ��ɷֵ�(ԭ�ӵ�)��Ҫô��ִ�У�Ҫô����ִ��
--һ����(Consistency)
--���������ʱ�����ݱ��봦��һ��״̬������ת��ǰ���ܶ�䣩
--������(lsolation)
--��������֮��˴˸��롢����������Ӧ���κη�ʽ�����ڻ�Ӱ��������������һ��ת�˵�ʧ�ܲ�Ӱ����һ��ת�ˣ�
--������(Durability)
--������ɺ�,�������ݿ���޸ı����ñ��֣������ݿ���޸��������Եģ�


--��ʼ����
begin transaction
--�ύ����---�������
commit transaction
--�ع�������������----�������
rollback transaction

--����ȫ�ֱ���@@error�ж�����������t-sql����Ƿ��д�(�������ۼ�)
declare @errorsum int
set @errorsum = @errorsum+@@error
print @errorsum

--��ʽ����
--����BEGIN TRANSACTION��ȷָ������Ŀ�ʼ
--����õ���������
--��������
--��ͨ������SETIMPLICIT TRANSACTIONS ON��䣬����������ģʽ����Ϊ��
--������T-SQL����Զ�����һ��������
--���ύ��ع�һ���������һ�� T-SQL����ֽ�����һ��������
--�Զ��ύ����
--��SQL Server ��Ĭ��ģʽ
--��ÿ�������� T-SQL�����Ϊһ������

use bankdb
go

select *from bank
update bank set currentmoney = 1 where customername = '����'
update bank set currentmoney = 1000 where customername = '����'
select *from bank

-------ʹ������ʵ��ת��ҵ��(ת1000)
--1����ʽ����һ������
begin transaction
--���������������ۼƴ�����Ϣ
declare @errorsum int
set @errorsum = 0
print 'ת��֮ǰ��״̬'
select *from bank

--2��ת��
update bank set currentmoney =currentmoney -1000 where customername = '����'
set @errorsum = @errorsum + @@error
update bank set currentmoney = currentmoney +1000 where customername = '����'
set @errorsum = @errorsum +@@error
print 'ת���е�״̬'
select *from bank

--3���ж�ת���Ƿ�ɹ���<>��ʾ�����ڣ�
if @errorsum <>0
	begin
		print '����ʧ�ܣ��ع�����'		
		rollback transaction
	end
else 
	begin
		print '���׳ɹ����ύ����д��Ӳ�̣����õı���'
		commit transaction
	end
print 'ת�˽���'
select *from bank
go

-------����һ���µ�����ת��800transfer��
begin transaction
--���������������ۼƴ�����Ϣ
declare @errorsum int
declare @transfer money
set @errorsum = 0
set @transfer = 800
print 'ת��֮ǰ��״̬'
select *from bank

--2��ת��
update bank set currentmoney =currentmoney -@transfer where customername = '����'
set @errorsum = @errorsum + @@error
update bank set currentmoney = currentmoney +@transfer where customername = '����'
set @errorsum = @errorsum +@@error
print 'ת���е�״̬'
select *from bank

--3���ж�ת���Ƿ�ɹ���<>��ʾ�����ڣ�
if @errorsum <>0
	begin
		print '����ʧ�ܣ��ع�����'		
		rollback transaction
	end
else 
	begin
		print '���׳ɹ����ύ����д��Ӳ�̣����õı���'
		commit transaction
	end
print 'ת�˽���'
select *from bank
go

--����ת�ˣ���Ϊ����ͬһ�����ݿ⣬����ʹ������
--��������������ʵ�֣���������




--------��ͼ---------
---��ͬ����Ա��ע��ͬ������
--��֤ԭʼ��Ϣ�İ�ȫ��

--��ͼ�ĸ���
----<��ͼ��һ�������>
---��������ʾһ�ű�Ĳ������ݻ���ű���ۺ�����
---��������ṹ�������ǽ����ڶԱ�Ĳ�ѯ������
----<��ͼ�в��������>
--���������ݴ������ͼ�����õ�ԭʼ����
--������һ��ԭʼ�����ݲ�ͬ�û��Ĳ�ͬ���󣬿��Դ�����ͬ����ͼ


--��ͼ����;
--����ɸѡ���е��� I
--������ֹδ����ɵ��û�������������
--����<�������ݿ�ĸ��ӳ̶�>
--����<������������ݿ����Ϊһ���߼����ݿ�>

--������ͼ
--�������ù��������������ݿ�-��ͼ-�½�-��ӱ�-����У�
--��ѯ��ͼ����ͼ������������ò��Ĳ�����ѯ��ͼ
select *from v_student


--������ɾ����ͼ
if exists(select *from sysobjects where name = 'v_student')
	drop view v_student

--��������t-sql��䴴��
--����һ����Ա����ͼ���鿴ѧ���Ŀ��Գɼ�������Ҫ�г����ԵĿ�Ŀ��ѧ�����������������Լ����Գɼ�
if exists(select *from sysobjects where name = 'v_teacher')
	drop view v_teacher
go

create view v_teacher 
as
select st.studentname, su.subjectname, r.examdate, r.studentresult from result r
	inner join student st on r.studentno = st.studentno
	inner join subject su on r.subjectno = su.subjectno 
	where su.subjectname = ''
	order by st.studentno 
go

--����һ�������ε���ͼ��ѧ�š��������꼶���������ܷ���
if exists(select *from sysobjects where name = 'v_headmaster')
	drop view v_headmaster
go

create view v_headmaster 
as
select st.studentno, st.studentname,g.gradename, (select sum(r.studentresult) as totalscore from result r where r.studentno = st.studentno)
	from student st
	left join grade g on st.gradeid = g.subjectno
	where g.gradename = ''
	order by st.studentno 
go

--ע�⣺
--��ͼ����ʹ�ö����
--һ����ͼ����Ƕ����һ����ͼ�������á�������һ����ͼ��
--��ͼ�ж����select��䲻������orderby���-��ѯ��ͼʱ�ټӡ�into�ؼ��֡�������ʱ��ͱ�����







------����--------
--indexes use key values to locate data


--��������
--1������Ψһ���������������о�����ͬ����ֵ��
--2����������������Ψһ�������������ͣ�������գ�
--3�������ۼ�����Clustered�����и��е�����˳�����ֵ���߼���������˳����ͬ��
-------���磬ƴ��˳��a-b-c����ѧ��˳��(1-2-3-4-5-6-7-8)
-------����һ������ʱ����Ҫ���䰲����ԭ�����߼���λ���ϣ���������ѧ��2019001����Ҫ�ӵ�2019000��2019002֮��
-------�ۼ�����һ�����ݿ���ֻ����һ�������������ѧ�ţ��Ͳ����ڰ�������
--4�������Ǿۼ�����Non-clustered�����������ҳ��˳�򣬲��ᱣ�����ݱ����˳��
-------�����ֵ����ƫ�ԣ���ֻ��������ƫ������һҳ������û���߼�˳��

--��ѧ���������б����һ���Ǿۼ�����
if exists(select *from sysindexes where name = 'Ix_student_studentname')
	drop index student.Ix_student_studentname
go

create nonclustered
--unique/clustered/nonclustered 
	index Ix_student_studentname
	on student(studentname)
	with fillfactor = 30
go
--������ӣ�ÿ������ҳ����������Ϊ�˺����������
--�����Ѿ��Ǿۼ������ˣ�����ֻ�ܴ�����ķǾۼ�����

--��ָ��������ѯ���ݣ�Ix_student_studentname��
select *from student
with (index = Ix_student_studentname)
where studentname like '��%'
--ʵ���ϣ�with��������д�ڴ����У���Ϊ���������Զ���������

--��������ȱ��
--�ŵ㣺
--�����ӿ�����ٶ�
--������ǿ�е�Ψһ��
--ȱ�㣺
--�����������ı������ݿ�����Ҫ����Ĵ洢�ռ�
--�����������ݵ�������Ҫ�����Ĵ���ʱ�䣬��Ϊ������Ҫ���������и���

--����������ָ��ԭ��
--�������б�׼ѡ������������
--��Ƶ����������I
--������������ѯѡ����о������򡢷�����С�
--�������������ӵ���(����/���)
--�벻Ҫʹ��������д�������
--��������������ֵͬ����
--�����н���������

--ʹ������ʱ��ע������
--������ѯʱ����ʹ��*����ȫ���У���Ҫ���ز���Ҫ���У�����������д����Ҫ��*�죩
--��������Ӧ�þ���С�����ֽ���С�����Ͻ������������������������������ģ�
--����where�Ӿ����ж���������ʽʱ�����������еı��ʽ��with�Ӿ䣩Ӧ���������������ʽ֮ǰ
--����������order by�Ӿ���ʹ�ñ��ʽ��order by�Ӿ����ֱ�ӽ�������
--��������ҵ�����ݷ���Ƶ�ʣ������������ɻ�������֯������������Ƭ����


--�鿴����
--�鿴student���������Ϣ
exec sp_helpindex'student'
--ʹ����ͼsys.indexes�鿴����
select *from sys.indexes
--�鿴shujuku ȫ��������Ϣ
use bankdb
select *from sys.indexes