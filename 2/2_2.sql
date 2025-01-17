Create Table Employee(
	emp_id int identity(1,1) Primary key,
	emp_name nvarchar(50),
	emp_salary int
)
Create Table Project(
	pro_id int identity(1,1) Primary key,
	pro_name nvarchar(10),
)
Create Table Empoloyee_Project(	
	pro_id int,
	emp_id int,
	Primary Key(pro_id,emp_id)	
)

INSERT INTO Employee(emp_name, emp_salary)
VALUES 
('manager', 100),
('b', 40),
('o', 20),
('c', 75),
('d', 45),
('a', 55),
('e', 60),
('b', 70),
('a', 85),
('f', 45),
('manager', 130),
('f', 110),
('h', 160),
('i', 50),
('g', 40),
('k', 200);

INSERT INTO Empoloyee_Project(pro_id, emp_id)
VALUES 
(1,1),
(1,2),
(1,3),
(2,4),
(2,5),
(2,6),
(2,7),
(2,8),
(3,9),
(3,10),
(4,11),
(4,12),
(4,13),
(4,14),
(4,15),
(4,16);

INSERT INTO Project(pro_name)
VALUES 
('A'),
('B'),
('C'),
('D');

