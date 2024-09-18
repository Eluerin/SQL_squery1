--《1》逻辑控制语句（分支结构、循环结构）
--分支结构（IF-ELSE语句、CASE-END语句）

------------IF-ELSE语句(begin-end代替{})

--统计并显示2009-2-17的Java Logic考试平均分
--如果平均分在70以上，显示“考试成绩优秀”，并显示前三名学生的考试信息
--如果在70以下，显示“考试成绩较差”，并显示后三名学生的考试信息 
--1、先统计出Java2009-2-12日的考试平均分，存储到变量中
use myschool
go

select *from result 
declare @avgscore float
set @avgscore = (select avg(studentresult) from result where subjectid = 3 and examdate = '2009-2-17')
print '平均成绩是：'+cast(@avgscore as varchar(5))
go
--2、进行业务逻辑判断
if @avgscore >= 70
begin
	print '考试成绩优秀'
	select top 3 *from result where subjectid =3 and examdate = '2009-2-17'	order by studentresult desc
end
else
begin
	print '考试成绩较差'
	select top 3 *from result where subjectid =3 and examdate = '2009-2-17'	order by studentresult asc
end
go
--通过升降序排序（降序desc,升序asc），用top函数可以实现查询数据前n行、后n行
--为了统一输出格式，要将（工具-选项-查询结果）设置为以文本形式输出、下一个窗口生效

-----------------case语句
--利用case语句，在查询的过程中，显示学生的成绩等级
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


--循环结构（WHILE语句）--用于批量处理的操作

--检查学生“Winforms”课最近一次考试是否有不及格(60分及格)的学生。
--如有，每人加2分，高于95分的学生不再加分，直至所有学生这次考试成绩均及格I


--1、需要知道winforms课程的编号；最近一次考试的日期，统计不合格的人数
declare @subjectno int
declare @latestdate datetime
declare @notpass_count int

set @subjectno =(select subjectid from subject where subjectname = 'XXX')
set @latestdate = (select max(examdate) from result where subjectid = @subjectno)
--set @notpass_count = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)

--2、如果该学生成绩仍不及格
--if @notpass_count>0
--begin
--	update result set studentresult = studentresult +2 where studentresult <95 and subjectid = @subjectno
--	set @notpass_count  = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)
--end
--go
--一次循环

while 1=1
--死循环，后面设立条件结束循环
begin
	set @notpass_count  = (select count(*) from result where examdate = @latestdate and subjectid = @subjectno and studentresult <60)
	if @notpass_count = 0
		break
	else
		update result set studentresult = studentresult +2 where studentresult <95 and subjectid = @subjectno	
end
go


------批处理(分批用go语句)
--用于处理可能语句之间有冲突的多项操作
declare @age int
set @age = 13
go

declare @age int
set @age = 30





--《2》事务
use sto
go


--创建一个银行数据库
create database bankDB
go

--创建一个数据表
create table bank
(
	customername varchar(50) primary key not null,
	currentmoney money 
)
go

alter table bank
	add constraint ck_bank_currentmoney check(currentmoney >=1)
go

insert into bank values('张三',1000)
insert into bank(customername,currentmoney)
	values('李四',1)
go

select *from bank
go

---模拟转账业务（张三账户转500给李四）
update bank set currentmoney = currentmoney -500 where customername = '张三'
update bank set currentmoney = currentmoney +500 where customername = '李四'
select *from bank
go
--当转帐方余额变为0时，由于与check约束相矛盾，会导致该账户余额没减少，但是被转账方余额增加了，这种错误会影响银行经济
--引出‘事务’

--事务(TRANSACTION)是作为单个逻辑工作单元执行的一系列操作多个操作
--作为一个整体向系统提交，要么都执行、要么都不执行
--事务是一个不可分割的工作逻辑单元

--事务的四种属性（ACID属性）
--原子性(Atomicity)
--事务是一个完整的操作，事务的各步操作是不可分的(原子的)，要么都执行，要么都不执行
--一致性(Consistency)
--当事务完成时，数据必须处于一致状态（例如转账前后总额不变）
--隔离性(lsolation)
--并发事务之间彼此隔离、独立，它不应以任何方式依赖于或影响其他事务（例如一笔转账的失败不影响另一笔转账）
--永久性(Durability)
--事务完成后,它对数据库的修改被永久保持（对数据库的修改是永久性的）


--开始事务
begin transaction
--提交事务---事务结束
commit transaction
--回滚（撤销）事务----事务结束
rollback transaction

--利用全局变量@@error判断事务中所有t-sql语句是否有错(将错误累加)
declare @errorsum int
set @errorsum = @errorsum+@@error
print @errorsum

--显式事务
--·用BEGIN TRANSACTION明确指定事务的开始
--·最常用的事务类型
--隐性事务
--·通过设置SETIMPLICIT TRANSACTIONS ON语句，将隐性事务模式设置为打开
--·其后的T-SQL语句自动启动一个新事务
--·提交或回滚一个事务后，下一个 T-SQL语句又将启动一个新事务
--自动提交事务
--·SQL Server 的默认模式
--·每条单独的 T-SQL语句视为一个事务

use bankdb
go

select *from bank
update bank set currentmoney = 1 where customername = '李四'
update bank set currentmoney = 1000 where customername = '张三'
select *from bank

-------使用事务实现转账业务(转1000)
--1、显式开启一个事务
begin transaction
--声明变量，用于累计错误信息
declare @errorsum int
set @errorsum = 0
print '转账之前的状态'
select *from bank

--2、转账
update bank set currentmoney =currentmoney -1000 where customername = '张三'
set @errorsum = @errorsum + @@error
update bank set currentmoney = currentmoney +1000 where customername = '李四'
set @errorsum = @errorsum +@@error
print '转账中的状态'
select *from bank

--3、判断转账是否成功（<>表示不等于）
if @errorsum <>0
	begin
		print '交易失败，回滚事务'		
		rollback transaction
	end
else 
	begin
		print '交易成功，提交事务，写入硬盘，永久的保存'
		commit transaction
	end
print '转账结束'
select *from bank
go

-------开启一批新的事务（转账800transfer）
begin transaction
--声明变量，用于累计错误信息
declare @errorsum int
declare @transfer money
set @errorsum = 0
set @transfer = 800
print '转账之前的状态'
select *from bank

--2、转账
update bank set currentmoney =currentmoney -@transfer where customername = '张三'
set @errorsum = @errorsum + @@error
update bank set currentmoney = currentmoney +@transfer where customername = '李四'
set @errorsum = @errorsum +@@error
print '转账中的状态'
select *from bank

--3、判断转账是否成功（<>表示不等于）
if @errorsum <>0
	begin
		print '交易失败，回滚事务'		
		rollback transaction
	end
else 
	begin
		print '交易成功，提交事务，写入硬盘，永久的保存'
		commit transaction
	end
print '转账结束'
select *from bank
go

--跨行转账：因为不是同一个数据库，不能使用事务
--借助第三方机构实现：比如银联




--------视图---------
---不同的人员关注不同的数据
--保证原始信息的安全性

--视图的概念
----<视图是一张虚拟表>
---···表示一张表的部分数据或多张表的综合数据
---···其结构和数据是建立在对表的查询基础上
----<视图中不存放数据>
--···数据存放在视图所引用的原始表中
--···一个原始表，根据不同用户的不同需求，可以创建不同的视图


--视图的用途
--··筛选表中的行 I
--··防止未经许可的用户访问敏感数据
--··<降低数据库的复杂程度>
--··<将多个物理数据库抽象为一个逻辑数据库>

--创建视图
--···用管理器创建（数据库-视图-新建-添加表-添加列）
--查询视图，视图是虚拟表，可以用查表的操作查询视图
select *from v_student


--···删除视图
if exists(select *from sysobjects where name = 'v_student')
	drop view v_student

--···用t-sql语句创建
--创建一个教员的视图，查看学生的考试成绩，但需要列出考试的科目、学生姓名、考试日期以及考试成绩
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

--创建一个班主任的视图：学号、姓名、年级名、考试总分数
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

--注意：
--视图可以使用多个表
--一个视图可以嵌套另一个视图（即引用、连接另一个视图）
--视图中定义的select语句不包括（orderby语句-查询视图时再加、into关键字、引用临时表和变量）







------索引--------
--indexes use key values to locate data


--索引类型
--1···唯一索引（不允许两行具有相同索引值）
--2···主键索引（唯一索引的特殊类型，不允许空）
--3···聚集索引Clustered（表中各行的物理顺序与键值的逻辑（索引）顺序相同）
-------比如，拼音顺序（a-b-c）、学号顺序(1-2-3-4-5-6-7-8)
-------新增一条数据时，需要将其安置在原物理逻辑的位置上，比如新增学号2019001，就要加到2019000和2019002之间
-------聚集索引一个数据库中只能有一个，如果按照了学号，就不能在按照名字
--4···非聚集索引Non-clustered（保存的数据页的顺序，不会保存数据本身的顺序）
-------比如字典里的偏旁，他只会告诉这个偏旁在哪一页，本身没有逻辑顺序

--给学生表名字列表添加一个非聚集索引
if exists(select *from sysindexes where name = 'Ix_student_studentname')
	drop index student.Ix_student_studentname
go

create nonclustered
--unique/clustered/nonclustered 
	index Ix_student_studentname
	on student(studentname)
	with fillfactor = 30
go
--填充因子：每个数据页不会填满，为了后续添加数据
--主键已经是聚集索引了，所以只能创建别的非聚集索引

--按指定索引查询数据（Ix_student_studentname）
select *from student
with (index = Ix_student_studentname)
where studentname like '李%'
--实际上，with索引不用写在代码中，因为有索引会自动采用索引

--索引的优缺点
--优点：
--··加快访问速度
--··加强行的唯一性
--缺点：
--··带索引的表在数据库中需要更多的存储空间
--··操纵数据的命令需要更长的处理时间，因为他们需要对索引进行更新

--创建索引的指导原则
--按照下列标准选择建立索引的列
--·频繁搜索的列I
--·经常用作查询选择的列经常排序、分组的列。
--·经常用作连接的列(主键/外键)
--请不要使用下面的列创建索引
--·仅包含几个不同值的列
--·表中仅包含几行

--使用索引时的注意事项
--··查询时减少使用*返回全部列，不要返回不需要的列（把所有列名写出来要比*快）
--··索引应该尽量小，在字节数小的列上建立索引（给标题坐索引，而非正文）
--··where子句中有多个条件表达式时，包含索引列的表达式（with子句）应置于其他条件表达式之前
--··避免在order by子句中使用表达式（order by子句最好直接接列名）
--··根据业务数据发生频率，定期重新生成或重新组织索引，进行碎片整理


--查看索引
--查看student表的索引信息
exec sp_helpindex'student'
--使用视图sys.indexes查看索引
select *from sys.indexes
--查看shujuku 全部索引信息
use bankdb
select *from sys.indexes