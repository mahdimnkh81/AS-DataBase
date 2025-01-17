/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [P_ID]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
  FROM [AsDB].[dbo].[Persons]

select * from Persons
order by LastName 

begin transaction t1 
alter table persons 
add phone nvarchar(10)
constraint phone_check check(phone like'001_______')
go
update persons
set phone =(case P_ID
when 1 then '0019123456'
when 2 then '0019123455'
when 3 then '0019123454'
when 4 then '0019123453'
 end)
commit tran t1;

select FirstName, LastName, Address, SquareName=(case P_ID
 when 1 then 'Ferdowsi sq.'
 when 2 then 'Emam sq.'
 when 3 then 'Valiasr sq.'
 when 4 then 'Azadi sq.'
 end
 ), BlockNumber=(case P_ID
 when 1 then 110
 when 2 then 90
 when 3 then 144
 when 4 then 57
 end
 )
from persons;



begin transaction t2
set identity_insert persons on
 insert into persons (P_ID, LastName, FirstName, Address, City, Phone)
 values (7, 'Tjessem', 'Jakob', 'Nissestien 67', 'Sandnes', '0019123451');
 set identity_insert persons off
 select p_id, LastName, FirstName
 from persons
 order by FirstName
commit tran t2;


waitfor delay '00:00:10';
select LastName, FirstName, City
from persons
where City like 'S%'

declare @temp int;
declare @i int;
select @temp =  max(P_ID) from persons
while @temp > 0
	begin
		print 'okay'
		set @temp = @temp - 1;
	end

declare @P_ID int;
set @P_ID = case when (select Phone from persons where LastName='Tjessem') > '0011234567' then 6
 else 8
 end
 set identity_insert persons on
insert into persons (P_ID, LastName, FirstName, Address, City, Phone)
values (@P_ID, 'taylor', 'jackson', 'Nisseisten 87', 'Sandnes', '0011234567')
set identity_insert persons off


create table students (
 name varchar(20),
 student_id int primary key,
 grade int
);
insert into students values
('R1', 8831047, 12),('R2', 8831043, 10),('R3', 8831031, 15),('R4', 8831051, 16),('R5', 8831012, 11);

declare @temp_tb table (
 name varchar(20),
 student_id int primary key,
 grade_new int,
 grade_old int
);
update students
set grade=grade+2
output inserted.name, inserted.student_id, inserted.grade, deleted.grade into @temp_tb
where grade<15;
select * from @temp_tb;